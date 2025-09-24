# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      sfBuildSecurity.py
#
# Purpose:   Callable script.  Builds the security layer for one or more environments
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
    logger.info("* sfSecurity Started                 *")
    logger.info("**************************************")

    sfConnectionConfig = SFConnectionConfig()
    spreadSheet = SFSpreadsheet()
    sfPrompt = SFPrompt()


    # Process Parameters
    try:
        opts, args = getopt.getopt(argv, "c:s:a:e:o:r:", ["config=", "spreadsheet=","action=","envTo=","outscript=","run="])
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

    # Create NEW environment
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

    # Get list of environments to build
    lstEnvironments = sfParams.envTo.split(",")

    # Read the CLONE and CONFIG Tables
    try:
        dfConfig = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "CONFIG")
    except Exception as e:
        logger.error("Unable to read spread sheet and obtain CONFIG and CLONE_SECURITY: " + str(e))
        sys.exit(3)

    # Instantiate the snowflake DB call class
    sfDBCalls = SFDBCalls(logger, sfConn, sfParams.outScript, sfParams.runDDL)

    # Write script header
    sfDBCalls.writeScriptHeader("sfBuildSecurity", "sfBuildSecurity.py", sfParams.spreadsheetFile, sfParams.envTo)

    for environment in lstEnvironments:
        # Read the spreadsheet
        try:
            dfSheet = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, environment)
        except Exception as e:
            logger.error("Unable to read spread sheet: " + str(e))
            sys.exit(3)

        # Obtain securityAdmin and SysAdmin roles for the environemnt
        secAdminRole = environment + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", dfConfig)
        sysAdminRole = environment + "_" + spreadSheet.getAdminRole("SYSTEM-ADMIN", dfConfig)
        #accountMasterRole = spreadSheet.getAdminRole("MASTER-ADMIN", dfConfig)
        #envMasterRole = environment + "_" + spreadSheet.getAdminRole("ENV-MASTER", dfConfig)

        # As SYSADMIN, create these two roles.
        #sfDBCalls.createAccountMasterRole(accountMasterRole, " IF NOT EXISTS ")
        #sfDBCalls.createEnvMasterRole(envMasterRole, " IF NOT EXISTS ")
        sfDBCalls.createSecAdminRole(secAdminRole, "", environment)
        sfDBCalls.createSysAdminRole(secAdminRole, sysAdminRole, "", environment)
        #sfDBCalls.grantsForEnvMaster(envMasterRole, sysAdminRole, secAdminRole, "")
        #sfDBCalls.createUsageRole(secAdminRole,environment)

    sfDBCalls.closeFile()
    logger.info("**************************************")
    logger.info("* sfBuildSecurity Complete           *")
    logger.info("* Script is: " + sfParams.outScript + " *")
    logger.info("**************************************")
    exit(0)

if __name__ == '__main__':
    sys.argv.append("-a")
    sys.argv.append("NEWSEC")
    main(sys.argv[1:])