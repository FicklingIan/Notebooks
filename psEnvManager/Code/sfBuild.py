# ********************************************************************************
# Legal:     This code is provided as is with no warranty or support.
#            This is NOT a Snowflake product and Snowflake hold no accountability
#            as to its usage.
#
# File:      sfBuild.py
#
# Purpose:   Callable script.  Builds an environment based on the RBAC spreadsheet
#
# History:
# Date        |  Author             | Action
#-------------+---------------------+----------------------------------------
# 31-Mar-2020 |  Ian Fickling       |  Version 1.0
# 27-Oct-2023 |  Ian Fickling       | Added support for database roles.
#             |                     | The CONFIG tab has 2 new TYPEs
#             |                     | - ROLE_TYPES
#             |                     | - INCLUDE_ENV_IN_DB_ROLE
#             |                     | Possible values are
#             |                     |- ACCOUNT_ONLY -> Traditional Account level
#             |                     |- DBR_FUNC_ACC -> DB Access Roles are granted
#             |                     |                  to DB Functional roles which are granted
#             |                     |                  to Account Level Functional Roles which are
#             |                     |                  then granted to users
#             |                     | - DBR_ACC_ONLY -> DB Access Roles are granted to
#             |                     |                   Account level functional roles which are
#             |                     |                   then granted to users
#             |                     |
#             |                     | - INCLUDE_ENV_IN_DB_ROLE
#             |                     |   A boolen indicator to determine in the environment should be
#             |                     |   included in the DB role names
#             |                     | Possible Values
#             |                     | - FALSE -> Environment name is not included in the DB role name
#             |                     | - TRUE  -> Environment name is included in the DB role name
import sys
import getopt
import os
import os.path
import snowflake.connector
import time
import logging
from SFConnectionConfig import *
from SFSpreadsheet import *
from SFDBCalls import *
from SFParams import *
from SFPrompt import *


