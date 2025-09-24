# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      sfSync.py
#
# Purpose:   Callable script.  Will sync the snowflake environment with the spread sheet.
#            This script replaces sfVerify and sfRefresh
#            With the introduction of permissive, only one sheet can be verified at a time.
#            Notes. (1) The SF connection details contains a warehouse in which to use.
#                       This warehouse must be accessible by the environment users also.
#                   (2) The user used to connect must have access to use the environment roles.
#
# History:
# Date        |  Author             | Action
#-------------+---------------------+----------------------------------------
# 03-Oct-2021 |  Ian Fickling       |  Version 1.0
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
from Code.SFConnectionConfig import *
from Code.SFSpreadsheet import *
from Code.SFDBCalls import *
from Code.SFParams import *
from Code.SFPrompt import *



def main(argv):

    try:
        # Configure logging
        logger = logging.getLogger()
        logger.setLevel(logging.INFO)
        fmt = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
        ch = logging.StreamHandler()
        ch.setFormatter(fmt)
        logger.addHandler(ch)

        logger.info("**************************************")
        logger.info("* sfSync Started                     *")
        logger.info("**************************************")

        sfConnectionConfig = SFConnectionConfig()
        spreadSheet = SFSpreadsheet()
        sfPrompt = SFPrompt()

        # Process Parameters
        try:
            opts, args = getopt.getopt(argv, "c:s:e:d:o:r:i:v:t:",
                                       ["config=", "spreadsheet=", "envTo=", "database=", "outscript=", "envOverride=",
                                        "run=", "include=", "userOverride="])
        except getopt.GetoptError as e:
            logger.info("Invalid Parameter(s)  " + e.msg)
            sys.exit(2)

        sfParams = SFParams(opts, args, logger)

        # Validate parameters
        if sfParams.validate() < 0:
            exit(1)


        try:
            sfConnectionConfig.readConfig(sfParams.snowflakeConnFile)

            if sfConnectionConfig.sfPassword == "":
                sfConnectionConfig.sfPassword = sfPrompt.getPassword()

            if sfParams.userOverride != "":
                sfConnectionConfig.sfUser = sfParams.userOverride

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


        #before loop, execute once

        # Instantiate the snowflake DB call class
        sfDBCalls = SFDBCalls(logger, sfConn, sfParams.outScript, sfParams.runDDL)

        # Write script header
        sfDBCalls.writeScriptHeader("sfVerify_" + sfParams.envTo, "sfVerify.py", sfParams.spreadsheetFile, sfParams.envTo)


        # Read the spreadsheet
        try:
            sfEnvSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, sfParams.envTo)
            sfConfigSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "CONFIG")
        except Exception as e:
            logger.error("Unable to read spread sheet: " + str(e))
            sys.exit(3)

        sfDBCalls.write_script_comment(("Processing environment tab :" + sfParams.envTo.strip() + " for database " + sfParams.database))


        # Obtain securityAdmin and SysAdmin roles for each environment


        secAdminRole = sfParams.envTo.upper() + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", sfConfigSheet)
        sysAdminRole = sfParams.envTo.upper() + "_" + spreadSheet.getAdminRole("SYSTEM-ADMIN", sfConfigSheet)
        accessRolePrefix = spreadSheet.getKeyValue("ACCESS_ROLE_PREFIX", sfConfigSheet)
        accessRoleSuffix = spreadSheet.getKeyValue("ACCESS_ROLE_SUFFIX", sfConfigSheet)
        permissionType = spreadSheet.getPermissionType("PERMISSIONTYPE", sfEnvSheet)

        # temp code
        #secAdminRole = "PROD3_UR_DATA_STEWARD_ROLE"
        #sysAdminRole = "PROD3_UR_DATA_STEWARD_ROLE"
        # Check if the sysadmin and security roles exist

        sfDBCalls.write_script_comment("Check if the sysadmin and security roles exist")

        if sfDBCalls.tryUseRole(secAdminRole, sfConnectionConfig.sfUser) is False:
            sys.exit(3)

        if sfDBCalls.tryUseRole(sysAdminRole, sfConnectionConfig.sfUser) is False:
            sys.exit(3)

        # Check if DB is OK
        sfDBCalls.write_script_comment(" Check if DB is OK ")
        if sfDBCalls.tryUseDB(sfParams.database, sfConnectionConfig.sfUser) is False:
            sys.exit(3)


        # Check if the warehouse specified in the connection can be used by the environment roles
        sfDBCalls.write_script_comment("Testing environment roles with warehouse")
        if sfDBCalls.tryUseRoleWarehouse(sysAdminRole, sfConnectionConfig.sfWarehouse) is False:
            sys.exit(3);

        #if sfDBCalls.tryUseRoleWarehouse(secAdminRole, sfConnectionConfig.sfWarehouse) is False:
        #    sys.exit(3);



        #  Check DB owner
        sfDBCalls.write_script_comment("Check DB owner")
        sfDBCalls.checkDBOwner(sysAdminRole, sfParams.database, sysAdminRole)



        # Get list on schemas from spread sheet and list of schemas in the DB
        lstSpreadsheetSchema = spreadSheet.getSchemas(sfEnvSheet)
        tplDBSchemas = sfDBCalls.getSchemas(sfParams.database)

        # Check the owner of the schema is the environment based sysadmin role
        sfDBCalls.write_script_comment("Check the owner of the schemas in the database")
        for dbRows in tplDBSchemas:
            dbOwner = dbRows[2]
            if dbOwner.upper() == sysAdminRole.upper():
                sfDBCalls.outFile.write("-- Info: Owner of Schema " + sfParams.database + "." + dbRows[1] + " is " + sysAdminRole + "\n")
            else:
                sfDBCalls.outFile.write("-- ERROR: Owner of Schema " + sfParams.database + "." + dbRows[1] + " is not " + sysAdminRole + ". Owner is " + dbOwner + "\n")
                sfDBCalls.outFile.write("-- Possible Fix \n")
                sfDBCalls.outFile.write("   USE ROLE " + dbOwner + "; \n")
                sfDBCalls.outFile.write("   GRANT OWNERSHIP ON SCHEMA " +  dbRows[1] + " TO " + sysAdminRole + ";\n")

        # Find schemas on the spread sheet that are not in the database.
        sfDBCalls.write_script_comment("Schema compare: Spreadsheet to DB")
        lstMissingSchemas = []
        lstExtraSchemas = []
        for schema in lstSpreadsheetSchema:
            schemaFound = "N"
            for dbRows in tplDBSchemas:
                if schema.upper() == dbRows[1].upper():
                    schemaFound = "Y"
                    break

            if schemaFound == "Y":
                sfDBCalls.outFile.write("-- Info: Schema " + schema + " exists in spreadsheet and database \n");
            else:
                sfDBCalls.outFile.write("-- ERROR: Schema " + schema + " exists in spreadsheet but not in the database \n");
                sfDBCalls.outFile.write("-- Corrective script will follow below.\n");
                lstMissingSchemas.append(schema)


        # Find schemas that exist in database but not on the spreadsheet
        sfDBCalls.write_script_comment("Schema compare: DB to Spreadsheet")
        for dbRows in tplDBSchemas:
            schemaFound = "N"
            for schema in lstSpreadsheetSchema:
                if dbRows[1].upper() == schema.upper():
                    schemaFound = "Y"
                    break

            if schemaFound == "N":
                sfDBCalls.outFile.write("-- ERROR: Schema " + dbRows[1] + " exists in database but not in the spreadsheet \n")
                sfDBCalls.outFile.write("-- Corrective script will follow below.\n")
                lstExtraSchemas.append(dbRows[1].upper())

        # There is no way to determine is a role is functional or access by selecting roles from the DB.
        # There will be a step near the end that check for any DB Roles what are not specified in the spread sheet
        # Now check the functional roles specified in the spread sheet exist in the DB
        sfDBCalls.write_script_comment("Functional Role compare: Spreadsheet to DB")
        lstFunctionalRoles = sfEnvSheet.columns.values[5:]

        tplRoles = sfDBCalls.getEnvRoles(sysAdminRole, sfParams.envTo, secAdminRole)

        lstMissingFunctionalRoles = []
        for roleName in lstFunctionalRoles:
            roleExistInDB = "N"
            # loop around the db roles to see if it exists.
            for dbRole, dbRoleOwner in tplRoles:
                if dbRole == sfParams.envTo + "_" + roleName:
                    roleExistInDB = "Y"
                    break

            if roleExistInDB == "Y":
                sfDBCalls.outFile.write("-- Info: Functional Role " + sfParams.envTo + "_" + roleName + " exists in the database and spreadsheet\n")

                # environment management roles should be owned by USERADMIN
                if (dbRole == sysAdminRole or dbRole == secAdminRole) and dbRoleOwner == "USERADMIN":
                    sfDBCalls.outFile.write("-- Info: Environment Role " + sysAdminRole + " is correctly owned by " + dbRoleOwner + "\n")

                # Functional Role Should be OWNED by the environemnt sysadmin role
                elif dbRoleOwner == secAdminRole:
                    sfDBCalls.outFile.write("-- Info: Functional Role " + sfParams.envTo + "_" + roleName + " is correctly owned by " + dbRoleOwner + "\n")
                else:
                    sfDBCalls.outFile.write("-- ERROR: Functional Role " + sfParams.envTo + "_" + roleName + " is incorrectly owned by " + dbRoleOwner + "\n")

            else:
                sfDBCalls.outFile.write("-- ERROR:  Functional Role " + sfParams.envTo + "_" + roleName + " exists in the spreadsheet but not in the database\n")
                sfDBCalls.outFile.write("-- Corrective script will follow\n")
                lstMissingFunctionalRoles.append(roleName)




        # Build a list of access roles.
        # Note: if the Permission type is permissive, two lists are created
        #          lstDBLevelAccessRoles and lstSchemaLevelAccessRoles
        #       if the permission type is restrictive, one list is built
        #           lstSchemaLevelAccessRoles
        lstDBLevelAccessRoles = []
        lstSchemaLevelAccessRoles = []
        if permissionType.upper() == "PERMISSIVE":
            for index, rows in sfConfigSheet.iterrows():
                if rows['TYPE'].upper() == "DB_PRIVS":
                    # create the access roles for this schema
                    lstDBLevelAccessRoles.append(accessRolePrefix + sfParams.envTo + "_" + rows['KEY'] + accessRoleSuffix)

            # Check for overrides
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA_O":
                    sfAccessSchema = rows['OBJECT'].upper()
                    for index, rows in sfConfigSheet.iterrows():
                        if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                            # create the access roles for this schema
                            lstSchemaLevelAccessRoles.append(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix)

            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "WAREHOUSE":
                    sfAccessSchema = rows['OBJECT'].upper()
                    for index, rows in sfConfigSheet.iterrows():
                        if rows['TYPE'].upper() == "WAREHOUSE_PRIVS":
                            # create the access roles for this schema
                            lstSchemaLevelAccessRoles.append(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY'] + accessRoleSuffix)
        # PermissionType is Restrictive
        else:
            # If security is defined as Restrictive then there will be many access roles per schema
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA":
                    sfAccessSchema = rows['OBJECT'].upper()
                    for index, rows in sfConfigSheet.iterrows():
                        if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                            # create the access roles for this schema
                            lstSchemaLevelAccessRoles.append(accessRolePrefix + sfParams.envTo + "_" + sfAccessSchema + "_" + rows['KEY']
                                                             + accessRoleSuffix)



        # The list of expected access roles roles are now built
        # Now check the access roles exist - Comparing Spread sheet to DB
        sfDBCalls.outFile.flush()
        lstMissingAccessRoles = []
        sfDBCalls.write_script_comment("Check access roles exists and it has the correct owner")
        for dbAccessRole in lstDBLevelAccessRoles:
            sfDBCalls.checkRoleExists(dbAccessRole, secAdminRole, sfConnectionConfig.sfWarehouse)

        for schemaAccessRole in lstSchemaLevelAccessRoles:
            if (sfDBCalls.checkRoleExists(schemaAccessRole, secAdminRole, sfConnectionConfig.sfWarehouse) == False):
                lstMissingAccessRoles.append(schemaAccessRole)

        # Check that the access roles have been granted to the correct functional roles as specified in the spread sheet
        # Build 2 corresponding lists
        #   lstFunctionsRoles - has a list of the functional role names
        #   lstCorrespondingAccessRole - has a list of the corresponding access role
        # If we're looking at permissive, get the DB level matrix
        lst_functional_roles = list(sfEnvSheet.columns.values[5:])

        sfDBCalls.write_script_comment("Check access roles are assigned to the correct functional role")
        lstMissingAccessRoleGrants = []
        if permissionType.upper() == "PERMISSIVE":
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "DB-PERMISSIONS":
                    lstDBPermissions = list(rows[5:])
                    break

            for index, funcRole in enumerate(lst_functional_roles):
                if lstDBPermissions[index].upper() != "N":
                    envFunctionalRole = sfParams.database + "_" + funcRole
                    envAccessRole = accessRolePrefix + sfParams.envTo + "_" + lstDBPermissions[index] + accessRoleSuffix
                    sfDBCalls.checkGrantOnRole(envFunctionalRole, envAccessRole)
                        # Check Permissive schema overrides
            #breakpoint()
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA_O" or rows['TYPE'].upper() == "WAREHOUSE":
                    lstDBPermissions = list(rows[5:])
                    schemaName = rows[1]

                    #breakpoint()
                    for index, funcRole in enumerate(lst_functional_roles):
                        if lstDBPermissions[index].upper() != "N":
                            envFunctionalRole = sfParams.envTo + "_" + funcRole
                            envAccessRole = accessRolePrefix + sfParams.envTo + "_" + schemaName + "_" + lstDBPermissions[index] + accessRoleSuffix
                            sfDBCalls.checkGrantOnRole(envFunctionalRole, envAccessRole)

        # permissionType is RESTRICTIVE
        else:
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA" or rows['TYPE'].upper() == "WAREHOUSE":
                    lstDBPermissions = list(rows[5:])
                    schemaName = rows[1]

                    for index, funcRole in enumerate(lst_functional_roles):
                        if lstDBPermissions[index].upper() != "N":
                            envFunctionalRole = sfParams.envTo + "_" + funcRole
                            envAccessRole = accessRolePrefix + sfParams.envTo + "_" + schemaName + "_" + lstDBPermissions[index] + accessRoleSuffix
                            if (sfDBCalls.checkGrantOnRole(envFunctionalRole, envAccessRole) == False):
                                lstMissingAccessRoleGrants.append(envAccessRole + "," + envFunctionalRole)



        # Get all the roles from the database and then check if there is an associated role in the spreadsheet
        # if the role_prefix or suffix has been used, then one can tell if its a functional role or access role
        #breakpoint()
        sfDBCalls.outFile.flush()
        tplAllDatabaseEnvRoles = sfDBCalls.getEnvRoles(secAdminRole,sfParams.envTo, secAdminRole)

        for name, owner in tplAllDatabaseEnvRoles:
            # Does this role exist in the spread sheet ?
            roleExist = False


            if name.endswith("SECADMIN"):
                continue

            for funcRole in lstFunctionalRoles:
                if sfParams.envTo.upper() + "_" + funcRole.upper() == name.upper():
                    roleExist = True
                    break

            if not roleExist:
                for accessRole in lstSchemaLevelAccessRoles:
                    if accessRole.upper() ==  name.upper():
                        roleExist = True
                        break
            if not roleExist:
                for accessRole in lstDBLevelAccessRoles:
                    if accessRole.upper() == name.upper():
                        roleExist = True
                        break



            if not roleExist:
                sfDBCalls.outFile.write("-- WARNING: Role " + name + " exists in DB but is not assigned to anything in the spreadsheet and could be removed\n")









        # Start the corrective scripting
        # First, any functional roles that exist in Spread sheet but not the database
        # Use Role secAdmin
        sfDBCalls.write_script_comment("Corrective Scripting - Create missing schemas")
        sfDBCalls.outFile.write("   USE ROLE " + sysAdminRole + "; \n")

        # Schemas that exist in DB not n spreadsheet should be removed from DB
        sfDBCalls.write_script_comment("Corrective Scripting - Remove schema that exist in DB but not in the spreadsheet")
        for schemaName in lstExtraSchemas:
            sfDBCalls.outFile.write("   USE ROLE " + sysAdminRole + "; \n")
            sfDBCalls.outFile.write("   DROP SCHEMA  " + schemaName + "; \n")

        sfDBCalls.write_script_comment(
            "Corrective Scripting - Add Schemas that exist spreadsheet but on in DB")
        for schemaName in lstMissingSchemas:
            for index, rows in sfEnvSheet.iterrows():
                if (rows['TYPE'].upper() == "SCHEMA" or rows['TYPE'].upper() == "SCHEMA_O") and rows['OBJECT'].upper() == schemaName.upper():
                    sfDBCalls.create_schema(sfParams.envTo, schemaName, rows['OPTIONS'], sysAdminRole, secAdminRole, "IF NOT EXISTS"   )

        sfDBCalls.write_script_comment("Corrective Scripting - Create missing functional roles")
        for functionalRole in lstMissingFunctionalRoles:
            sfDBCalls.createFunctionalRoles(sfParams.envTo + "_" + functionalRole, "IF NOT EXISTS", sysAdminRole, secAdminRole)

        sfDBCalls.write_script_comment("Corrective Scripting - Create missing access roles")
        sfDBCalls.outFile.write("USE ROLE " + secAdminRole + ";\n")
        for accessRole in lstMissingAccessRoles:
            sfDBCalls.createAccessRoles(accessRole,"IF NOT EXISTS","","")

        # Grant the missing access roles to the functional roles
        for accessRole in lstMissingAccessRoles:
            # Loop through the schemas in the spread sheet.
            for index, rows in sfEnvSheet.iterrows():
                if (rows['TYPE'].upper() == "SCHEMA"):
                    schemaName = rows['OBJECT']
                    # Is this schema anything to do with the access role
                    if accessRole.upper().find(schemaName.upper()):
                        for funcRole in lstFunctionalRoles:
                            accessKey = rows[funcRole]
                            if accessKey != "N":
                                toBeAccessRole = accessRoleSuffix + "_" + sfParams.envTo + "_" + schemaName + "_" + accessKey
                                if toBeAccessRole.upper() == accessRole:
                                    # Grant the access role to the functional role
                                    sfDBCalls.outFile.write("    GRANT ROLE " + accessRole + " TO ROLE " + funcRole + ";\n")

        # Grant the schema privilages to the missing access roles
        for accessRole in lstMissingAccessRoles:
            for index, rows in sfEnvSheet.iterrows():
                if (rows['TYPE'].upper() == "SCHEMA"):
                    schemaName = rows['OBJECT']
                    # Is this schema anything to do with the access role
                    if accessRole.upper().find(schemaName.upper()):
                        # Get the privileges for this this key
                        for index, rows in sfConfigSheet.iterrows():
                            if rows['TYPE'].upper() == "SCHEMA_PRIVS":
                                # grant privileges on the access roles for schemas
                                accessKey = rows['KEY']
                                toBeAccessRole = accessRoleSuffix + "_" + sfParams.envTo + "_" + schemaName + "_" + accessKey
                                if toBeAccessRole.upper() == accessRole.upper():
                                    sfDBCalls.grant_access_role_privileges(schemaName,
                                                                           sfParams.envTo + "_" + schemaName + "_" + rows['KEY'],
                                                                           rows['VALUE'], "FALSE", "", "FALSE"
                                                                           , accessRolePrefix, accessRoleSuffix)
                                    sfDBCalls.grant_access_role_privileges(schemaName,
                                                                           sfParams.envTo + "_" + schemaName + "_" +
                                                                           rows['KEY'],
                                                                           rows['VALUE'], "FALSE", "TRUE", "FALSE"
                                                                           , accessRolePrefix, accessRoleSuffix)
                                    sfDBCalls.outFile.flush()






        # Grant access roles to functional roles
        if permissionType.upper() == "PERMISSIVE":
            sfDBCalls.write_script_comment("... Permissive. Grant DB level access roles to functional roles")
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "DB-PERMISSIONS":
                    for funcRole in lstMissingFunctionalRoles:
                        sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo, rows[funcRole],
                                                                          sfParams.envTo + "_" + funcRole,
                                                                          accessRolePrefix,
                                                                          accessRoleSuffix)
            # Overrides
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA_O":
                    for funcRole in lstMissingFunctionalRoles:
                        if not rows[funcRole].upper() == "N":
                            sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'],
                                                                              rows[funcRole],
                                                                              sfParams.database + "_" + funcRole,
                                                                              accessRolePrefix, accessRoleSuffix)

        else:
            sfDBCalls.write_script_comment("Grant access roles to functional roles")
            for index, rows in sfEnvSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA":
                    for funcRole in lstMissingFunctionalRoles:
                        if not rows[funcRole].upper() == "N":
                            sfDBCalls.grantSelectedAccessRoleToFunctionalRole(sfParams.envTo + "_" + rows['OBJECT'],
                                                                              rows[funcRole],
                                                                              sfParams.database + "_" + funcRole,
                                                                              accessRolePrefix, accessRoleSuffix)




        ################################################################################################################
        # after loop, finalise tasks                                                                                   #
        ################################################################################################################
        a=1
        # <TODO>
        # Check the access roles exist in the DB and have the correct owner - done
        # Check the access roles are granted to the functional role - done
        # Check if there are any roles in the database for this environment that are not in the spread sheet - done
        # Check db's, schemas and roles on account level - done
        # Check users with

        # Terminate
        sfDBCalls.closeFile()
        logger.info("Closing DB connections")
        sfConn.close()

    except Exception as e:
        logger.error(str(e))
        sfDBCalls.closeFile()
        sys.exit(3)





if __name__ == '__main__':
    main(sys.argv[1:])