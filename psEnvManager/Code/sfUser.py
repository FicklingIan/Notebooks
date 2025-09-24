# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      sfUser.py
#
# Purpose:   Callable script. Provides user management functions
#
# History:
# Date        |  Author             | Action
#-------------+---------------------+----------------------------------------
# 16-May-2020 |  Andreas Liskes     |  Version 0.1
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

    # Configure logging
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    fmt = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
    ch = logging.StreamHandler()
    ch.setFormatter(fmt)
    logger.addHandler(ch)

    logger.info("**************************************")
    logger.info("* sfUser     Started                 *")
    logger.info("**************************************")

    sfConnectionConfig = SFConnectionConfig()
    spreadSheet = SFSpreadsheet()
    sfPrompt = SFPrompt()


    # Process Parameters
    try:
        opts, args = getopt.getopt(argv, "c:s:a:e:o:r:u:", ["config=", "spreadsheet=","action=", "envTo=", "outscript=", "run=", "useraction"])
    except getopt.GetoptError as e:
        logger.info("Invalid Parameter(s)  " + e.msg)
        sys.exit(2)

    sfParams = SFParams(opts, args, logger)

    # Validate parameters
    if sfParams.validate() < 0:
        exit(1)

    # Get list of environments to verify
    lstEnvironments = sfParams.envTo.split(",")

    # Connect to Snowflake
    # If the config file is specified, read it
    if sfParams.runDDL.upper() == "TRUE":
        try:
            logger.info("Connecting to Snowflake")
            sfConnectionConfig.readConfig(sfParams.snowflakeConnFile)
            if sfConnectionConfig.sfPassword == "":
                sfConnectionConfig.sfPassword = sfPrompt.getPassword()
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

    # read the spreadsheet's user tab
    try:
        sfUserSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "USER")
    except Exception as e:
        logger.error("Unable to read spread sheet and obtain the User: " + str(e))
        sys.exit(3)

    # Instantiate the snowflake DB call class
    sfDBCalls = SFDBCalls(logger, sfConn, sfParams.outScript, sfParams.runDDL)

    # Write script header
    sfDBCalls.writeScriptHeader("sfUser", "sfUser.py", sfParams.spreadsheetFile, "")

    # Try first to switch to USERADMIN
    if sfDBCalls.tryUseradminRole(sfConnectionConfig.sfUser) is False:
        sys.exit(3)

    if sfParams.useraction.upper() == "CREATE":
        # Create the User
        for index, rows in sfUserSheet.iterrows():
            if str((rows['ACTION'])) != 'nan':
                if rows['ACTION'].strip().upper() == "C" or rows['ACTION'].strip().upper() == "CREATE":
                    sfDBCalls.createUser(str(rows['NAME']), str(rows['PASSWORD']), str(rows['LOGIN_NAME']),
                                         str(rows['DISPLAY_NAME']), str(rows['FIRST_NAME']), str(rows['LAST_NAME']),
                                         str(rows['EMAIL']), str(rows['MINS_TO_UNLOCK']), str(rows['DAYS_TO_EXPIRY']),
                                         str(rows['COMMENT']), str(rows['DISABLED']), str(rows['MUST_CHANGE_PASSWORD']),
                                         str(rows['DEFAULT_WAREHOUSE']), str(rows['DEFAULT_NAMESPACE']),
                                         str(rows['DEFAULT_ROLE']), str(rows['MINS_TO_BYPASS_MFA']),
                                         str(rows['EXPIRES_AT_TIME']), str(rows['LOCKED_UNTIL_TIME']), "IF NOT EXISTS")

    if sfParams.useraction.upper() == "ALTER":
        # Alter the User
        for index, rows in sfUserSheet.iterrows():
            if str((rows['ACTION'])) != 'nan':
                if rows['ACTION'].strip().upper() == "A" or rows['ACTION'].strip().upper() == "ALTER":
                    sfDBCalls.alterUser(str(rows['NAME']), str(rows['PASSWORD']), str(rows['LOGIN_NAME']),
                                         str(rows['DISPLAY_NAME']), str(rows['FIRST_NAME']), str(rows['LAST_NAME']),
                                         str(rows['EMAIL']), str(rows['MINS_TO_UNLOCK']), str(rows['DAYS_TO_EXPIRY']),
                                         str(rows['COMMENT']), str(rows['DISABLED']), str(rows['MUST_CHANGE_PASSWORD']),
                                         str(rows['DEFAULT_WAREHOUSE']), str(rows['DEFAULT_NAMESPACE']),
                                         str(rows['DEFAULT_ROLE']), str(rows['MINS_TO_BYPASS_MFA']),
                                         str(rows['EXPIRES_AT_TIME']), str(rows['LOCKED_UNTIL_TIME']), "IF EXISTS")

    # and now - grant the functional role to the users

    sfDBCalls.outFile.write("\n")
    sfDBCalls.outFile.write("-- ###########################################################################\n")
    sfDBCalls.outFile.write("-- ## Grant or revoke functional roles to / from users                      ##\n")
    sfDBCalls.outFile.write("-- ###########################################################################\n")
    sfDBCalls.outFile.write("\n")

    ################################################################################################################
    # loop over all environments                                                                                   #
    ################################################################################################################

    for environment in lstEnvironments:
        # Read the spreadsheet
        try:
            sfEnvSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, environment)
            sfConfigSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "CONFIG")
        except Exception as e:
            logger.error("Unable to read spread sheet: " + str(e))
            sys.exit(3)

        sfDBCalls.outFile.write("\n")
        sfDBCalls.outFile.write("-- ###########################################################################\n")
        sfDBCalls.outFile.write("-- ## " + (environment.strip() + (" " * 69))[:69] + " ##\n")
        sfDBCalls.outFile.write("-- ###########################################################################\n")
        sfDBCalls.outFile.write("\n")

        secAdminRole = environment.upper() + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", sfConfigSheet)

        # Try first to switch to SECURITYADMIN
        if sfDBCalls.trySecurityadminRole() is False:
            sys.exit(3)

        # Get the list of options
        dictGrantOptions = spreadSheet.getGrantOptions(sfConfigSheet)

        # Get a list of the functional roles
        lstFunctionalRoles = sfEnvSheet.columns.values[4:]
        lstFunctionalRoles = list(dict.fromkeys(lstFunctionalRoles))
        lstFunctionalRolesCopy = []

        for funcRole in lstFunctionalRoles:
            if not funcRole[0:7] == 'Unnamed':
                lstFunctionalRolesCopy.append(funcRole)

        lstFunctionalRoles = lstFunctionalRolesCopy

        # Remove unamed columns
        for myLst in lstFunctionalRolesCopy:
            if myLst[0:7] == 'Unnamed':
                lstFunctionalRoles.remove(myLst)


        # Iterate through the sheet.
        # For each user in rows
        #    For each functional role in columns
        #        grant the functional roles to the users
        for index, rows in sfEnvSheet.iterrows():
            if rows['TYPE'].upper() == "USER":
                for funcRole in lstFunctionalRoles:
                    if not rows[funcRole].upper() == "N":
                        sfDBCalls.grantFunctio



                        nalRoleToUser(environment, funcRole, rows['OBJECT'], rows[funcRole], dictGrantOptions)

    # finish - clean up

    sfDBCalls.closeFile()
    logger.info("**************************************")
    logger.info("* sfBuildSecurity Complete           *")
    logger.info("* Script is: " + sfParams.outScript + " *")
    logger.info("**************************************")
    exit(0)

if __name__ == '__main__':
    sys.argv.append("-a")
    sys.argv.append("USER")
    main(sys.argv[1:])