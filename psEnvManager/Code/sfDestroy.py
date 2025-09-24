import snowflake.connector
from SFConnectionConfig import *
from SFSpreadsheet import *
from SFDBCalls import *
from SFParams import *
from SFPrompt import *



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
        logger.info("* sfDestroy Started                    *")
        logger.info("**************************************")

        sfConnectionConfig = SFConnectionConfig()
        spreadSheet = SFSpreadsheet()
        sfPrompt = SFPrompt()

        # Process Parameters
        try:
            opts, args = getopt.getopt(argv, "c:s:a:e:o:", ["config=", "spreadsheet=","action=","envTo=","outscript="])
        except getopt.GetoptError as e:
            logger.info("Invalid Parameter(s)  " + e.msg)
            sys.exit(2)

        sfParams = SFParams(opts, args, logger)

        # Validate parameters
        if sfParams.validate() < 0:
            exit(1)

        try:
            sfConnectionConfig.readConfig(sfParams.snowflakeConnFile)
            dfConfig = spreadSheet.readSpreadSheet(sfParams.spreadsheetFile, "CONFIG")

            if sfConnectionConfig.sfPassword == "":
                sfConnectionConfig.sfPassword = sfPrompt.getPassword()

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


        # Obtain securityAdmin and SysAdmin roles for the environemnt
        secAdminRole = sfParams.envTo.upper() + "_" + spreadSheet.getAdminRole("SECURITY-ADMIN", dfConfig)
        sysAdminRole = sfParams.envTo.upper() + "_" + spreadSheet.getAdminRole("SYSTEM-ADMIN", dfConfig)

        # Instantiate the snowflake DB call class
        sfDBCalls = SFDBCalls(logger, sfConn, sfParams.outScript, sfParams.runDDL)


        # Write script header
        sfDBCalls.writeScriptHeader("sfDestroy_" + sfParams.envTo, "sfDestroy_.py", "No Spreadsheet", sfParams.envTo)

        # Get all access and functional roles for this env.
        tplRoles = sfDBCalls.getEnvRoles("SECURITYADMIN",sfParams.envTo,secAdminRole)

        # Drop these roles
        for roleToDrop in tplRoles:
            sfDBCalls.dropRole("SECURITYADMIN",roleToDrop[0])

        # Drop the data warehouses
        tplWarehouses = sfDBCalls.getWarehouses("SYSADMIN", sfParams.envTo)
        for virtWarehouse in tplWarehouses:
            sfDBCalls.dropWarehouse(virtWarehouse[0], "ACCOUNTADMIN")



        # Drop the database
        sfDBCalls.dropDB(sfParams.envTo, "ACCOUNTADMIN","Y")

        # Drop security Roles
        #sfDBCalls.dropRole("SECURITYADMIN", sysAdminRole)
        #sfDBCalls.dropRole("SECURITYADMIN", secAdminRole)

        # Terminate
        sfDBCalls.closeFile()
        logger.info("Closing DB connections")
        sfConn.close()

    except Exception as e:
        logger.error(str(e))
        sfDBCalls.closeFile()
        sys.exit(3)





if __name__ == '__main__':
    sys.argv.append("-a")
    sys.argv.append("DESTROY")
    main(sys.argv[1:])