# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      sfClone.py
#
# Purpose:   Callable script.  Clones an environment based on the RBAC spreadsheet
#
# History:
# Date        |  Author             | Action
#-------------+---------------------+----------------------------------------
# 31-Mar-2020 |  Ian Fickling       |  Version 1.0
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
import snowflake.connector
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
    logger.info("* sfClone Started                *")
    logger.info("**************************************")

    sfConnectionConfig = SFConnectionConfig()
    spreadSheet = SFSpreadsheet()
    sfPrompt = SFPrompt()

    # Process Parameters
    try:
        opts, args = getopt.getopt(argv, "c:s:d:a:e:f:o:r:", ["config=", "spreadsheet="
            ,"database=","action=","envTo=","envFrom=","outscript=","run="])

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
        dfSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, sfParams.envTo)
        dfConfig = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "CONFIG")
        df_super_roles = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "SUPER-ROLES")
    except Exception as e:
        logger.error("Unable to read spread sheet: " + str(e))
        sys.exit(3)

    # Obtain securityAdmin and SysAdmin roles for the environment, plus other config values
    # if the -d parameter has been specified and is not blank, the -d should override.
    if not sfParams.database == "":
        sfParams.envTo = sfParams.database

    # Obtain securityAdmin and SysAdmin roles for the environemnt
    secAdminRole = sfParams.envTo.upper() + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", dfConfig)
    sysAdminRole = sfParams.envTo.upper() + "_" + spreadSheet.getAdminRole("SYSTEM-ADMIN", dfConfig)
    masterSecAdminRole = spreadSheet.getAdminRole("MASTER_SECURITY_ADMIN", dfConfig)
    masterSysAdminRole = spreadSheet.getAdminRole("MASTER_SYSTEM_ADMIN", dfConfig)
    secFromAdminRole = sfParams.envFrom.upper() + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", dfConfig)
    sysfromAdminRole = sfParams.envFrom.upper() + "_" + spreadSheet.getAdminRole("SYSTEM-ADMIN", dfConfig)
    accessRolePrefix = spreadSheet.getKeyValue("ACCESS_ROLE_PREFIX", dfConfig)
    accessRoleSuffix = spreadSheet.getKeyValue("ACCESS_ROLE_SUFFIX", dfConfig)
    permissionType = spreadSheet.getPermissionType("PERMISSIONTYPE", dfSheet)

    # Instantiate the snowflake DB call class
    sfDBCalls = SFDBCalls(logger, sfConn, sfParams.outScript, sfParams.runDDL)

    # Write script header
    sfDBCalls.writeScriptHeader("sfClone_" + sfParams.envTo, "sfReplicate.py", sfParams.spreadsheetFile, sfParams.envTo)


    # include build of security
    sfDBCalls.write_script_comment("Create the security roles for " + sysAdminRole + " and " + secAdminRole)
    sfDBCalls.create_security_roles(sysAdminRole, secAdminRole, masterSysAdminRole, masterSecAdminRole, "IF NOT EXISTS",
                                    sfParams.envTo, permissionType)


    # As SYSADMIN, create these two roles.
    # sfDBCalls.createSecAdminRole(secAdminRole, "IF NOT EXISTS")
    # sfDBCalls.createSysAdminRole(secAdminRole, sysAdminRole, "IF NOT EXISTS")

    # Clone the DB
    sfDBCalls.cloneDB(sfParams.envFrom, sfParams.envTo, dfSheet, sysAdminRole, sysfromAdminRole)

    # Create a python dictionary of schemaPrivs
    dictSchemaPrivs = spreadSheet.getSchemaPrivs(dfConfig)

    # Get a list of the functional roles
    # column 5 = sysadmin, column 6 = roleadmin -> start in column 7
    lst_functional_roles = dfSheet.columns.values[5:]
    lst_functional_roles = list(dict.fromkeys(lst_functional_roles))
    lst_functional_roles_copy = []

    for funcRole in lst_functional_roles:
        if not funcRole[0:7] == 'Unnamed':
            lst_functional_roles_copy.append(funcRole)

    lst_functional_roles = lst_functional_roles_copy

    # Note that if the permission is passive then set sfParams.envTo to the database name specified in the parameter
    if not sfParams.database == "":
        sfParams.envTo = sfParams.database

    # Switch to useradmin
    sfDBCalls.write_script_comment("█" * 42 + " Switch role... " + "█" * 42)
    sfDBCalls.write_script_comment("Try to use role " + "USERADMIN")
    if sfDBCalls.use_role("USERADMIN") is False:
        sys.exit(3)

    # Create the functional roles
    sfDBCalls.write_script_comment("Create functional roles")

    for funcRole in lst_functional_roles:
        sfDBCalls.createFunctionalRoles(sfParams.envTo + "_" + funcRole, "IF NOT EXISTS", sysAdminRole, secAdminRole)

    sfDBCalls.write_script_comment("Grant ownership on functional roles to " + secAdminRole)

    # Grant ownership on functional roles to env-roleadmin
    # Revoke current grants because ownership includes everything / avoids circular references on refresh
    # Enforces RESTRICT semantics, which require removing all outbound privileges on an object before
    # transferring ownership to a new role.
    # This is intended to protect the new owning role from unknowingly inheriting the object with privileges
    # already granted on it.
    # After transferring ownership, the privileges for the object must be explicitly re-granted on the role.
    # So, maybe we try first without revoke current grants...
    for funcRole in lst_functional_roles:
        sfDBCalls.grantOwnershipToSecAdminRole(sfParams.envTo + "_" + funcRole, "", secAdminRole, "", accessRoleSuffix)

    # Create all access roles
    # If security is defined as permissive then there is only one set of access roles and these are defined against
    # Type DB_Permissions
    sfDBCalls.write_script_comment("Create access roles, Permissive DB Only Access Roles")
    if permissionType.upper() == "PERMISSIVE":
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                # create the access roles for this schema
                sfDBCalls.createAccessRoles(sfParams.database + "_" + rows['KEY'], "IF NOT EXISTS",
                                            accessRolePrefix, accessRoleSuffix)

        # Check for overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # create the access roles for this schema
                        sfDBCalls.createAccessRoles(sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'],
                                                    "IF NOT EXISTS", accessRolePrefix, accessRoleSuffix)

    else:
        sfDBCalls.write_script_comment("Create access roles, Restrictive DB Only Access Roles")
        # If security is defined as Restrictive then there will be many access roles per schema
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # create the access roles for this schema
                        sfDBCalls.createAccessRoles(sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'],
                                                    "IF NOT EXISTS", accessRolePrefix, accessRoleSuffix)

    # Grant ownership on access roles to env-roleadmin
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive: Grant ownership on access roles to " + secAdminRole)
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                sfDBCalls.grantOwnershipToSecAdminRole(
                    sfParams.database + "_" + rows['KEY'], "", secAdminRole, accessRolePrefix,
                    accessRoleSuffix)

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant ownership on the access roles schema to secAdminRole
                        sfDBCalls.grantOwnershipToSecAdminRole(
                            sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'], "", secAdminRole,
                            accessRolePrefix, accessRoleSuffix)

    else:
        sfDBCalls.write_script_comment("Grant ownership on schema access roles to " + secAdminRole)
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant ownership on the access roles schema to secAdminRole
                        sfDBCalls.grantOwnershipToSecAdminRole(
                            sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'], "", secAdminRole,
                            accessRolePrefix, accessRoleSuffix)

    # Create warehouse access roles
    sfDBCalls.write_script_comment("Create warehouse access roles")

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfAccessSchema = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # create the access roles for this warehouse
                    sfDBCalls.createAccessRoles(sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'],
                                                "IF NOT EXISTS", accessRolePrefix, accessRoleSuffix)

    sfDBCalls.write_script_comment("Grant ownership on warehouse access roles to " + secAdminRole)

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfAccessWarehouse = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # grant ownership on the access roles warehouse to secAdminRole
                    sfDBCalls.grantOwnershipToSecAdminRole(sfParams.envTo + "_" + sfAccessWarehouse + "_" + rows['KEY'],
                                                           "", secAdminRole, accessRolePrefix, accessRoleSuffix)

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

    # ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
    # ▌ Build hierarchy and grant functional roles to users (as env-roleadmin)                                      ▐
    # ▌ - grant functional roles to env-sysadmin                                                                    ▐
    # ▌ - grant access roles to env-sysadmin                                                                        ▐
    # ▌ - grant access roles to functional roles                                                                    ▐
    # ▌ - grant or revoke functional roles to or from users                                                         ▐
    # ▌ -                                                                                                           ▐
    # ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

    # Switch to env-roleadmin
    sfDBCalls.write_script_comment("█" * 42 + " Switch role... " + "█" * 42)
    sfDBCalls.write_script_comment("Try to use role " + secAdminRole)
    if sfDBCalls.use_role(secAdminRole) is False:
        sys.exit(3)

    # Note: This is the same for passive and restrictive
    # Grant the functional roles
    sfDBCalls.write_script_comment("Grant functional roles to " + sysAdminRole)
    for funcRole in lst_functional_roles:
        sfDBCalls.grantRoleToRole(sfParams.envTo + "_" + funcRole, sysAdminRole)

    # For permissive - only the DB Level roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive. Grant access roles to " + sysAdminRole)
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.database + "_" + rows['KEY'] + accessRoleSuffix,
                                          sysAdminRole)
                # create the access roles for this schema

        # Overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant ownership on the access roles schema to secAdminRole
                        sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows[
                            'KEY'] + accessRoleSuffix, sysAdminRole)

    else:
        # Grant the access roles
        sfDBCalls.write_script_comment("Grant access roles to " + sysAdminRole)
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfAccessSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant ownership on the access roles schema to secAdminRole
                        sfDBCalls.grantRoleToRole(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows[
                            'KEY'] + accessRoleSuffix, sysAdminRole)

    # Grant access roles to functional roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive. Grant DB level access roles to functional roles")
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "DB-PERMISSIONS":
                for funcRole in lst_functional_roles:
                    sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.database, rows[funcRole],
                                                                      sfParams.envTo + "_" + funcRole, accessRolePrefix,
                                                                      accessRoleSuffix)
        # Overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                for funcRole in lst_functional_roles:
                    if not rows[funcRole].upper() == "N":
                        sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'],
                                                                          rows[funcRole],
                                                                          sfParams.envTo + "_" + funcRole,
                                                                          accessRolePrefix, accessRoleSuffix)

    else:
        sfDBCalls.write_script_comment("Grant access roles to functional roles")
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                for funcRole in lst_functional_roles:
                    if not rows[funcRole].upper() == "N":
                        sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'],
                                                                          rows[funcRole],
                                                                          sfParams.envTo + "_" + funcRole,
                                                                          accessRolePrefix, accessRoleSuffix)

    # Include the access Roles to funnctional roles for the virtual warehouses
    sfDBCalls.write_script_comment("Grant warehouse access roles to " + sysAdminRole)
    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            sfAccessSchema = rows['OBJECT'].upper()
            for index, rows in dfConfig.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                    # grant ownership on the access roles schema to secAdminRole
                    sfDBCalls.grantRoleToRole(
                        accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix,
                        sysAdminRole)

    sfDBCalls.write_script_comment("Grant virtual warehouse access roles to functional roles")
    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "WAREHOUSE":
            for funcRole in lst_functional_roles:
                if not rows[funcRole].upper() == "N":
                    sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'],
                                                                      rows[funcRole], sfParams.envTo + "_" + funcRole,
                                                                      accessRolePrefix, accessRoleSuffix)

    # Grant functional roles to super-roles

    sfDBCalls.write_script_comment("Grant functional roles to super-roles")

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "SUPER-ROLE":
            for func_role in lst_functional_roles:
                if not rows[func_role].upper() == "N":
                    sfDBCalls.grant_functional_role_to_super_role(sfParams.envTo + "_" + func_role, rows['OBJECT'],
                                                                  rows[func_role])

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
                    sfDBCalls.grant_functional_roles_to_user(sfParams.envTo + "_" + func_role, rows['OBJECT'],
                                                             rows[func_role])

    # ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
    # ▌ Create database objects and grant privileges (as env-sysadmin)                                              ▐
    # ▌ - grant usage on db to access roles (to all roles)                                                          ▐
    # ▌ - create the warehouses                                                                                     ▐
    # ▌ - grant privileges on warehouses to access roles                                                            ▐
    # ▌ - create all the schemas                                                                                    ▐
    # ▌ - grant usage on schemas to access roles (grant all to role rwc)                                            ▐
    # ▌ - grant privileges to access roles (current and future, but not rwc - this role becomes the owner)          ▐
    # ▌ - grant ownership to rwc access roles (current and future), use revoke current grants? not sure...          ▐
    # ▌ - (don't forget to handle super-roles)                                                                      ▐
    # ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

    # Switch to env-sysadmin
    sfDBCalls.write_script_comment("█" * 42 + " Switch role... " + "█" * 42)
    sfDBCalls.write_script_comment("Try to use role " + sysAdminRole)

    if sfDBCalls.use_role(sysAdminRole) is False:
        sys.exit(3)

    # Create the New DB

    sfDBCalls.write_script_comment("Clone database " + sfParams.envTo)
    db_data_retention = spreadSheet.getDataRetention(dfConfig)
    db_ddl_collation = spreadSheet.getDDLCollation(dfConfig)

    # sfDBCalls.cloneDB(sfParams.envFrom, sfParams.envTo, dfSheet, sysAdminRole, sysfromAdminRole)

    # Grant db usage to access roles
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("... Permissive. Grant db usage to access roles")
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                sfDBCalls.grant_db_usage(sfParams.envTo,
                                         accessRolePrefix + sfParams.database + "_" + rows['KEY'] + accessRoleSuffix)

        # Overrides
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant usage on db roles for access role
                        sfDBCalls.grant_db_usage(sfParams.envTo,
                                                 accessRolePrefix + sfParams.envTo + "_" + sfSchema + "_" + rows[
                                                     'KEY'] + accessRoleSuffix)

    else:
        sfDBCalls.write_script_comment("Grant db usage to access roles")
        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant usage on db roles for access role
                        sfDBCalls.grant_db_usage(sfParams.envTo,
                                                 accessRolePrefix + sfParams.envTo + "_" + sfSchema + "_" + rows[
                                                     'KEY'] + accessRoleSuffix)

    # For permissive, grant the future privileges
    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("...Permissive. Grant DB Level privileges  for DB: " + sfParams.envTo)
        for index, rows in dfConfig.iterrows():
            if rows['TYPE'].upper() == "DB_PRIVS":
                # grant privileges on the access roles for schemas
                sfDBCalls.grant_permissive_access_role_privileges(sfParams.envTo
                                                                  , sfParams.envTo + "_" + rows['KEY']
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
                                                           , sfParams.envTo + "_" + sfWarehouse + "_" + rows['KEY']
                                                           , rows['VALUE'], "FALSE", "", "FALSE"
                                                           , accessRolePrefix, accessRoleSuffix)

    # If were in passive mode, we have created privileges with future clause before the schemas are created
    # thus only need to create schema for passive
    sfDBCalls.write_script_comment("Create the schemas")

    for index, rows in dfSheet.iterrows():
        if rows['TYPE'].upper() == "SCHEMA" or rows['TYPE'].upper() == "SCHEMA_O":
            sfDBCalls.create_schema(sfParams.envTo, rows['OBJECT'], rows['OPTIONS'], sysAdminRole, secAdminRole,
                                    "IF NOT EXISTS")

    # Grant privileges to access roles
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
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "TRUE", "", "TRUE"
                                                               , accessRolePrefix, accessRoleSuffix)

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
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "FALSE", "", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)

    if permissionType.upper() == "PERMKISSIVE":
        sfDBCalls.write_script_comment("Grant future privileges on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA_O":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "FALSE", "FUTURE", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)

    if permissionType.upper() == "RESTRICTIVE":
        sfDBCalls.write_script_comment("Grant future privileges on objects to access roles")

        for index, rows in dfSheet.iterrows():
            if rows['TYPE'].upper() == "SCHEMA":
                sfSchema = rows['OBJECT'].upper()
                for index, rows in dfConfig.iterrows():
                    if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                        # grant privileges on the access roles for schemas
                        sfDBCalls.grant_access_role_privileges(sfSchema,
                                                               sfParams.envTo + "_" + sfSchema + "_" + rows['KEY'],
                                                               rows['VALUE'], "FALSE", "FUTURE", "FALSE"
                                                               , accessRolePrefix, accessRoleSuffix)

    if permissionType.upper() == "PERMISSIVE":
        sfDBCalls.write_script_comment("Revoke Manage grants ")
        sfDBCalls.revoke_manage_grants(sysAdminRole, secAdminRole, sfParams.envTo, permissionType)

    sfDBCalls.write_script_comment("Build of " + sfParams.envTo + " complete - have a nice day")
    sfDBCalls.write_script_comment("Thanks for using RBAC Automation Manager")

    sfDBCalls.closeFile()
    logger.info("**************************************")
    logger.info("* sfReplicate Complete               *")
    logger.info("* Script is: " + sfParams.outScript + " *")
    logger.info("**************************************")
    sys.exit(0)


if __name__ == '__main__':
    main(sys.argv[1:])