def main(argv):

    # Configure logging
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    fmt = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
    ch = logging.StreamHandler()
    ch.setFormatter(fmt)
    logger.addHandler(ch)

    logger.info("**************************************")
    logger.info("* sfBuild Started                    *")
    logger.info("**************************************")

    sfConnectionConfig = SFConnectionConfig()
    spreadSheet = SFSpreadsheet()
    sfPrompt = SFPrompt()

    # Process Parameters
    try:
        opts, args = getopt.getopt(argv, "c:d:s:e:o:r:v:", ["config=", "spreadsheet=", "database=", "envTo=", "outscript=", "envOverride=", "run="])
    except getopt.GetoptError as e:
        logger.info("Invalid Parameter(s)  " + e.msg)
        sys.exit(2)

    sfParams = SFParams(opts, args, logger)

    # Validate parameters
    if sfParams.validate() < 0:
        exit(1)

    if sfParams.runDDL.upper() == "TRUE":
        sfConnectionConfig.readConfig(sfParams.snowflakeConnFile)

        if sfConnectionConfig.sfPassword == "":
            sfConnectionConfig.sfPassword = sfPrompt.getPassword()

    # If the config file is specified, read it
    if sfParams.runDDL.upper() == "TRUE":
        try:
            logger.info("Connecting to Snowflake")
            sfConn = snowflake.connector.connect(
                user=sfConnectionConfig.sfUser,
                password=sfConnectionConfig.sfPassword,
                account=sfConnectionConfig.sfAccount,
                warehouse=sfConnectionConfig.sfWarehouse,
                role=sfConnectionConfig.sfRole
            )
            logger.info("Connecting to Snowflake - OK")
        except Exception as e:
            print(e)
            sys.exit(3)
    else:
        sfConn = None

    # Read the spreadsheet
    try:
        dfSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, sfParams.tabName)
        dfConfig = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "CONFIG")
        df_super_roles = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "SUPER-ROLES")
        dfSDRRoles = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "SDR_ROLES")


    except Exception as e:
        logger.error("Unable to read spread sheet: " + str(e))
        sys.exit(3)

    # Obtain securityAdmin and SysAdmin roles for the environment, plus other config values
    # if the -d parameter has been specified and is not blank, the -d should override.
    if sfParams.database == "":
        sfParams.envTo = sfParams.database


    secAdminRole = sfParams.database.upper() + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", dfConfig)
    sysAdminRole = sfParams.database.upper() + "_" + spreadSheet.getAdminRole("SYSTEM-ADMIN", dfConfig)
    masterSecAdminRole = spreadSheet.getAdminRole("MASTER_SECURITY_ADMIN", dfConfig)
    masterSysAdminRole = spreadSheet.getAdminRole("MASTER_SYSTEM_ADMIN", dfConfig)
    accessRolePrefix = spreadSheet.getKeyValue("ACCESS_ROLE_PREFIX", dfConfig)
    accessRoleSuffix = spreadSheet.getKeyValue("ACCESS_ROLE_SUFFIX", dfConfig)
    if accessRoleSuffix == "NONE":
        accessRoleSuffix = "LLLLLLLL"

    permissionType = spreadSheet.getPermissionType("PERMISSIONTYPE", dfSheet)
    sdrRolePrefix = spreadSheet.getKeyValue("SDR_ROLE_PREFIX", dfConfig)
    roleType = spreadSheet.getKeyValue("ROLE_TYPES", dfConfig)
    includeEnvInDBRole = spreadSheet.getKeyValue("INCLUDE_ENV_IN_DB_ROLE", dfConfig)
    includeEnvInSDRRole = spreadSheet.getKeyValue("INCLUDE_ENV_IN_SDR_ROLE", dfConfig)   


    # usageRole = sfParams.envTo.upper() + "_USAGE"


    # Instantiate the snowflake DB call class
    sfDBCalls = SFDBCalls(logger, sfConn, sfParams.outScript, sfParams.runDDL)

    # Write script header
    sfDBCalls.writeScriptHeader("sfBuild_" + sfParams.envTo, "sfBuild.py", sfParams.spreadsheetFile, sfParams.envTo)

    #
    # Create security roles
    #  - creates the environment sys-admin
    #  - creates the environment role-admin
    #  - needs privileges to use account roles sysadmin and useradmin


    # include build of security
    sfDBCalls.write_script_comment("Create the security roles for " + sysAdminRole + " and " + secAdminRole)
    sfDBCalls.create_security_roles(sysAdminRole, secAdminRole, masterSysAdminRole, masterSecAdminRole , "IF NOT EXISTS", sfParams.envTo, permissionType)

    # Now let the fun begin - completely resorting the build script
    # Grouping by executing roles


    # Note that if the permission is passive then set sfParams.envTo to the database name specified in the parameter
    if not sfParams.database == "":
        sfParams.envTo = sfParams.database

    if sfParams.envOverrideName != "":
        sfParams.envTo = sfParams.envOverrideName

    # Switch to env-sysadmin
    sfDBCalls.write_script_comment("|" * 42 + " Switch role... " + "|" * 42)
    sfDBCalls.write_script_comment("Try to use role " + sysAdminRole)

    if sfDBCalls.use_role(sysAdminRole) is False:
        sys.exit(3)

    # Create the New DB

    sfDBCalls.write_script_comment("Create database " + sfParams.database)
    db_data_retention = spreadSheet.getDataRetention(dfConfig)
    db_ddl_collation = spreadSheet.getDDLCollation(dfConfig)

    sfDBCalls.create_db(sfParams.database, db_data_retention, db_ddl_collation)
    sfDBCalls.UseDatabase(sfParams.database,sysAdminRole)

    # Create the functional roles
    # Notes:
    #   Functional Roles are always created at Account Level
    #   If roleType = 'DBR_FUNC_ACC' then the functional will also be created at database level
    #      and the DB Functional role will be granted to the Account Level Functional Role
    #   If roleType = 'DBR_ACC_ONLY' the functional roles will not be created at database level but
    #      the access roles are created at database level. DB level access roles will be granted to the
    #      account level Functional Roles
    #  Create roles and assign ownership (as useradmin)
    #  - create all functional roles
    #  - grant ownership on functional roles to env-roleadmin
    #  - create all access roles
    #  - grant ownership on access roles to env-roleadmin

    # Get a list of the functional roles
    # column 5 = sysadmin, column 6 = roleadmin -> start in column 7
    lst_functional_roles = dfSheet.columns.values[5:]
    lst_functional_roles = list(dict.fromkeys(lst_functional_roles))
    lst_functional_roles_copy = []

    for funcRole in lst_functional_roles:
        if not funcRole[0:7] == 'Unnamed':
            lst_functional_roles_copy.append(funcRole)

    lst_functional_roles = lst_functional_roles_copy
    # Switch to environment security admin role
    sfDBCalls.write_script_comment("|" * 42 + " Switch role... " + "|" * 42)
    sfDBCalls.write_script_comment("Try to use role " + secAdminRole)
    if sfDBCalls.use_role(secAdminRole) is False:
        sys.exit(3)

    sfDBCalls.write_script_comment("Create Account Level functional roles")

    for funcRole in lst_functional_roles:
        sfDBCalls.createFunctionalRoles(sfParams.envTo + "_" + funcRole, "IF NOT EXISTS", sysAdminRole, secAdminRole)

    if roleType == "DBR_FUNC_ACC":
        sfDBCalls.write_script_comment("Create Database Level functional roles")
        sfDBCalls.use_role(sysAdminRole)
        sfDBCalls.UseDatabase(sfParams.database, sysAdminRole)


        for funcRole in lst_functional_roles:
            if includeEnvInDBRole == "TRUE":
                roleToCreate = sfParams.envTo + "_" + funcRole
            else:
                roleToCreate = funcRole

            sfDBCalls.createDBFunctionalRoles(roleToCreate, "IF NOT EXISTS", sysAdminRole, secAdminRole)
    # Removing this functionality and creating the roles with the right owner
    # Grant ownership on functional roles to env-roleadmin
    # Revoke current grants because ownership includes everything / avoids circular references on refresh
    # Enforces RESTRICT semantics, which require removing all outbound privileges on an object before
    # transferring ownership to a new role.
    # This is intended to protect the new owning role from unknowingly inheriting the object with privileges
    # already granted on it.
    # After transferring ownership, the privileges for the object must be explicitly re-granted on the role.
    # So, maybe we try first without revoke current grants...
    # sfDBCalls.write_script_comment("Grant ownership on functional roles to " + secAdminRole)
    # for funcRole in lst_functional_roles:
    #    sfDBCalls.grantOwnershipToSecAdminRole(sfParams.envTo + "_" + funcRole, "", secAdminRole, "", accessRoleSuffix)

    # Create all access roles
    # If security is defined as permissive then there is only one set of access roles and these are defined against
    # Type DB_Permissions

    # Database level security
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("Create access roles, Permissive DB Only Access Roles")
        sfDBCalls.use_role(sysAdminRole)
        sfDBCalls.UseDatabase(sfParams.database, sysAdminRole)

        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                # create the access roles for this schema
                if roleType == "ACCOUNT_ONLY":
                    sfDBCalls.createAccessRoles(sfParams.database + "_" + rows['KEY'], "IF NOT EXISTS",
                                                accessRolePrefix, accessRoleSuffix, roleType)
                # For DB Roles, we will always create DB access roles
                else:
                    sfDBCalls.createAccessRoles(rows['KEY'], "IF NOT EXISTS",
                                                accessRolePrefix, accessRoleSuffix, roleType)
        # Check for overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # create the access roles for this schema
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.createAccessRoles(sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'], "IF NOT EXISTS",
                                                        accessRolePrefix, accessRoleSuffix, roleType)
                        else:
                            sfDBCalls.createAccessRoles(sfAccessSchema + "_" + rows['KEY'],
                                                        "IF NOT EXISTS", accessRolePrefix, accessRoleSuffix, roleType)

    else:
        sfDBCalls.write_script_comment("Create access roles, Restrictive DB Only Access Roles")
        # If security is defined as Restrictive then there will be many access roles per schema
        # Specify USE DATABASE
        sfDBCalls.use_role(sysAdminRole)
        sfDBCalls.UseDatabase(sfParams.database,sysAdminRole)
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # create the access roles for this schema
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.createAccessRoles(sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'], "IF NOT EXISTS"
                                                    , accessRolePrefix, accessRoleSuffix, roleType)
                        else:
                            sfDBCalls.createAccessRoles(sfAccessSchema + "_" + rows['KEY'],
                                                        "IF NOT EXISTS" , accessRolePrefix, accessRoleSuffix, roleType)

    # Commenting out the ownership code as the role was created as the
    # env sysadmin.
    # Grant ownership on access roles to env-roleadmin
    #if permissionType.upper() == "PERMISSIVE":
    #    sfDBCalls.write_script_comment("... Permissive: Grant ownership on access roles to " + secAdminRole)
    #    for index, rows in dfConfig.iterrows():
    #        if rows['TYPE'].upper() == "DB_PRIVS":
    #            sfDBCalls.grantOwnershipToSecAdminRole(
    #                sfParams.database + "_" + rows['KEY'], "", secAdminRole, accessRolePrefix,
    #                accessRoleSuffix)

    #    for index, rows in dfSheet.iterrows():
    #        if rows['TYPE'].upper() == "SCHEMA_O":
    #            sfAccessSchema = rows['OBJECT'].upper()
    #            for index, rows in dfConfig.iterrows():
    #                if rows['TYPE'].upper() == "SCHEMA_PRIVS":
    #                    # grant ownership on the access roles schema to secAdminRole
    #                    sfDBCalls.grantOwnershipToSecAdminRole(
    #                        sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'], "", secAdminRole, accessRolePrefix, accessRoleSuffix)

    #else:
    #    sfDBCalls.write_script_comment("Grant ownership on schema access roles to " + secAdminRole)
    #    for index, rows in dfSheet.iterrows():
    #        if rows['TYPE'].upper() == "SCHEMA":
    #            sfAccessSchema = rows['OBJECT'].upper()
    #            for index, rows in dfConfig.iterrows():
    #                if rows['TYPE'].upper() == "SCHEMA_PRIVS":
    #                    # grant ownership on the access roles schema to secAdminRole
    #                    sfDBCalls.grantOwnershipToSecAdminRole(
    #                        sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'], "", secAdminRole, accessRolePrefix, accessRoleSuffix)

    # Create the Secure Data Roles (SDR's)
    sfDBCalls.write_script_comment("Create the SDR Roles")
    sfDBCalls.use_role(secAdminRole)

    for index, rows in dfSDRRoles.iterrows():
        sdrRole = rows['Role_Name'].upper()
        sdrDesc = rows['Description'].upper()

        if includeEnvInSDRRole == "TRUE":
            sfDBCalls.createSDRRole(sdrRolePrefix + "_" + sfParams.database + "_" + sdrRole)
        else:
            sfDBCalls.createSDRRole(sdrRolePrefix + "_" + sdrRole)

    # Create warehouse access roles
    sfDBCalls.write_script_comment("Create warehouse access roles")
    sfDBCalls.use_role(secAdminRole)

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfAccessSchema = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # create the access roles for this warehouse
                    sfDBCalls.createAccessRoles(sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'],
                                                "IF NOT EXISTS", accessRolePrefix, accessRoleSuffix,"ACCOUNT_ONLY")

    sfDBCalls.write_script_comment("Grant ownership on warehouse access roles to " + secAdminRole)


    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfAccessWarehouse = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # grant ownership on the access roles warehouse to secAdminRole
                    sfDBCalls.grantOwnershipToSecAdminRole(sfParams.envTo + "_" + sfAccessWarehouse + "_" + rows['KEY'], "", secAdminRole, accessRolePrefix, accessRoleSuffix)

    # Create the super-roles, but leave the ownership with the useradmin, because they are not bound to a specific db


    sfDBCalls.write_script_comment("Create Super-Roles  (ownership stays with USERADMIN)")

    # Get a list of super-roles from super-roles sheet
    lst_super_roles = list(df_super_roles.columns.values[4:])

    # Append the super-roles from environment sheet
    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "SUPER-ROLE":
            lst_super_roles.append(rows['OBJECT'].upper())

    lst_super_roles.sort()
    lst_super_roles = list(dict.fromkeys(lst_super_roles))  # removes duplicate entries from the list

    # Create super-roles from super-roles sheet !!!

    for super_role in lst_super_roles:
        if not super_role.upper() == "N":
            sfDBCalls.createSuperRoles(super_role.upper())

    # Grant super-roles to users
    # Needs to be done up here, because env-roleadmin has not privileges to grant super-roles

    sfDBCalls.write_script_comment("Grant super-roles to users")

    for index, rows in df_super_roles.iterrows():
        if rows['TYPE'].upper() == "USER":
            for super_role in lst_super_roles:
                if not rows[super_role].upper() == "N":
                    sfDBCalls.grant_functional_roles_to_user(super_role, rows['OBJECT'], rows[super_role])



    #  Build hierarchy and grant functional roles to users (as env-roleadmin)
    #  - grant functional roles to env-sysadmin
    #  - grant access roles to env-sysadmin
    #  - grant access roles to functional roles
    #  - grant or revoke functional roles to or from users
    #  -


    # Switch to env-roleadmin
    sfDBCalls.write_script_comment("|" * 42 + " Switch role... " + "|" * 42)
    sfDBCalls.write_script_comment("Try to use role " + secAdminRole)
    if sfDBCalls.use_role(secAdminRole) is False:
        sys.exit(3)

    # Note: This is the same for passive and restrictive
    # Grant the account functional roles
    sfDBCalls.write_script_comment("Grant account level functional roles to " + sysAdminRole)
    for funcRole in lst_functional_roles:
        sfDBCalls.grantRoleToRole(sfParams.envTo + "_" + funcRole, sysAdminRole)

    # IF using database roles, grant the database functional roles to sysadmin and
    # grant the  datbase functional roles to the account level functional roles
    if roleType == "DBR_FUNC_ACC":
        sfDBCalls.write_script_comment("Grant database functional roles to " + sysAdminRole)
        # Grant database functional role to account functional role
        sfDBCalls.use_role(sysAdminRole)
        sfDBCalls.UseDatabase(sfParams.database,sysAdminRole)
        for funcRole in lst_functional_roles:
            if includeEnvInDBRole == "TRUE":
                dbFuncRole = sfParams.envTo + "_" + funcRole
            else:
                dbFuncRole = funcRole

            sfDBCalls.grantDBRoleToRole(dbFuncRole, sysAdminRole)

    # IF using database roles, grant the database functional roles to sysadmin and
    # grant the  datbase functional roles to the account level functional roles
    if roleType == "DBR_FUNC_ACC":
        sfDBCalls.write_script_comment("Grant database functional roles to account level functional roles")
        # Grant database functional role to account functional role
        for funcRole in lst_functional_roles:
            if includeEnvInDBRole == "TRUE":
                dbFuncRole = sfParams.envTo + "_" + funcRole
            else:
                dbFuncRole = funcRole

            sfDBCalls.grantDBRoleToRole(dbFuncRole, sfParams.envTo + "_" + funcRole)




    # For permissive - only the DB Level roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive. Grant access roles to " + sysAdminRole)
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                if roleType == "ACCOUNT_ONLY":
                    sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.database + "_" + rows['KEY'] + accessRoleSuffix, sysAdminRole)
                else:
                    sfDBCalls.write_line("-- ... For Permissive with DB Access roles, there is no grant of DB access role to " + sysAdminRole)
                    break
                    #if includeEnvInDBRole == "TRUE":
                    #    accRole = accessRolePrefix  + sfParams.database + "_" + rows['KEY'] + accessRoleSuffix
                    #else:
                    #    accRole = accessRolePrefix + rows['KEY'] + accessRoleSuffix

                    #sfDBCalls.grantDBRoleToRole(accessRolePrefix, sfParams.envTo + "_" + sysAdminRole)
                    # create the access roles for this schema

        # Overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        if roleType == "ACCOUNT_ONLY":
                            # grant ownership on the access roles schema to secAdminRole
                            sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix
                                                      , sysAdminRole)
                        else:
                            if includeEnvInDBRole == "TRUE":
                                accRole = accessRolePrefix +  sfParams.envTo + "_" + rows['KEY'] + accessRoleSuffix
                            else:
                                accRole = accessRolePrefix + sfParams.database + "_" + rows['KEY'] + accessRoleSuffix

                            sfDBCalls.grantRoleToRole(accRole  , sysAdminRole)

    else:
        # Grant the access roles
        sfDBCalls.write_script_comment("Grant access roles to " + sysAdminRole)
        sfDBCalls.use_role(sysAdminRole)
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        if roleType == "ACCOUNT_ONLY":
                            # grant ownership on the access roles schema to secAdminRole
                            sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix
                                                      , sysAdminRole)
                        else:
                            if includeEnvInDBRole == "TRUE":
                                accRole = accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix
                            else:
                                accRole = accessRolePrefix + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix

                            sfDBCalls.grantDBRoleToRole(accRole, sysAdminRole)



    # Grant access roles to functional roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive. Grant DB level access roles to functional roles")
        sfDBCalls.use_role(sysAdminRole)
        sfDBCalls.UseDatabase(sfParams.database, sysAdminRole)
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "DB-PERMISSIONS":
                for funcRole in lst_functional_roles:
                    if roleType == "ACCOUNT_ONLY":
                        sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.database, rows[funcRole],
                                                                          sfParams.envTo + "_" + funcRole, accessRolePrefix,
                                                                          accessRoleSuffix)

                    else:
                    # Granting an access role to a functional role
                    # Functional Roles are database roles, then grant the database access role to the
                    # database functional Role
                        if roleType == "DBR_FUNC_ACC":
                            if includeEnvInDBRole == "TRUE":
                                dbFuncRole = sfParams.envTo + "_" + funcRole
                            else:
                                dbFuncRole = funcRole

                            sfDBCalls.grantSelectedDBAccessRoleToDBFunctionalRole("", rows[funcRole],
                                                                          dbFuncRole,
                                                                          accessRolePrefix,
                                                                          accessRoleSuffix)

                        # At this point we are granting the DB access role to the account level functional role
                        else:
                            if includeEnvInDBRole == "TRUE":
                                dbFuncRole = sfParams.envTo + "_" + funcRole
                            else:
                                dbFuncRole = funcRole

                            sfDBCalls.grantSelectedDBAccessRoleToFunctionalRole(sfParams.database, rows[funcRole],
                                                                              dbFuncRole,
                                                                              accessRolePrefix,
                                                                              accessRoleSuffix)


        # Overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                for funcRole in lst_functional_roles:
                    if not rows[funcRole].upper() == "N":
                        # Is the account_Only Roles
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'],
                                                                          rows[funcRole],
                                                                          sfParams.envTo + "_" + funcRole,
                                                                          accessRolePrefix, accessRoleSuffix)
                        else:
                            # Granting an access role to a functional role
                            # Functional Roles are database roles, then grant the database access role to the
                            # database functional Role
                            if roleType == "DBR_FUNC_ACC":
                                if includeEnvInDBRole == "TRUE":
                                    dbFuncRole = sfParams.envTo + "_" + funcRole
                                else:
                                    dbFuncRole = funcRole

                                sfDBCalls.grantSelectedDBAccessRoleToDBFunctionalRole(sfParams.database, rows[funcRole],
                                                                                      dbFuncRole,
                                                                                      accessRolePrefix,
                                                                                      accessRoleSuffix)

                                # At this point we are granting the DB access role to the account level functional role
                            else:
                                if includeEnvInDBRole == "TRUE":
                                    dbFuncRole = sfParams.envTo + "_" + funcRole
                                else:
                                    dbFuncRole = funcRole

                                sfDBCalls.grantSelectedDBAccessRoleToFunctionalRole(sfParams.database, rows[funcRole],
                                                                                    dbFuncRole,
                                                                                    accessRolePrefix,
                                                                                    accessRoleSuffix)

    else:
        sfDBCalls.write_script_comment("Grant access roles to functional roles")
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                for funcRole in lst_functional_roles:
                    if not rows[funcRole].upper() == "N":
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'], rows[funcRole], sfParams.envTo + "_" + funcRole, accessRolePrefix, accessRoleSuffix)
                        else:
                            # Granting an access role to a functional role
                            # Functional Roles are database roles, then grant the database access role to the
                            # database functional Role
                            if roleType == "DBR_FUNC_ACC":
                                if includeEnvInDBRole == "TRUE":
                                    dbFuncRole = sfParams.envTo + "_" + funcRole
                                    dbSchema = sfParams.envTo + "_" + rows['OBJECT']

                                    sfDBCalls.grantSelectedDBAccessRoleToDBFunctionalRoleRestrictive(dbSchema, rows[funcRole],
                                                                                          dbFuncRole,
                                                                                          accessRolePrefix,
                                                                                          accessRoleSuffix)

                                    #sfDBCalls.grantSelectedDBAccessRoleToFunctionalRole(dbSchema, rows[funcRole],
                                    #                                                      sfParams.envTo + "_" + dbFuncRole,
                                    #                                                      accessRolePrefix,
                                    #                                                      accessRoleSuffix)
                                else:
                                    dbFuncRole = funcRole
                                    dbSchema = rows['OBJECT']
                                    sfDBCalls.grantSelectedDBAccessRoleToDBFunctionalRoleRestrictive(dbSchema, rows[funcRole],
                                                                                      dbFuncRole,
                                                                                      accessRolePrefix,
                                                                                      accessRoleSuffix)

                                    #sfDBCalls.grantSelectedDBAccessRoleToFunctionalRole(dbSchema, rows[funcRole],
                                    #                                                    sfParams.envTo + "_" + dbFuncRole,
                                    #                                                    accessRolePrefix,
                                    #                                                    accessRoleSuffix)

                                # At this point we are granting the DB access role to the account level functional role
                            else:
                                if includeEnvInDBRole == "TRUE":
                                    dbSchema = sfParams.envTo + "_" + rows['OBJECT']
                                else:
                                    dbSchema = rows['OBJECT']

                                dbFuncRole = sfParams.envTo + "_" + funcRole
                                sfDBCalls.grantSelectedDBAccessRoleToFunctionalRole(dbSchema, rows[funcRole],
                                                                                    dbFuncRole,
                                                                                    accessRolePrefix,
                                                                                    accessRoleSuffix)



    # Include the access Roles to funnctional roles for the virtual warehouses
    sfDBCalls.write_script_comment("Grant warehouse access roles to " + sysAdminRole)
    sfDBCalls.use_role(secAdminRole)
    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfAccessSchema = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # grant ownership on the access roles schema to secAdminRole
                    sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix, sysAdminRole)



    sfDBCalls.write_script_comment("Grant virtual warehouse access roles to functional roles")
    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            for funcRole in lst_functional_roles:
                if not rows[funcRole].upper() == "N":
                    sfDBCalls.grantSelectedAccessRoleToFunctionalRole( sfParams.envTo + "_" + rows['OBJECT'], rows[funcRole], sfParams.envTo + "_" + funcRole, accessRolePrefix, accessRoleSuffix)



    # Grant functional roles to super-roles

    sfDBCalls.write_script_comment("Grant functional roles to super-roles")

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "SUPER-ROLE":
            for func_role in lst_functional_roles:
                if not rows[func_role].upper() == "N":
                    sfDBCalls.grant_functional_role_to_super_role(sfParams.envTo + "_" + func_role, rows['OBJECT'], rows[func_role])



    # Grant functional roles to users

    sfDBCalls.write_script_comment("Grant functional roles to users")

    # list of functional roles needs to read again, this time including column 5 to get security roles too
    lst_functional_roles = dfSheet.columns.values[4:]

    lst_functional_roles = list(dict.fromkeys(lst_functional_roles))
    lst_functional_roles_copy = []

    for funcRole in lst_functional_roles:
        if not funcRole[0:7] == 'Unnamed':
            lst_functional_roles_copy.append(funcRole)

    lst_functional_roles = lst_functional_roles_copy

    # Remove unamed columns
    for myLst in lst_functional_roles_copy:
        if myLst[0:7] == 'Unnamed':
            lst_functional_roles.remove(myLst)

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "USER":
            for func_role in lst_functional_roles:
                if not rows[func_role].upper() == "N":
                    sfDBCalls.grant_functional_roles_to_user(sfParams.envTo + "_" + func_role, rows['OBJECT'], rows[func_role])



    lstSchemaForSFULL = []
    # Obtain a list of schemas that require the SFULL (Ownership)
    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "SCHEMA":
            thisSchema = rows['OBJECT']
            for func_role in lst_functional_roles:
                thisAccessRole = rows[func_role]
                if thisAccessRole == "SFULL":
                    lstSchemaForSFULL.append(thisSchema)

    # Deduplicate the lst
    lstSchemaForSFULL = list(dict.fromkeys(lstSchemaForSFULL))


    #  Create database objects and grant privileges (as env-sysadmin)
    #  - grant usage on db to access roles (to all roles)
    #  - create the warehouses
    #  - grant privileges on warehouses to access roles
    #  - create all the schemas
    #  - grant usage on schemas to access roles (grant all to role rwc)
    #  - grant privileges to access roles (current and future, but not rwc - this role becomes the owner)
    #  - grant ownership to rwc access roles (current and future), use revoke current grants? not sure...
    #  - (don't forget to handle super-roles)


    # Switch to env-sysadmin
    sfDBCalls.write_script_comment("|" * 42 + " Switch role... " + "|" * 42)
    sfDBCalls.write_script_comment("Try to use role " + sysAdminRole)

    if sfDBCalls.use_role(sysAdminRole) is False:
        sys.exit(3)



    # Grant db usage to access roles
    # TO DO - DB ROLES for permissive
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive. Grant db usage to access roles")
        sfDBCalls.use_role(sysAdminRole)
        for index, rows in dfConfig.iterrows():
            if roleType == "ACCOUNT_ONLY":
                if rows['TYPE'].upper() == "DB_PRIVS":
                    sfDBCalls.grant_db_usage(sfParams.envTo, accessRolePrefix +  sfParams.database + "_" + rows['KEY'] + accessRoleSuffix)

            else:
                if rows['TYPE'].upper() == "DB_PRIVS":
                    if includeEnvInDBRole == "TRUE":
                        sfDBCalls.grant_db_usageToDBRole(sfParams.envTo, accessRolePrefix + sfParams.database + "_" + rows['KEY'] + accessRoleSuffix)
                    else:
                        sfDBCalls.grant_db_usageToDBRole(sfParams.envTo,accessRolePrefix + rows['KEY'] + accessRoleSuffix)
        # Overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant usage on db roles for access role
                        sfDBCalls.grant_db_usage(sfParams.envTo, accessRolePrefix + sfParams.envTo + "_" + sfSchema + "_" + rows['KEY']+ accessRoleSuffix)

    else:
        sfDBCalls.write_script_comment("Grant db usage to access roles")
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant usage on db roles for access role
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.grant_db_usage(sfParams.database, accessRolePrefix + sfParams.envTo + "_" + sfSchema + "_" + rows['KEY']+ accessRoleSuffix)
                        else:
                            if includeEnvInDBRole == "TRUE":
                                dbACCRole = accessRolePrefix + sfParams.envTo + "_" + sfSchema + "_" + rows['KEY']+ accessRoleSuffix
                            else:
                                dbACCRole = accessRolePrefix + sfSchema + "_" + rows['KEY'] + accessRoleSuffix
                                sfDBCalls.grant_db_usageToDBRole(sfParams.database, dbACCRole)




    # For permissive, grant the future privileges
    # TO DO for DB Roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("...Permissive. Grant DB Level privileges  for DB: " + sfParams.envTo)
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                if roleType == "ACCOUNT_ONLY":
                    # grant privileges on the access roles for schemas
                    sfDBCalls.grant_permissive_access_role_privileges(sfParams.envTo
                                                                      , sfParams.envTo + "_" + rows['KEY']
                                                                      , rows['VALUE'], "FALSE", "TRUE", "FALSE"
                                                                      , accessRolePrefix, accessRoleSuffix)
                else:
                    if includeEnvInDBRole == "TRUE":
                        sfDBCalls.grant_permissive_access_db_role_privileges(sfParams.envTo
                                                                      , sfParams.envTo + "_" + rows['KEY']
                                                                      , rows['VALUE'], "FALSE", "TRUE", "FALSE"
                                                                      , accessRolePrefix, accessRoleSuffix)
                    else:
                        sfDBCalls.grant_permissive_access_db_role_privileges(sfParams.envTo
                                                                             , rows['KEY']
                                                                             , rows['VALUE'], "FALSE", "TRUE", "FALSE"
                                                                             , accessRolePrefix, accessRoleSuffix)

    # Create the warehouses
    sfDBCalls.write_script_comment("Create the warehouses")

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfDBCalls.create_warehouse(sfParams.envTo + "_" + rows['OBJECT'], rows['OPTIONS'])



    # Grant privileges on warehouses to access roles

    sfDBCalls.write_script_comment("Grant privileges on warehouses to access roles")

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfWarehouse = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # grant privileges on the access roles for warehouses
                    sfDBCalls.grant_access_role_privileges(sfParams.envTo + "_" + sfWarehouse
                                                           ,sfParams.envTo + "_" + sfWarehouse + "_" + rows['KEY']
                                                           ,rows['VALUE'],"FALSE", "", "FALSE"
                                                           ,accessRolePrefix, accessRoleSuffix)


    # If were in passive mode, we have created privileges with future clause before the schemas are created
    # thus only need to create schema for passive
    sfDBCalls.write_script_comment("Create the schemas")


    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "SCHEMA" or rows['TYPE'].upper() == "SCHEMA_O":
            sfDBCalls.create_schema(sfParams.database, rows['OBJECT'], rows['OPTIONS'], sysAdminRole, secAdminRole,  "IF NOT EXISTS")




    # Grant privileges to access roles
    # TO DO: DB Roles for permissive
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("Grant ownership on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "TRUE", "", "TRUE"
                                                               , accessRolePrefix, accessRoleSuffix)
    # This is only relevant to RESTRICTED
    else:
        if permissionType.upper() == "RESTRICTIVE":
            sfDBCalls.write_script_comment("Grant ownership on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.grant_access_role_privileges(sfSchema,
                                                                   sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                                   rows['VALUE'], "TRUE", "", "TRUE"
                                                                   , accessRolePrefix, accessRoleSuffix)
                        else:
                            if includeEnvInDBRole == "TRUE":
                                dbACCRole =  sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'] + accessRoleSuffix
                            else:
                                dbACCRole = sfSchema + "_" + rows['KEY'] + accessRoleSuffix

                            sfDBCalls.grant_access_DBrole_privileges(sfSchema,
                                                                    dbACCRole,
                                                                   rows['VALUE'], "TRUE", "", "TRUE"
                                                                   , accessRolePrefix, accessRoleSuffix)




    # For Permissive only grant
    # TO DB ROles for permissive
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("...Permissive. Grant future ownership on objects to access roles")
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":

                if roleType == "ACCOUNT_ONLY":
                    #sfDBCalls.grant_db_usage(sfParams.envTo, accessRolePrefix +  sfParams.database + "_" + rows['KEY'] + accessRoleSuffix)
                    sfDBCalls.grant_permissive_access_role_privileges(sfParams.envTo,
                                                           sfParams.envTo + "_" + rows['KEY'],
                                                           rows['VALUE'], "TRUE", "FUTURE", "FALSE"
                                                           , accessRolePrefix, accessRoleSuffix)

                else:
                    if includeEnvInDBRole == "TRUE":
                        sfDBCalls.grant_permissive_access_db_role_privileges(sfParams.envTo,
                                                                            sfParams.envTo + "_" + rows['KEY'],
                                                                            rows['VALUE'], "TRUE", "FUTURE", "FALSE"
                                                                            , accessRolePrefix, accessRoleSuffix)
                    else:
                        sfDBCalls.grant_permissive_access_db_role_privileges(sfParams.envTo,
                                                                             rows['KEY'],
                                                                             rows['VALUE'], "TRUE", "FUTURE", "FALSE"
                                                                             , accessRolePrefix, accessRoleSuffix)


    else:
        sfDBCalls.write_script_comment("Grant future ownership on objects to access roles")
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # As this is ownership, we only want to apply ownership if its used in a schema
                        if sfSchema in lstSchemaForSFULL:
                            # grant privileges on the access roles for schemas
                            if roleType == "ACCOUNT_ONLY":
                                sfDBCalls.grant_access_role_privileges(sfSchema,
                                                                   sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                                   rows['VALUE'], "TRUE", "FUTURE", "FALSE"
                                                                   ,accessRolePrefix, accessRoleSuffix)
                            else:
                                if includeEnvInDBRole == "TRUE":
                                    dbACCRole = sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'] + accessRoleSuffix
                                else:
                                    dbACCRole = sfSchema + "_" + rows['KEY'] + accessRoleSuffix

                                sfDBCalls.grant_access_DBrole_privileges(sfSchema,
                                                                       dbACCRole,
                                                                       rows['VALUE'], "TRUE", "FUTURE", "FALSE"
                                                                       , accessRolePrefix, accessRoleSuffix)




    # TO DO: Permissive for DB Roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("Grant privileges on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "FALSE", "", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)

    if permissionType.upper() == "RESTRICTIVE":
        sfDBCalls.write_script_comment("Grant privileges on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "FALSE", "", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)

                        else:
                            if includeEnvInDBRole == "TRUE":
                                dbACCRole = sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'] + accessRoleSuffix
                            else:
                                dbACCRole = sfSchema + "_" + rows['KEY'] + accessRoleSuffix

                            sfDBCalls.grant_access_DBrole_privileges(sfSchema,
                                                                   dbACCRole,
                                                                   rows['VALUE'], "FALSE", "", "FALSE"
                                                                   , accessRolePrefix, accessRoleSuffix)




    # TO DO: DB Roles for permissive
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("Grant future privileges on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'],"FALSE", "FUTURE", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)

    if permissionType.upper() == "RESTRICTIVE":
        sfDBCalls.write_script_comment("Grant future privileges on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        if roleType == "ACCOUNT_ONLY":
                            sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'],"FALSE", "FUTURE", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)
                        else:
                            if includeEnvInDBRole == "TRUE":
                                dbACCRole = sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'] + accessRoleSuffix
                            else:
                                dbACCRole = sfSchema + "_" + rows['KEY'] + accessRoleSuffix

                            sfDBCalls.grant_access_DBrole_privileges(sfSchema,
                                                                   dbACCRole,
                                                                   rows['VALUE'], "FALSE", "FUTURE", "FALSE"
                                                                   , accessRolePrefix, accessRoleSuffix)




    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("Revoke Manage grants ")
        sfDBCalls.revoke_manage_grants(sysAdminRole, secAdminRole, sfParams.envTo, permissionType)

    sfDBCalls.write_script_comment("Build of " + sfParams.envTo + " complete - have a nice day")
    sfDBCalls.write_script_comment("Thanks for using RBAC Automation Manager")

    sfDBCalls.closeFile()
    logger.info("**************************************")
    logger.info("* sfBuild Complete                   *")
    logger.info("* Script is: " + sfParams.outScript + " *")
    logger.info("**************************************")
    sys.exit(0)

if __name__ == '__main__':
    main(sys.argv[1:])
