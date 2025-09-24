# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      SFDBCalls.py
#
# Purpose:   Helper class.  All database scripts and interaction are done here
#
# History:
# Date        |  Author             | Action
# ------------+---------------------+----------------------------------------
# 31-Mar-2020 |  Ian Fickling       |  Version 1.0
# 12-Apr-2020 |  Ian Fickling       |  Version 1.02 - Blank options not being handled
#             |                     |                 correctly.  Fixed with new method isNan.
#             |                     |


import snowflake.connector
# import logging
import datetime
import time
# import math

class SFDBCalls:

    def __init__(self, logger, dbConn, outScript, runDDL):
        self.logger = logger
        self.dbConn = dbConn
        self.outScript = outScript
        self.runDDL = runDDL

        if not self.outScript == "":
            self.outFile = open(self.outScript ,"w")

    def writeScriptHeader(self, scriptName, buildingScript, spreadsheetName, envName):
        # Build the header
        headerLine1 = "File           : " + scriptName + ".sql"
        headerLine2 = "Created By     : " + buildingScript
        headerLine3 = "Date           : " + str(datetime.date.today())
        headerLine4 = "Time           : " + str(time.strftime("%H:%M"))
        headerLine5 = "Spreadsheet    : " + spreadsheetName
        headerLine6 = "Environment(s) : " + envName
        headerLineX = ""

        # Get max length
        maxLength = len(max([headerLine1 ,headerLine2 ,headerLine3 ,headerLine4 ,headerLine5 ,headerLine6] ,key=len))
        headerLineX = "-- **" + ('*' * maxLength) + "**\n"
        headerLine1 = "-- * " + (headerLine1 + (' ' * maxLength))[:maxLength] + " *\n"
        headerLine2 = "-- * " + (headerLine2 + (' ' * maxLength))[:maxLength] + " *\n"
        headerLine3 = "-- * " + (headerLine3 + (' ' * maxLength))[:maxLength] + " *\n"
        headerLine4 = "-- * " + (headerLine4 + (' ' * maxLength))[:maxLength] + " *\n"
        headerLine5 = "-- * " + (headerLine5 + (' ' * maxLength))[:maxLength] + " *\n"
        headerLine6 = "-- * " + (headerLine6 + (' ' * maxLength))[:maxLength] + " *\n"

        self.outFile.write("\n")
        self.outFile.write(headerLineX)
        # self.outFile.write(headerLine1)
        # self.outFile.write(headerLine2)
        self.outFile.write(headerLine3)
        self.outFile.write(headerLine4)
        self.outFile.write(headerLine5)
        self.outFile.write(headerLine6)
        self.outFile.write(headerLineX)
        self.outFile.write("\n")

    def write_script_comment(self, comment):

        # Get max length
        max_length = len(max([comment," "*100], key=len))
        first_line = "-- +-" + ('-' * max_length) + "-+\n"
        last_line = "-- +-" + ('-' * max_length) + "-+\n"
        comment_line = "-- | " + (comment + (' ' * max_length))[:max_length] + " |\n"

        self.outFile.write("\n")
        self.outFile.write(first_line)
        self.outFile.write(comment_line)
        self.outFile.write(last_line)
        self.outFile.write("\n")

    def write_line(self, comment):
        self.outFile.write(comment)
        self.outFile.write("\n")

    #  ****************************************************************************************************************
    #  *                                                                                                              *
    #  *   FILE-HANDLER                                                                                               *
    #  *                                                                                                              *
    #  ****************************************************************************************************************

    def closeFile(self):
        self.outFile.close()

    #  ****************************************************************************************************************
    #  *                                                                                                              *
    #  *   DB-HANDLER                                                                                                 *
    #  *                                                                                                              *
    #  ****************************************************************************************************************

    def createDB(self, dbName, secAdminRole, sysAdminRole, dataRetention, defaultDDLColation):
        try:
            ddlString1 = "   USE ROLE " + sysAdminRole
            ddlString2 = "   CREATE DATABASE IF NOT EXISTS " + dbName + " DATA_RETENTION_TIME_IN_DAYS = " + dataRetention
            if not defaultDDLColation == "NONE":
                ddlString2 += " DEFAULT_DDL_COLLATION = '" + defaultDDLColation + "' "

            # Role sysAdminRole is owner - no grants necessary
            # ddlString3 = "   GRANT ALL PRIVILEGES ON DATABASE " + dbName + " TO ROLE " + sysAdminRole

            if not self.outScript == "":
                self.outFile.write("\n")
                self.outFile.write("-- *************************\n")
                self.outFile.write("-- * Create Database       *\n")
                self.outFile.write("-- *************************\n")
                self.outFile.write("\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                # self.outFile.write(ddlString3 + ";\n")
                self.outFile.write("\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Creating database: " + dbName)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                # self.executeDDL(ddlString3, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createDB \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    def create_db(self, db_name, data_retention, default_ddl_collation):
        try:
            ddl_string = "   CREATE DATABASE IF NOT EXISTS " + db_name + " DATA_RETENTION_TIME_IN_DAYS = " + data_retention
            if not default_ddl_collation == "NONE":
                ddl_string += " DEFAULT_DDL_COLLATION = '" + default_ddl_collation + "' "

            if not self.outScript == "":
                self.outFile.write(ddl_string + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Creating database: " + db_name)
                self.executeDDL(ddl_string, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.create_db \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    def dropWarehouse(self, warehouseName, roleToUse):
        try:

            ddlString1 = "USE ROLE " + roleToUse
            ddlString2 = "DROP WAREHOUSE " + warehouseName

            if not self.outScript == "":
                self.outFile.write("-- *************************\n")
                self.outFile.write("-- * Drop Warehouse         *\n")
                self.outFile.write("-- *************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Drop WH: " + dbName)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.dropWarehouse \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

            if str(sfExp).upper().find("DOES NOT EXIST") == -1:
                raise
            else:
                self.logger.error("Warehouse does not exist, will continue")

    def dropDB(self, dbName, roleToUse, cascadeFlag):
        try:

            ddlString1 = "USE ROLE " + roleToUse
            ddlString2 = "DROP DATABASE " + dbName

            if cascadeFlag == "Y":
                ddlString2 += " CASCADE"

            if not self.outScript == "":
                self.outFile.write("-- *************************\n")
                self.outFile.write("-- * Drop Database         *\n")
                self.outFile.write("-- *************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Drop DB: " + dbName)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.dropDB \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

            if str(sfExp).upper().find("DOES NOT EXIST") == -1:
                raise
            else:
                self.logger.error("DB does not exist, will continue")

    def cloneDB(self, sourceDB, targetDB, dfSheet, sysAdminRole, sysFromAdminRole):
        try:
            ddlString1 = "USE ROLE " + sysFromAdminRole
            ddlString2 = "CREATE  DATABASE IF NOT EXISTS "  + targetDB + " CLONE " + sourceDB

            if not self.outScript == "":
                self.outFile.write("-- *************************\n")
                self.outFile.write("-- * Clone Database        *\n")
                self.outFile.write("-- *************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Clone DB: " + sourceDB + " to " + targetDB)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)

            ddlString3 = "GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE  " + targetDB + " TO ROLE " + sysAdminRole + " REVOKE CURRENT GRANTS"
            ddlString4 = "GRANT OWNERSHIP ON DATABASE " + targetDB + " TO ROLE " + sysAdminRole

            if not self.outScript == "":
                self.outFile.write("-- ********************************************\n")
                self.outFile.write("-- * Granting Ownership on DB to Role         *\n")
                self.outFile.write("-- * Granting Ownership on all schemas in DB  *\n")
                self.outFile.write("-- *******************************************\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)

            ddlString5 = "USE ROLE " + sysAdminRole
            # Obtain all schemas from the spreadsheet and fix the grants on the schema
            if not self.outScript == "":
                self.outFile.write("-- ***********************************\n")
                self.outFile.write("-- * Granting Ownership on schemas   *\n")
                self.outFile.write("-- ***********************************\n")
                self.outFile.write(ddlString5 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.executeDDL(ddlString5, False)

            lstSchema = []
            for index, rows in dfSheet.iterrows():
                if rows['TYPE'].upper() == "SCHEMA":
                    lstSchema.append(rows['OBJECT'])

            for schemaName in lstSchema:
                ddlString6 = "GRANT OWNERSHIP ON ALL TABLES IN SCHEMA " + targetDB + "." + schemaName + \
                    " TO ROLE " + sysAdminRole + " REVOKE CURRENT GRANTS"

                if not self.outScript == "":
                    self.outFile.write(ddlString6 + ";\n")

                if self.runDDL.upper() == "TRUE":
                    self.executeDDL(ddlString6, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.cloneDB \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    #  ****************************************************************************************************************
    #  *                                                                                                              *
    #  *   SCHEMA-HANDLER                                                                                             *
    #  *                                                                                                              *
    #  ****************************************************************************************************************

    def createSchema(self, dbName, schemaName, options, sysAdminRole, secAdminRole, clause):
        try:

            if self.isNaN(options):
                options = ""

            # if options contains "with managed access" - replace with "", because we were setting this to mandatory
            options = options.replace("with managed access","")

            ddlString1 = "USE ROLE " + sysAdminRole

            # Check if the options contains 'TRANSIENT'
            if "TRANSIENT" in options:
                options = options.upper().replace("TRANSIENT", "")
                ddlString2 =  "CREATE TRANSIENT SCHEMA " + clause + " " + dbName + "." + schemaName + " WITH MANAGED ACCESS " + options
            else:
                ddlString2 = "CREATE SCHEMA " + clause + " " + dbName + "." + schemaName + " WITH MANAGED ACCESS " + options

            if not self.outScript == "":
                self.outFile.write("-- ********************************************\n")
                self.outFile.write("-- * Create Schema                            *\n")
                self.outFile.write("-- ********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Schema DB: " + dbName + "." + schemaName)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createSchema \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    def create_schema(self, dbName, schemaName, options, sysAdminRole, secAdminRole, clause):
        try:

            if self.isNaN(options):
                options = ""

            if schemaName.upper() == "INFORMATION_SCHEMA":
                return

            # if options contains "with managed access" - replace with "", because we were setting this to mandatory
            options = options.replace("with managed access","")

            if "TRANSIENT" in options:
                options = options.upper().replace("TRANSIENT", "")
                ddl_string = "   CREATE TRANSIENT SCHEMA " + clause + " " + dbName + "." + schemaName + " WITH MANAGED ACCESS " + options + ";"
            else:
                ddl_string = "   CREATE SCHEMA " + clause + " " + dbName + "." + schemaName + " WITH MANAGED ACCESS " + options + ";"

            if not self.outScript == "":
                self.outFile.write(ddl_string + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Schema DB: " + dbName + "." + schemaName)
                self.executeDDL(ddl_string, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.create_schema \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    #  ****************************************************************************************************************
    #  *                                                                                                              *
    #  *   USER-HANDLER                                                                                               *
    #  *                                                                                                              *
    #  ****************************************************************************************************************

    def createUser(self, name, password, login_name, display_name, first_name, last_name, email, mins_to_unlock,
                   days_to_expiry, comment, disabled, must_change_password, default_warehouse, default_namespace,
                   default_role, mins_to_bypass_mfa, expires_at_time, locked_until_time, clause):
        try:
            ddl_name = name.strip()

            if password == 'nan':
                ddl_password = ""
            else:
                ddl_password = "PASSWORD = '" + password.strip() + "' "

            if login_name == 'nan':
                ddl_login_name = "LOGIN_NAME = '" + ddl_name + "' "
            else:
                ddl_login_name = "LOGIN_NAME = '" + login_name.strip() + "' "

            if display_name != 'nan':
                ddl_display_name = "DISPLAY_NAME = '" + display_name.strip() + "' "
            else:
                ddl_display_name = "DISPLAY_NAME = '" + ddl_name + "' "

            if first_name != 'nan':
                ddl_first_name = "FIRST_NAME = '" + first_name.strip() + "' "
            else:
                ddl_first_name = ""

            if last_name != 'nan':
                ddl_last_name = "LAST_NAME = '" + last_name.strip() + "' "
            else:
                ddl_last_name = ""

            if email != 'nan':
                ddl_email = "EMAIL = '" + email.strip() + "' "
            else:
                ddl_email = ""

            if mins_to_unlock != 'nan':
                ddl_mins_to_unlock = "MINS_TO_UNLOCK = " + mins_to_unlock.strip() + " "
            else:
                ddl_mins_to_unlock = ""

            if days_to_expiry != 'nan':
                ddl_days_to_expiry = "DAYS_TO_EXPIRY = " + days_to_expiry.strip() + " "
            else:
                ddl_days_to_expiry = ""

            if comment != 'nan':
                ddl_comment = "COMMENT = '" + comment.strip() + "' "
            else:
                ddl_comment = ""

            if disabled != 'nan':
                ddl_disabled = "DISABLED = " + disabled.strip() + " "
            else:
                ddl_disabled = ""

            if must_change_password != 'nan':
                ddl_must_change_password = "MUST_CHANGE_PASSWORD = " + must_change_password.strip() + " "
            else:
                ddl_must_change_password = ""

            if default_warehouse != 'nan':
                ddl_default_warehouse = "DEFAULT_WAREHOUSE = '" + default_warehouse.strip() + "' "
            else:
                ddl_default_warehouse = ""

            if default_namespace != 'nan':
                ddl_default_namespace = "DEFAULT_NAMESPACE = '" + default_namespace.strip() + "' "
            else:
                ddl_default_namespace = ""

            if default_role != 'nan':
                ddl_default_role = "DEFAULT_ROLE = '" + default_role.strip() + "' "
            else:
                ddl_default_role = ""

            if mins_to_bypass_mfa != 'nan':
                ddl_mins_to_bypass_mfa = "MINS_TO_BYPASS_MFA = " + mins_to_bypass_mfa.strip() + " "
            else:
                ddl_mins_to_bypass_mfa = ""

            if expires_at_time != 'nan':
                ddl_expires_at_time = "EXPIRES_AT_TIME = " + expires_at_time.strip() + " "
            else:
                ddl_expires_at_time = ""

            if locked_until_time != 'nan':
                ddl_locked_until_time = "LOCKED_UNTIL_TIME = " + locked_until_time.strip() + " "
            else:
                ddl_locked_until_time = ""

            ddlString = "CREATE USER " + clause + " " + ddl_name + " " + ddl_password + ddl_login_name + \
                        ddl_display_name + ddl_first_name + ddl_last_name + ddl_email + ddl_mins_to_unlock + \
                        ddl_days_to_expiry + ddl_comment + ddl_disabled + ddl_must_change_password + \
                        ddl_default_warehouse + ddl_default_namespace + ddl_default_role + \
                        ddl_mins_to_bypass_mfa + ddl_expires_at_time + ddl_locked_until_time

            if not self.outScript == "":
                self.outFile.write(ddlString + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create User: " + ddl_name)
                self.executeDDL(ddlString, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createUser \n" + "Error No: " + str(sfExp.errno) + "\n" + str(
                sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    def alterUser(self, name, password, login_name, display_name, first_name, last_name, email, mins_to_unlock,
                   days_to_expiry, comment, disabled, must_change_password, default_warehouse, default_namespace,
                   default_role, mins_to_bypass_mfa, expires_at_time, locked_until_time, clause):
        try:
            ddl_name = name.strip()

            # for alter command, variables have to be processed twice
            # first for set
            # second for unset

            if password == 'nan':
                ddl_password = ""
            else:
                ddl_password = "PASSWORD = '" + password.strip() + "' "

            if login_name == 'nan':
                ddl_login_name = "LOGIN_NAME = '" + ddl_name + "' "
            else:
                ddl_login_name = "LOGIN_NAME = '" + login_name.strip() + "' "

            if display_name != 'nan':
                ddl_display_name = "DISPLAY_NAME = '" + display_name.strip() + "' "
            else:
                ddl_display_name = "DISPLAY_NAME = '" + ddl_name + "' "

            if first_name != 'nan':
                ddl_first_name = "FIRST_NAME = '" + first_name.strip() + "' "
            else:
                ddl_first_name = ""

            if last_name != 'nan':
                ddl_last_name = "LAST_NAME = '" + last_name.strip() + "' "
            else:
                ddl_last_name = ""

            if email != 'nan':
                ddl_email = "EMAIL = '" + email.strip() + "' "
            else:
                ddl_email = ""

            if mins_to_unlock != 'nan':
                ddl_mins_to_unlock = "MINS_TO_UNLOCK = " + mins_to_unlock.strip() + " "
            else:
                ddl_mins_to_unlock = ""

            if days_to_expiry != 'nan':
                ddl_days_to_expiry = "DAYS_TO_EXPIRY = " + days_to_expiry.strip() + " "
            else:
                ddl_days_to_expiry = ""

            if comment != 'nan':
                ddl_comment = "COMMENT = '" + comment.strip() + "' "
            else:
                ddl_comment = ""

            if disabled != 'nan':
                ddl_disabled = "DISABLED = " + disabled.strip() + " "
            else:
                ddl_disabled = ""

            if must_change_password != 'nan':
                ddl_must_change_password = "MUST_CHANGE_PASSWORD = " + must_change_password.strip() + " "
            else:
                ddl_must_change_password = ""

            if default_warehouse != 'nan':
                ddl_default_warehouse = "DEFAULT_WAREHOUSE = '" + default_warehouse.strip() + "' "
            else:
                ddl_default_warehouse = ""

            if default_namespace != 'nan':
                ddl_default_namespace = "DEFAULT_NAMESPACE = '" + default_namespace.strip() + "' "
            else:
                ddl_default_namespace = ""

            if default_role != 'nan':
                ddl_default_role = "DEFAULT_ROLE = '" + default_role.strip() + "' "
            else:
                ddl_default_role = ""

            if mins_to_bypass_mfa != 'nan':
                ddl_mins_to_bypass_mfa = "MINS_TO_BYPASS_MFA = " + mins_to_bypass_mfa.strip() + " "
            else:
                ddl_mins_to_bypass_mfa = ""

            if expires_at_time != 'nan':
                ddl_expires_at_time = "EXPIRES_AT_TIME = " + expires_at_time.strip() + " "
            else:
                ddl_expires_at_time = ""

            if locked_until_time != 'nan':
                ddl_locked_until_time = "LOCKED_UNTIL_TIME = " + locked_until_time.strip() + " "
            else:
                ddl_locked_until_time = ""

            ddlStringSet = ddl_password + ddl_login_name + ddl_display_name + ddl_first_name + \
                           ddl_last_name + ddl_email + ddl_mins_to_unlock + ddl_days_to_expiry + \
                           ddl_comment + ddl_disabled + ddl_must_change_password + ddl_default_warehouse + \
                           ddl_default_namespace + ddl_default_role + ddl_mins_to_bypass_mfa + \
                           ddl_expires_at_time + ddl_locked_until_time

            if ddlStringSet.strip() != "":
                ddlStringSet = "ALTER USER " + clause + " " + ddl_name + " SET " + ddlStringSet
            else:
                ddlStringSet = ""

            # now get all the empty fields and build the unset string
            # but do not unset the password

            if first_name == 'nan':
                # == 'nan' field is empty = > unset
                ddl_first_name = "FIRST_NAME,"
            else:
                # != 'nan' field is not empty => set
                ddl_first_name = ""

            if last_name == 'nan':
                ddl_last_name = "LAST_NAME,"
            else:
                ddl_last_name = ""

            if email == 'nan':
                ddl_email = "EMAIL,"
            else:
                ddl_email = ""

            if days_to_expiry == 'nan':
                ddl_days_to_expiry = "DAYS_TO_EXPIRY,"
            else:
                ddl_days_to_expiry = ""

            if comment == 'nan':
                ddl_comment = "COMMENT,"
            else:
                ddl_comment = ""

            if disabled == 'nan':
                ddl_disabled = "DISABLED,"
            else:
                ddl_disabled = ""

            if must_change_password == 'nan':
                ddl_must_change_password = "MUST_CHANGE_PASSWORD,"
            else:
                ddl_must_change_password = ""

            if default_warehouse == 'nan':
                ddl_default_warehouse = "DEFAULT_WAREHOUSE,"
            else:
                ddl_default_warehouse = ""

            if default_namespace == 'nan':
                ddl_default_namespace = "DEFAULT_NAMESPACE,"
            else:
                ddl_default_namespace = ""

            if default_role == 'nan':
                ddl_default_role = "DEFAULT_ROLE,"
            else:
                ddl_default_role = ""

            ddlStringUnset = ddl_first_name + ddl_last_name + ddl_email + ddl_days_to_expiry + \
                             ddl_comment + ddl_disabled + ddl_must_change_password + \
                             ddl_default_warehouse + ddl_default_namespace + ddl_default_role

            if ddlStringUnset.strip() != "":
                # from concat, last char is a ',' - remove
                ddlStringUnset = "ALTER USER " + clause + " " + ddl_name + " UNSET " + ddlStringUnset[:-1]
            else:
                ddlStringUnset = ""

            if not self.outScript == "" and ddlStringSet != "":
                self.outFile.write(ddlStringSet + ";\n")

            if not self.outScript == "" and ddlStringUnset != "":
                self.outFile.write(ddlStringUnset + ";\n")

            if self.runDDL.upper() == "TRUE" and ddlStringSet != "":
                self.logger.info("Alter User - SET: " + ddl_name)
                self.executeDDL(ddlStringSet, False)

            if self.runDDL.upper() == "TRUE" and ddlStringUnset != "":
                self.logger.info("Alter User - UNSET: " + ddl_name)
                self.executeDDL(ddlStringUnset, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.alterUser \n" + "Error No: " + str(sfExp.errno) + "\n" + str(
                sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)
            raise

    #  ****************************************************************************************************************
    #  *                                                                                                              *
    #  *   ROLE-HANDLER                                                                                               *
    #  *                                                                                                              *
    #  ****************************************************************************************************************

    def createAccountMasterRole(self, accountMaster, clause):
        try:
            ddlString1 = "USE ROLE SECURITYADMIN"
            ddlString2 = "CREATE ROLE " + clause + " " + accountMaster
            ddlString3 = "GRANT ROLE SECURITYADMIN TO ROLE " + accountMaster
            ddlString4 = "GRANT ROLE SYSADMIN TO ROLE " + accountMaster

            if not self.outScript == "":
                self.outFile.write("-- ********************************************\n")
                self.outFile.write("-- * Create Account Master role               *\n")
                self.outFile.write("-- ********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Account Mater Role: " + accountMaster)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createAccountMasterRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createEnvMasterRole(self, envMaster, clause):
        try:
            ddlString1 = "USE ROLE SECURITYADMIN"
            ddlString2 = "CREATE ROLE " + clause + " " + envMaster

            if not self.outScript == "":
                self.outFile.write("-- ********************************************\n")
                self.outFile.write("-- * Create Env  Master role                  *\n")
                self.outFile.write("-- ********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Env Master Role: " + envMaster)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createEnvMasterRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)


    def createSysAdminRole(self, secAdminRole, sysAdminRole, clause, environment):
        try:
            cmtString  = (environment.strip() + "                ")[:16]
            ddlString1 = "   USE ROLE USERADMIN"
            ddlString2 = "   CREATE ROLE " + clause + " " + sysAdminRole
            ddlString3 = "   USE ROLE SYSADMIN"
            ddlString4 = "   GRANT CREATE DATABASE ON ACCOUNT TO " + sysAdminRole
            ddlString5 = "   GRANT CREATE WAREHOUSE ON ACCOUNT TO " + sysAdminRole
            ddlString6 = "   USE ROLE USERADMIN"
            ddlString7 = "   GRANT ROLE " + sysAdminRole + " TO ROLE SYSADMIN"

            if not self.outScript == "":
                self.outFile.write("\n")
                self.outFile.write("-- *********************************************************\n")
                self.outFile.write("-- * Create sysadmin role for environment " + cmtString + " *\n")
                self.outFile.write("-- *********************************************************\n")
                self.outFile.write("\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")
                self.outFile.write(ddlString5 + ";\n")
                self.outFile.write(ddlString6 + ";\n")
                self.outFile.write(ddlString7 + ";\n")
                self.outFile.write("\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create sysadmin role for environment: " + sysAdminRole)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)
                self.executeDDL(ddlString5, False)
                self.executeDDL(ddlString6, False)
                self.executeDDL(ddlString7, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createSysAdminRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createSecAdminRole(self, secAdminRole, clause, environment):
        try:
            cmtString = (environment.strip() + "                ")[:10]
            ddlString1 = "   USE ROLE USERADMIN"
            ddlString2 = "   CREATE ROLE " + clause + " " + secAdminRole
            ddlString3 = "   GRANT CREATE ROLE ON ACCOUNT TO " + secAdminRole
            ddlString4 = "   GRANT ROLE " + secAdminRole + " TO ROLE USERADMIN"

            if not self.outScript == "":
                self.outFile.write("\n")
                self.outFile.write("-- *********************************************************\n")
                self.outFile.write("-- * Create security admin role for environment " + cmtString + " *\n")
                self.outFile.write("-- *********************************************************\n")
                self.outFile.write("\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create security admin role for environment: " + secAdminRole)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createSecAdminRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def create_security_roles(self, sys_admin_role, sec_admin_role, master_sys_admin_role, master_sec_admin_role, clause, environment, mode):
        try:
            ddl_string_1 =  "   USE ROLE USERADMIN"

            ddl_string_2 =  "   CREATE ROLE " + clause + " " + sec_admin_role
            ddl_string_2a = "   CREATE ROLE " + clause + " " + master_sec_admin_role
            ddl_string_3 = "   CREATE ROLE " + clause + " " + sys_admin_role
            ddl_string_3a = "   CREATE ROLE " + clause + " " + master_sys_admin_role

            ddl_string_4 = "   GRANT CREATE ROLE ON ACCOUNT TO " + sec_admin_role
            ddl_string_5 = "   GRANT ROLE " + sec_admin_role + " TO ROLE USERADMIN"
            ddl_string_6 = "   GRANT ROLE " + sys_admin_role + " TO ROLE SYSADMIN"
            ddl_string_6a = "   GRANT ROLE " + sec_admin_role + " TO ROLE " + master_sec_admin_role
            ddl_string_6b = "   GRANT ROLE " + sys_admin_role + " TO ROLE " + master_sys_admin_role

            ddl_string_7 = "   USE ROLE SYSADMIN"

            ddl_string_8 = "   GRANT CREATE DATABASE ON ACCOUNT TO " + sys_admin_role
            ddl_string_9 = "   GRANT CREATE WAREHOUSE ON ACCOUNT TO " + sys_admin_role

            if mode.upper() == "PERMISSIVE":
                ddl_string_10 = "   USE ROLE ACCOUNTADMIN"
                ddl_string_11 = "   GRANT MANAGE GRANTS ON ACCOUNT TO ROLE " + sys_admin_role


            if not self.outScript == "":
                self.outFile.write(ddl_string_1 + ";\n")
                self.outFile.write("\n")
                self.outFile.write(ddl_string_2 + ";\n")
                if not master_sec_admin_role.upper() == "NONE":
                    self.outFile.write(ddl_string_2a + ";\n")

                self.outFile.write(ddl_string_3 + ";\n")
                if not master_sys_admin_role.upper() == "NONE":
                    self.outFile.write(ddl_string_3a + ";\n")
                self.outFile.write("\n")
                self.outFile.write(ddl_string_4 + ";\n")
                self.outFile.write(ddl_string_5 + ";\n")
                self.outFile.write(ddl_string_6 + ";\n")
                if not master_sec_admin_role.upper() == "NONE":
                    self.outFile.write(ddl_string_6a + ";\n")

                if not master_sys_admin_role.upper() == "NONE":
                    self.outFile.write(ddl_string_6b + ";\n")

                self.outFile.write("\n")
                self.outFile.write(ddl_string_7 + ";\n")
                self.outFile.write("\n")
                self.outFile.write(ddl_string_8 + ";\n")
                self.outFile.write(ddl_string_9 + ";\n")
                if mode.upper() == "PERMISSIVE":
                    self.outFile.write(ddl_string_10 + ";\n")
                    self.outFile.write(ddl_string_11 + ";\n")


            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create security roles for environment: " + sec_admin_role + " and " + sys_admin_role)
                self.executeDDL(ddl_string_1, False)
                self.executeDDL(ddl_string_2, False)
                self.executeDDL(ddl_string_3, False)
                self.executeDDL(ddl_string_4, False)
                self.executeDDL(ddl_string_5, False)
                self.executeDDL(ddl_string_6, False)
                self.executeDDL(ddl_string_7, False)
                self.executeDDL(ddl_string_8, False)
                self.executeDDL(ddl_string_9, False)
                if mode.upper() == "PERMISSIVE":
                    self.executeDDL(ddl_string_10, False)
                    self.executeDDL(ddl_string_11, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            error_string = format("Method: SFDBCalls.create_security_roles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(error_string)

    def revoke_manage_grants(self, sys_admin_role, sec_admin_role, environment, mode):
        try:

            ddl_string_1 = "   USE ROLE ACCOUNTADMIN"
            ddl_string_2 = "   REVOKE MANAGE GRANTS ON ACCOUNT FROM ROLE " + sys_admin_role


            if not self.outScript == "":
                self.outFile.write(ddl_string_1 + ";\n")
                self.outFile.write(ddl_string_2 + ";\n")


            if self.runDDL.upper() == "TRUE":
                self.executeDDL(ddl_string_1, False)
                self.executeDDL(ddl_string_2, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            error_string = format("Method: SFDBCalls.create_security_roles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(error_string)

    def grantsForEnvMaster(self, envMasterRole, sysAdminRole, secAdminRole, clause):
        try:
            ddlString1 = "USE ROLE SECURITYADMIN"
            ddlString2 = "GRANT ROLE " + secAdminRole + " TO ROLE " + envMasterRole
            ddlString3 = "GRANT ROLE " + sysAdminRole + " TO ROLE " + envMasterRole

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Issue Grants for env master                *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Issue Grants for env master")
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                self.executeDDL(ddlString3, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createSecAdminRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createUsageRole(self, secAdminRole, environment):
        try:
            ddlString1 = "USE ROLE " + secAdminRole
            ddlString2 = "CREATE ROLE " + environment + "_USAGE"

            # Also need to grant this role to the user that is running this script
            # ddlString5 = "GRANT ROLE " + roleToCreate + " TO USER " + self.execUser

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Create Usage role for environment          *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")


            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create usage " + environment + "_USAGE")
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createUsageRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createAccessRole(self, dbName, schema, access, sysAdminRole, secAdminRole, clause):
        try:
            roleToCreate = dbName + "_" + schema + "_" + access
            ddlString1 = "USE ROLE " + secAdminRole
            if clause.upper() == "IF NOT EXISTS":
                ddlString2 = "CREATE ROLE  IF NOT EXISTS " + roleToCreate
            elif clause.upper() == "OR REPLACE":
                ddlString2 = "CREATE " + clause + " ROLE  " + roleToCreate
            else:
                ddlString2 = "CREATE ROLE  " + roleToCreate

            ddlString3 = "USE ROLE " + sysAdminRole
            ddlString4 = "GRANT USAGE ON DATABASE " + dbName + " TO ROLE " + roleToCreate
            ddlString5 = "GRANT USAGE ON SCHEMA " + dbName + "." + schema + " TO ROLE " + roleToCreate

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Create access role                         *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")
                self.outFile.write(ddlString5 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)
                self.executeDDL(ddlString5, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createAccessRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createMissingAccessRole(self, accessRole, dbName, schema, access, sysAdminRole, secAdminRole, clause):
        try:

            ddlString1 = "USE ROLE " + secAdminRole
            if clause.upper() == "IF NOT EXISTS":
                ddlString2 = "CREATE ROLE  IF NOT EXISTS " + accessRole
            elif clause.upper() == "OR REPLACE":
                ddlString2 = "CREATE " + clause + " ROLE  " + accessRole
            else:
                ddlString2 = "CREATE ROLE  " + accessRole

            ddlString3 = "USE ROLE " + sysAdminRole
            ddlString4 = "GRANT USAGE ON DATABASE " + dbName + " TO ROLE " + accessRole
            ddlString5 = "GRANT USAGE ON SCHEMA " + dbName + "." + schema + " TO ROLE " + accessRole

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Create access role                         *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")
                self.outFile.write(ddlString5 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)
                self.executeDDL(ddlString5, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createAccessRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    #  ****************************************************************************************************************
    #  *                                                                                                              *
    #  *   WAREHOUSE-HANDLER                                                                                          *
    #  *                                                                                                              *
    #  ****************************************************************************************************************

    def createWarehouseAccessRole(self, dbName, schema, access, sysAdminRole, secAdminRole, clause):
        try:
            roleToCreate = dbName + "_" + schema + "_" + access
            ddlString1 = "USE ROLE " + secAdminRole
            if clause.upper() == "IF NOT EXISTS":
                ddlString2 = "CREATE ROLE  IF NOT EXISTS " + roleToCreate
            elif clause.upper() == "OR REPLACE":
                ddlString2 = "CREATE " + clause + " ROLE  " + roleToCreate
            else:
                ddlString2 = "CREATE ROLE  " + roleToCreate

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Create Warehouse access role               *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createWarehouseAccessRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createFunctionalRole(self, roleToCreate,  clause, sysAdminRole, secAdminRole):
        try:

            # CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ]
            if clause.strip().upper() == "OR REPLACE":
                ddlString = "CREATE " + clause + " ROLE " + roleToCreate
            if clause.strip().upper() == "IF NOT EXISTS":
                ddlString = "CREATE ROLE " + clause + " " + roleToCreate


            if not self.outScript == "":
                self.outFile.write(ddlString + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString, True)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createFunctionalRoles(self, roleToCreate, clause, sysAdminRole, secAdminRole):
        try:

            # Ignore roles ending dbName + SYSADMIN and dbName + SECADMIN as these are already created
            if roleToCreate.find(sysAdminRole) > -1 or roleToCreate.find(secAdminRole) > -1:
                return

            # CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ]
            if clause.strip().upper() == "OR REPLACE":
                ddlString = "   CREATE " + clause + " ROLE " + roleToCreate + ";"
            elif clause.strip().upper() == "IF NOT EXISTS":
                ddlString = "   CREATE ROLE " + clause + " " + roleToCreate + ";"
            else:
                ddlString = "   CREATE ROLE " + roleToCreate + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createFunctionalRoles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createDBFunctionalRoles(self, roleToCreate, clause, sysAdminRole, secAdminRole):
        try:

            # Ignore roles ending dbName + SYSADMIN and dbName + SECADMIN as these are already created
            if roleToCreate.find(sysAdminRole) > -1 or roleToCreate.find(secAdminRole) > -1:
                return

            # CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ]
            if clause.strip().upper() == "OR REPLACE":
                ddlString = "   CREATE " + clause + " ROLE " + roleToCreate + ";"
            elif clause.strip().upper() == "IF NOT EXISTS":
                ddlString = "   CREATE DATABASE ROLE " + clause + " " + roleToCreate + ";"
            else:
                ddlString = "   CREATE DATABASE ROLE " + roleToCreate + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createFunctionalRoles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def createAccessRoles(self, roleToCreate, clause, accessRolePrefix, accessRoleSuffix, roleType):
        try:
            if roleType != "ACCOUNT_ONLY":
                dbString = "DATABASE"
            else:
                dbString = ""

            if accessRoleSuffix == "NONE":
                suffixString = ""
            else:
                suffixString = accessRoleSuffix

            # CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ]
            if clause.strip().upper() == "OR REPLACE":
                ddlString = "   CREATE " + clause + dbString + " ROLE " + accessRolePrefix + roleToCreate + suffixString + ";"
            elif clause.strip().upper() == "IF NOT EXISTS":
                ddlString = "   CREATE " + dbString + " ROLE " + clause + " " + accessRolePrefix + roleToCreate + suffixString + ";"
            else:
                ddlString = "   CREATE " + dbString + " ROLE " + accessRolePrefix + roleToCreate + suffixString + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create " + dbString + " Role: " + accessRolePrefix + roleToCreate + suffixString )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createAccessRoles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)


    def createSuperRoles(self, roleToCreate):
        try:

            # CREATE ROLE IF NOT EXISTS
            ddlString = "   CREATE ROLE IF NOT EXISTS " + roleToCreate + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Create Role: " + roleToCreate)
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createSuperRoles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantOwnershipToSecAdminRole(self, roleToGrant, clause, secAdminRole, accessRolePrefix, accessRoleSuffix ):
        try:
            # Ignore SECADMIN
            if roleToGrant.find(secAdminRole) > -1:
                return

            #
            if clause.strip().upper() == "REVOKE CURRENT GRANTS":
                ddlString = "   GRANT OWNERSHIP ON ROLE " + accessRolePrefix + roleToGrant + accessRoleSuffix + " TO ROLE " + secAdminRole + " REVOKE CURRENT GRANTS;"
            elif clause.strip().upper() == "COPY CURRENT GRANTS":
                ddlString = "   GRANT OWNERSHIP ON ROLE " + accessRolePrefix + roleToGrant + accessRoleSuffix + " TO ROLE " + secAdminRole + " REVOKE CURRENT GRANTS;"
            else:
                ddlString = "   GRANT OWNERSHIP ON ROLE " + accessRolePrefix + roleToGrant + accessRoleSuffix +  " TO ROLE " + secAdminRole + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant ownership on role " + roleToGrant + " to role " + secAdminRole )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantOwnershipToSecAdminRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantRoleToRole(self, roleToGrantFrom, roleToGrantTo):
        try:

            ddlString = "   GRANT ROLE " + roleToGrantFrom + " TO ROLE " + roleToGrantTo + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + roleToGrantFrom + " to role " + roleToGrantTo )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantRoleToRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantDBRoleToRole(self, roleToGrantFrom, roleToGrantTo):
        try:

            ddlString = "   GRANT DATABASE ROLE " + roleToGrantFrom + " TO ROLE " + roleToGrantTo + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + roleToGrantFrom + " to role " + roleToGrantTo )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantRoleToRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_db_usage(self, environment, access_role):
        try:

            ddlString = "   GRANT USAGE ON DATABASE " + environment + " TO ROLE " + access_role + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("GRANT USAGE ON " + environment + " TO ROLE " + access_role )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grant_db_usage \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_db_usageToDBRole(self, environment, access_role):
        try:

            ddlString = "   GRANT USAGE ON DATABASE " + environment + " TO DATABASE ROLE " + access_role + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("GRANT USAGE ON " + environment + " TO ROLE " + access_role )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grant_db_usage \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantSelectedAccessRoleToFunctionalRole(self, schema, privilege, functional_role, accessRolePrefix, accessRoleSuffix ):
        try:

            ddlString = "   GRANT ROLE " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " TO ROLE " + functional_role + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " to role " + functional_role )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantSelectedAccessRoleToFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantSelectedDBAccessRoleToDBFunctionalRole(self, schema, privilege, functional_role, accessRolePrefix, accessRoleSuffix ):
        try:

            #ddlString = "   GRANT DATABASE ROLE " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " TO DATABASE ROLE " + functional_role + ";"
            ddlString = "   GRANT DATABASE ROLE " + accessRolePrefix + schema + privilege +  accessRoleSuffix  + " TO DATABASE ROLE " + functional_role + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " to role " + functional_role )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantSelectedAccessRoleToFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantSelectedDBAccessRoleToDBFunctionalRoleRestrictive(self, schema, privilege, functional_role, accessRolePrefix, accessRoleSuffix ):
        try:

            #ddlString = "   GRANT DATABASE ROLE " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " TO DATABASE ROLE " + functional_role + ";"
            ddlString = "   GRANT DATABASE ROLE " + accessRolePrefix + schema + "_" + privilege +  accessRoleSuffix  + " TO DATABASE ROLE " + functional_role + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " to role " + functional_role )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantSelectedAccessRoleToFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantSelectedDBAccessRoleToFunctionalRole(self, schema, privilege, functional_role, accessRolePrefix, accessRoleSuffix ):
        try:

            ddlString = "   GRANT DATABASE ROLE " +accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " to role " + functional_role + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + accessRolePrefix + schema + accessRoleSuffix + "_" + privilege + " to role " + functional_role )
                self.executeDDL(ddlString, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantSelectedAccessRoleToFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_functional_role_to_super_role(self, functional_role, super_role, grant_option):
        try:

            if (grant_option.upper() == "G") or (grant_option.upper() == "GRANT"):
                # grant functional role to super-role
                ddl_string = "   GRANT ROLE " + functional_role + " TO ROLE " + super_role + ";"
            elif (grant_option.upper() == "R") or (grant_option.upper() == "REVOKE"):
                # revoke functional role from super-role
                ddl_string = "   REVOKE ROLE " + functional_role + " FROM ROLE " + super_role + ";"
            else:
                return

            if not self.outScript == "":
                self.outFile.write(ddl_string + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant role " + functional_role + " TO ROLE " + super_role)
                self.executeDDL(ddl_string, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            error_string = format("Method: SFDBCalls.grant_functional_role_to_super_role \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(error_string)


    def grantFunctionalRoleToUser(self, environment, functional_role, user, grant_option, dict_grant_options):
        try:

            option = ""  # avoid an error when option not defined in loop
            ddl_string_option = ""

            # Obtain the correct grant option
            for grant in dict_grant_options:

                # Jump out of loop when found
                if grant.upper() == grant_option.upper():
                    option = dict_grant_options[grant]
                    break

            if option.upper() == "GRANT":
                ddl_string_option = "GRANT ROLE " + environment + "_" + functional_role + " TO USER " + user

            if option.upper() == "REVOKE":
                ddl_string_option = "REVOKE ROLE " + environment + "_" + functional_role + " FROM USER " + user

            if not self.outScript == "":
                self.outFile.write(ddl_string_option + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.executeDDL(ddl_string_option, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantFunctionalRoleToUser \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_functional_roles_to_user(self, functional_role, user, grant_option):
        try:

            if (grant_option.upper() == "G") or (grant_option.upper() == "GRANT"):
                # grant functional role to user
                ddl_string = "   GRANT ROLE " + functional_role + " TO USER " + user + ";"
            elif (grant_option.upper() == "R") or (grant_option.upper() == "REVOKE"):
                # revoke functional role from user
                ddl_string = "   REVOKE ROLE " + functional_role + " FROM USER " + user + ";"
            else:
                return

            if not self.outScript == "":
                self.outFile.write(ddl_string + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Grant or revoke role " + functional_role + " TO or FROM USER " + user)
                self.executeDDL(ddl_string, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            error_string = format(
                "Method: SFDBCalls.grant_functional_roles_to_user \n" + "Error No: " + str(sfExp.errno) + "\n" + str(
                    sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(error_string)


    def grantAccessRolePrivileges(self, dbName, schema, accessRole, dictSchemaPrivs, sysAdminRole):
        try:

            # obtain the correct access privilege
            for dictKey in dictSchemaPrivs:

                # Jump out of loop when found.
                if dictKey.upper() == accessRole.upper():
                    objectPrivileges = dictSchemaPrivs[dictKey]
                    break

            # Split the object privileges with delimiter ':'
            lstObjectPrivs = objectPrivileges.split(":")
            ddlString1 = "USE ROLE " + sysAdminRole

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Granting privileges to access role         *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Function: Granting privileges to access role")
                self.executeDDL(ddlString1, False)

            for privObject in lstObjectPrivs:
                privObject = privObject.upper()

                posOpnBracket = privObject.find("(")
                posCloseBracket = privObject.find(")")
                objectType = privObject[0:posOpnBracket]
                privString = privObject[posOpnBracket + 1: posCloseBracket]
                toRole = dbName + "_" + schema + "_" + accessRole

                if not objectType.upper() == "PIPE":
                    if objectType.upper() == "SCHEMA":
                        ddlString2 = "GRANT " + privString + " ON SCHEMA " + dbName + "." + schema + " TO ROLE " + toRole
                    else:
                        ddlString2 = "GRANT " + privString + " ON ALL " + objectType + " IN SCHEMA " + dbName + "." + schema + " TO ROLE " + toRole

                if (
                        (objectType.upper() == "TABLES") or
                        (objectType.upper() == "VIEWS") or
                        (objectType.upper() == "STAGES") or
                        (objectType.upper() == "FILE FORMATS") or
                        (objectType.upper() == "STREAMS") or
                        (objectType.upper() == "TASKS") or
                        (objectType.upper() == "SEQUENCES") or
                        (objectType.upper() == "FUNCTIONS") or
                        (objectType.upper() == "PROCEDURES")
                ):
                    ddlString3 = "GRANT " + privString + " ON FUTURE " + objectType + " IN SCHEMA " + dbName + "." + schema + " TO ROLE " + toRole
                else:
                    ddlString3 = ""

                if not self.outScript == "":
                    self.outFile.write(ddlString2 + ";\n")
                    if not ddlString3 == "":
                        self.outFile.write(ddlString3 + ";\n")

                if self.runDDL.upper() == "TRUE":
                    self.executeDDL(ddlString2, False)
                    if not ddlString3 == "":
                        self.executeDDL(ddlString3, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantAccessRolePrivileges \n" + "Method: SFDBCalls.createFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_access_role_privileges(self, object_name, access_role, grant_values, ownership_flag, future_flag, revoke_flag, accessRolePrefix, accessRoleSuffix):
        try:

            ddl_string = ""
            list_of_object_privileges = grant_values.split(":")

            for object_privileges in list_of_object_privileges:

                pos_left_bracket = object_privileges.find("(")
                pos_right_bracket = object_privileges.find(")")
                object = object_privileges[0:pos_left_bracket].upper()
                privileges = object_privileges[pos_left_bracket + 1: pos_right_bracket].upper()

                # no need to separate ownership from other privileges, but it looks tidier in the code
                if ((ownership_flag.upper() != "TRUE") and (privileges == "OWNERSHIP")) or ((ownership_flag.upper() == "TRUE") and (privileges != "OWNERSHIP")):
                    ddl_string = ""
                else:
                    if future_flag == "":
                        target_string = " ON ALL "
                    else:
                        target_string = " ON FUTURE "

                    if revoke_flag.upper() == "TRUE":
                        revoke_string = " REVOKE CURRENT GRANTS"
                    else:
                        revoke_string = ""

                    if object == "PIPE":                                        # not fully understood why pipes are special
                        ddl_string = "   GRANT OWNERSHIP ON " + object_name + " TO ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    elif object == "SCHEMA":
                        if future_flag == "":
                            ddl_string = "   GRANT " + privileges + " ON SCHEMA " + object_name + " TO ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    elif object == "WAREHOUSE":
                        ddl_string = "   GRANT " + privileges + " ON WAREHOUSE " + object_name + " TO ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    else:
                        ddl_string = "   GRANT " + privileges + target_string + object + " IN SCHEMA " + object_name + " TO ROLE " + accessRolePrefix + access_role + accessRoleSuffix  + revoke_string + ";"

                    if not self.outScript == "":
                        self.outFile.write(ddl_string + "\n")

                    if self.runDDL.upper() == "TRUE":
                        self.executeDDL(ddl_string, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grant_access_role_privileges \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_access_DBrole_privileges(self, object_name, access_role, grant_values, ownership_flag, future_flag, revoke_flag, accessRolePrefix, accessRoleSuffix):
        try:

            ddl_string = ""
            list_of_object_privileges = grant_values.split(":")

            for object_privileges in list_of_object_privileges:

                pos_left_bracket = object_privileges.find("(")
                pos_right_bracket = object_privileges.find(")")
                object = object_privileges[0:pos_left_bracket].upper()
                privileges = object_privileges[pos_left_bracket + 1: pos_right_bracket].upper()

                # no need to separate ownership from other privileges, but it looks tidier in the code
                if ((ownership_flag.upper() != "TRUE") and (privileges == "OWNERSHIP")) or ((ownership_flag.upper() == "TRUE") and (privileges != "OWNERSHIP")):
                    ddl_string = ""
                else:
                    if future_flag == "":
                        target_string = " ON ALL "
                    else:
                        target_string = " ON FUTURE "

                    if revoke_flag.upper() == "TRUE":
                        revoke_string = " REVOKE CURRENT GRANTS"
                    else:
                        revoke_string = ""

                    if object == "PIPE":                                        # not fully understood why pipes are special
                        ddl_string = "   GRANT OWNERSHIP ON " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    elif object == "SCHEMA":
                        if future_flag == "":
                            ddl_string = "   GRANT " + privileges + " ON SCHEMA " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    elif object == "WAREHOUSE":
                        ddl_string = "   GRANT " + privileges + " ON WAREHOUSE " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    else:
                        ddl_string = "   GRANT " + privileges + target_string + object + " IN SCHEMA " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix  + revoke_string + ";"

                    if not self.outScript == "":
                        self.outFile.write(ddl_string + "\n")

                    if self.runDDL.upper() == "TRUE":
                        self.executeDDL(ddl_string, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grant_access_role_privileges \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_permissive_access_role_privileges(self, object_name, access_role, grant_values, ownership_flag, future_flag, revoke_flag, accessRolePrefix, accessRoleSuffix):
        try:

            ddl_string = ""
            list_of_object_privileges = grant_values.split(":")

            for object_privileges in list_of_object_privileges:

                pos_left_bracket = object_privileges.find("(")
                pos_right_bracket = object_privileges.find(")")
                object = object_privileges[0:pos_left_bracket].upper()
                privileges = object_privileges[pos_left_bracket + 1: pos_right_bracket].upper()

                # no need to separate ownership from other privileges, but it looks tidier in the code
                if ((ownership_flag.upper() != "TRUE") and (privileges == "OWNERSHIP")) or ((ownership_flag.upper() == "TRUE") and (privileges != "OWNERSHIP")):
                    ddl_string = ""
                else:
                    if future_flag == "":
                        target_string = " ON ALL "
                    else:
                        target_string = " ON FUTURE "

                    if revoke_flag.upper() == "TRUE":
                        revoke_string = " REVOKE CURRENT GRANTS"
                    else:
                        revoke_string = ""

                    if object == "PIPE":                                        # not fully understood why pipes are special
                        ddl_string = "   GRANT OWNERSHIP ON " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    elif object == "SCHEMA":
                        ddl_string = "   GRANT " + privileges + " ON FUTURE SCHEMAS IN DATABASE  " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"


                    elif object == "WAREHOUSE":
                        ddl_string = "   GRANT " + privileges + " ON WAREHOUSE " + object_name + " TO ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    else:
                        ddl_string = "   GRANT " + privileges + target_string + object + " IN DATABASE " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix  + revoke_string + ";"

                    if not self.outScript == "":
                        self.outFile.write(ddl_string + "\n")

                    if self.runDDL.upper() == "TRUE":
                        self.executeDDL(ddl_string, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grant_access_role_privileges \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grant_permissive_access_db_role_privileges(self, object_name, access_role, grant_values, ownership_flag, future_flag, revoke_flag, accessRolePrefix, accessRoleSuffix):
        try:

            ddl_string = ""
            list_of_object_privileges = grant_values.split(":")

            for object_privileges in list_of_object_privileges:

                pos_left_bracket = object_privileges.find("(")
                pos_right_bracket = object_privileges.find(")")
                object = object_privileges[0:pos_left_bracket].upper()
                privileges = object_privileges[pos_left_bracket + 1: pos_right_bracket].upper()

                # no need to separate ownership from other privileges, but it looks tidier in the code
                if ((ownership_flag.upper() != "TRUE") and (privileges == "OWNERSHIP")) or ((ownership_flag.upper() == "TRUE") and (privileges != "OWNERSHIP")):
                    ddl_string = ""
                else:
                    if future_flag == "":
                        target_string = " ON ALL "
                    else:
                        target_string = " ON FUTURE "

                    if revoke_flag.upper() == "TRUE":
                        revoke_string = " REVOKE CURRENT GRANTS"
                    else:
                        revoke_string = ""

                    if object == "PIPE":                                        # not fully understood why pipes are special
                        ddl_string = "   GRANT OWNERSHIP ON " + object_name + " TO ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    elif object == "SCHEMA":
                        ddl_string = "   GRANT " + privileges + " ON FUTURE SCHEMAS IN DATABASE  " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"


                    elif object == "WAREHOUSE":
                        ddl_string = "   GRANT " + privileges + " ON WAREHOUSE " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix + ";"
                    else:
                        ddl_string = "   GRANT " + privileges + target_string + object + " IN DATABASE " + object_name + " TO DATABASE ROLE " + accessRolePrefix + access_role + accessRoleSuffix  + revoke_string + ";"

                    if not self.outScript == "":
                        self.outFile.write(ddl_string + "\n")

                    if self.runDDL.upper() == "TRUE":
                        self.executeDDL(ddl_string, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grant_access_db_role_privileges \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantWarehouseAccessRolePrivileges(self, dbName, warehouse, accessRole, dictSchemaPrivs, sysAdminRole):
        try:

            # obtain the correct access privilege
            for dictKey in dictSchemaPrivs:

                # Jump out of loop when found.
                if dictKey.upper() == accessRole.upper():
                    objectPrivileges = dictSchemaPrivs[dictKey]
                    break

            # Split the object privileges with delimiter ':'
            lstObjectPrivs = objectPrivileges.split(":")
            ddlString1 = "USE ROLE " + sysAdminRole
            #ddlString1 = "USE ROLE SECURITYADMIN";

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Granting privileges to access role         *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Function: Granting privileges to access role")
                self.executeDDL(ddlString1, False)

            for privObject in lstObjectPrivs:
                privObject = privObject.upper()

                posOpnBracket = privObject.find("(")
                posCloseBracket = privObject.find(")")
                objectType = privObject[0:posOpnBracket]
                privString = privObject[posOpnBracket + 1: posCloseBracket]
                toRole = dbName + "_" + warehouse + "_" + accessRole

                if not objectType == "PIPE":
                    ddlString2 = "GRANT " + privString + " ON " + objectType + " " + dbName + "_" + warehouse + " TO ROLE " + toRole + ";"

                if not self.outScript == "":
                    self.outFile.write(ddlString2 + "\n")

                if self.runDDL.upper() == "TRUE":
                    self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantWarehouseAccessRolePrivileges \n" + "Method: SFDBCalls.createFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def grantsForFunctionRole(self, dbName, schema, funcRole, accessRole, funcRoleFlag, roleToUse):

        try:
            if funcRoleFlag.upper() == "Y":
                ddlString1 = "USE ROLE " + roleToUse
                ddlString2 = "GRANT ROLE " + dbName + "_" + schema + "_" + accessRole + " TO ROLE " + dbName + "_" + funcRole

                if not self.outScript == "":
                    self.outFile.write("-- **********************************************\n")
                    self.outFile.write("-- * Granting access role to functional role    *\n")
                    self.outFile.write("-- **********************************************\n")
                    self.outFile.write(ddlString1 + ";\n")
                    self.outFile.write(ddlString2 + ";\n")

                if self.runDDL.upper() == "TRUE":
                    self.logger.info("Granting access role to functional role")
                    self.executeDDL(ddlString1, False)
                    self.executeDDL(ddlString2, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.grantsForFunctionRole \n" + "Method: SFDBCalls.createFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def dropAccessRole(self, dbName, schema, access, roleToUse, roleToDrop ):
        try:

            if not access == "N":
                roleToDrop = dbName + "_" + schema + "_" + access
                ddlString1 = "USE ROLE " + roleToUse
                ddlString2 = "DROP ROLE IF EXISTS " + roleToDrop

                if not self.outScript == "":
                    self.outFile.write("-- **********************************************\n")
                    self.outFile.write("-- * Drop access role                           *\n")
                    self.outFile.write("-- **********************************************\n")
                    self.outFile.write(ddlString1 + ";\n")
                    self.outFile.write(ddlString2 + ";\n")

                if self.runDDL.upper() == "TRUE":
                    self.logger.info("Drop Role: " + roleToDrop)
                    self.executeDDL(ddlString1, False)
                    self.executeDDL(ddlString2, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.dropAccessRoles \n" + "Error No: " + str(sfExp.errno) + "\n" + str(
            sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def dropFunctionalRole(self, roleToDrop, roleToUse):
        try:

            # Ignore roles ending SECADMIN or SYSADMIN. These roles must remain
            if roleToDrop.find("_SECADMIN") > -1 or roleToDrop.find("_SYSADMIN") > -1:
                return

            ddlString1 = "USE ROLE " + roleToUse
            ddlString2 = "DROP ROLE IF EXISTS " + roleToDrop

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Drop functional  role                      *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Drop Role: " + roleToDrop)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createFunctionalRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def dropSecAdminRole(self, secAdminRole):
        try:
            ddlString1 = "USE ROLE SECURITYADMIN"
            ddlString2 = "REVOKE CREATE  ROLE ON ACCOUNT FROM " + secAdminRole
            ddlString3 = "REVOKE MANAGE GRANTS  ON ACCOUNT FROM " + secAdminRole
            ddlString4 = "DROP ROLE " + secAdminRole

            # Also need to grant this role to the user that is running this script
            # ddlString5 = "GRANT ROLE " + roleToCreate + " TO USER " + self.execUser

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Drop security admin role for environment   *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")
                self.outFile.write(ddlString3 + ";\n")
                self.outFile.write(ddlString4 + ";\n")
                #self.outFile.write(ddlString5 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Drop Role: " + secAdminRole)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, True)
                self.executeDDL(ddlString3, False)
                self.executeDDL(ddlString4, False)
                #self.executeDDL(ddlString5, False)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Method: SFDBCalls.createSecAdminRole \n" + "Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))
            self.logger.error(errorString)

    def executeDDL(self, ddlString, ignoreError):
        try:
            sfCursor = self.dbConn.cursor().execute(ddlString)
            sfCursor.close()

        except snowflake.connector.errors.ProgrammingError as sfExp:
            errorString = format("Error No: " + str(sfExp.errno) + "\n" + str(sfExp.sqlstate) + "\n" + str(sfExp.msg))

            if ignoreError is True:
                return
            else:
                self.logger.error(errorString)
                self.logger.error("Failing DDL: " + ddlString)
                raise

    def UseDatabase(self, databaseToUse, sfUser):
        try:
            ddlString1 = "USE DATABASE " + databaseToUse

            self.outFile.write(ddlString1 + ";\n")
            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- Error: Database " + databaseToUse + " does not not exist or  cannot accessed by user: " + sfUser + "\n")
            self.outFile.write("-- Suggestion:  Always build the environment management roles "+ "\n")
            return False


    def tryUseRole(self, roleToUse, sfUser):
        try:
            ddlString1 = "USE ROLE " + roleToUse

            self.executeDDL(ddlString1, False)
            self.outFile.write("-- Info: Role " + roleToUse + " does exist and can be accessed by user: " + sfUser + "\n")
            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- Error: Role " + roleToUse + " does not not exist or  cannot accessed by user: " + sfUser + "\n")
            self.outFile.write("-- Suggestion:  Always build the environment management roles "+ "\n")
            return False

    def tryUseRoleWarehouse(self, roleToUse, warehouseToUse):
        try:
            ddlString1 = "USE ROLE " + roleToUse
            self.executeDDL(ddlString1, False)

            ddlString1 = "USE WAREHOUSE " + warehouseToUse
            self.executeDDL(ddlString1, False)
            self.outFile.write("-- Info: Role " + roleToUse + " has USAGE grant on warehouse " + warehouseToUse + "\n")
            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- Error: Role " + roleToUse + " requires USAGE grant on warehouse: " + warehouseToUse +  "\n")
            self.outFile.write("-- Suggestion:  Always build the environment management roles "+ "\n")
            return False

    def use_role(self, role_to_use):
        try:
            ddl_string = "USE ROLE " + role_to_use + ";"

            self.outFile.write(ddl_string + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Try USE ROLE " + role_to_use)
                self.executeDDL(ddl_string, False)

            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.logger.info("-- Error: Role " + role_to_use + " cannot be used.\n")
            return False

    def useUserAdminRole(self, sfUser):
        try:
            ddlString1 = "   USE ROLE USERADMIN;"

            if not self.outScript == "":
                self.outFile.write("\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Try to use role useradmin                  *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("\n")
                self.outFile.write(ddlString1 + "\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Try USE ROLE USERADMIN: ")
                self.executeDDL(ddlString1, False)

            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.logger.info("-- Error: Role USERADMIN cannot accessed by user: " + sfUser + "\n")
            return False

    def useSysAdminRole(self, sfUser):
        try:
            ddlString1 = "USE ROLE SYSADMIN;"

            if not self.outScript == "":
                self.outFile.write("\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Try to use role sysadmin                   *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("\n")
                self.outFile.write(ddlString1 + "\n")
                self.outFile.write("\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Try USE ROLE SYSADMIN: ")
                self.executeDDL(ddlString1, False)

            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.logger.info("-- Error: Role SYSADMIN cannot accessed by user: " + sfUser + "\n")
            return False

    def tryUseradminRole(self, sfUser):
        try:
            ddlString1 = "USE ROLE " + sfUser + ";"

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Try to use role " + sfUser + "  *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + "\n")
                self.outFile.write("\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Try USE ROLE USERADMIN: ")
                self.executeDDL(ddlString1, False)

            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.logger.info("-- Error: Role USERADMIN does not not exist or cannot accessed by user: " + sfUser + "\n")
            return False

    def trySecurityadminRole(self):
        try:
            ddlString1 = "USE ROLE SECURITYADMIN;"

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Try to use role SECURITYADMIN              *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + "\n")
                self.outFile.write("\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Try USE ROLE SECURITYADMIN: ")
                self.executeDDL(ddlString1, False)

            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.logger.info("-- Error: Role SECURITYADMIN cannot accessed by user.\n")
            return False

    def tryUseDB(self, dbName, sfUser):
        try:
            ddlString1 = "USE DATABASE " + dbName
            self.executeDDL(ddlString1, False)
            self.outFile.write("-- Info: Database " + dbName + " does exist and can be accessed by user: " + sfUser + "\n")
            return True

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- Error: Database " + dbName + " does not not exist or  cannot accessed by user: " + sfUser + "\n")
            self.outFile.write("-- Suggestion:  use sfBuild to create the environment " + "\n")
            return False

    def checkVWH(self, sfWarehouse):
        try:
            sqlString1 = "USE WAREHOUSE " + sfWarehouse
            self.executeDDL(sqlString1, False)

            self.outFile.write("-- Info: Warehouse " + sfWarehouse + " will be used.\n")

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to use warehouse : " + sfWarehouse + "\n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def checkDBOwner(self, roleToUse, dbName, shoudlBeRole):
        try:

            self.executeDDL("USE ROLE " + roleToUse, False)

            sqlString1 = "SHOW GRANTS ON DATABASE " + dbName
            self.executeDDL(sqlString1, False)

            dbOwner  = self.dbConn.cursor().execute("select \"grantee_name\" from table(result_scan(last_query_id())) where \"privilege\" = 'OWNERSHIP' ").fetchone()[0]

            if dbOwner.upper() == shoudlBeRole.upper():
                self.outFile.write("-- Info: Database " + dbName + " is owned by role: " + dbOwner  + "\n")
            else:
                self.outFile.write("-- Error: Database has wrong owner, " + dbOwner + "\n")
                self.outFile.write("-- Suggestion: " + "\n")
                self.outFile.write("USE ROLE SECURITYADMIN; \n")
                self.outFile.write("GRANT OWNERSHIP ON DATABASE " + dbName + " TO ROLE " + shoudlBeRole + ";" + "\n")

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to determine ownership of database: " + dbName + "\n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def checkDBRoleExists(self, dbName, shoudlBeRole, sfWarehouse):
        try:
            sqlString2 = "SHOW GRANTS ON DATABASE " + dbName
            sqlString3 = "select * from table(result_scan(last_query_id()))"
            self.executeDDL(sqlString2, False)

            dbOwner  = self.dbConn.cursor().execute("select \"grantee_name\" from table(result_scan(last_query_id())) where \"privilege\" = 'OWNERSHIP' ").fetchone()[0]

            if dbOwner.upper() == shoudlBeRole.upper():
                self.outFile.write("-- Info: Database " + dbName + " is owned by role: " + dbOwner  + "\n")
            else:
                self.outFile.write("-- Error: Database has wrong owner, " + dbOwner + "\n")
                self.outFile.write("-- Suggestion: " + "\n")
                self.outFile.write("USE ROLE SECURITYADMIN; \n")
                self.outFile.write("GRANT OWNERSHIP ON DATABASE " + dbName + " TO ROLE " + shoudlBeRole + ";" + "\n")

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to determine ownership of database: " + dbName + "\n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def checkRoleExists(self, roleName, shouldBeOwner, sfWarehouse):

        try:

            if roleName.startswith('_'):
                escRoleName = "\\\\" + roleName
                sqlString2 = "SHOW ROLES LIKE '" + escRoleName + "' "
            else :
                sqlString2 = "SHOW ROLES LIKE '" + roleName + "' "


            sqlString1 = "USE WAREHOUSE  " + sfWarehouse

            self.executeDDL(sqlString1, False)
            self.executeDDL(sqlString2, False)



            roleOwner = self.dbConn.cursor().execute(
                "select \"owner\" from table(result_scan(last_query_id())) where \"name\" = '" + roleName + "' ").fetchone()


            if roleOwner == None:
                self.outFile.write("-- Error: Access role " + roleName + " is defined in spreadsheet but does not exist in the DB" + "\n")
                return False
            else:
                roleOwner = roleOwner[0]
                if roleOwner.upper() == shouldBeOwner.upper():
                    self.outFile.write("-- Info: Access role " + roleName + " exists in DB and is owned by role: " + roleOwner  + "\n")
                    return True
                else:
                    self.outFile.write("-- Error: Access role " + roleName + "exists in DB but has wrong owner, " + roleOwner + "\n")
                    return True


        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Role: " + roleName + " does not exist in DB\n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")

    def checkGrantOnRole(self, roleName, grantedRole):

        try:

            if roleName.startswith('_'):
                escRoleName = "\\\\" + roleName
                sqlString1 = "SHOW GRANTS TO ROLE " + escRoleName
            else :
                sqlString1 = "SHOW GRANTS TO ROLE " + roleName


            self.executeDDL(sqlString1, False)


            grantCount = self.dbConn.cursor().execute(
                "select count(*) as rowCount from table(result_scan(last_query_id())) where \"name\" = '" + grantedRole + "' ").fetchone()[0]

            if grantCount > 0:
                self.outFile.write("-- Info: Access Role  " + grantedRole  + " has been granted to functional role " + roleName +  "\n")
                return True
            else:
                self.outFile.write("-- Error: Access Role  " + grantedRole  + " has not been granted to functional role " + roleName +  "\n")
                return False


        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Functional Role: " + roleName + " does not exist in DB\n")


    def getSchemas(self, dbName):
        try:
            sqlString1 = "SHOW SCHEMAS IN DATABASE  " + dbName
            sqlString2 = "Select \"created_on\" " + \
                        ", \"name\" " + \
                        ", \"owner\" " + \
                        ",\"retention_time\" "

            self.executeDDL(sqlString1, False)

            tplSchemas = self.dbConn.cursor().execute(sqlString2 + " from table(result_scan(last_query_id())) Where \"owner\" IS NOT NULL and \"name\" NOT IN ( 'INFORMATION_SCHEMA', 'PUBLIC')").fetchall()

            return tplSchemas

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to obtain list of schemas \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def getWarehouses(self, roleToUse, dbName):
        try:
            sqlString1 = "SHOW WAREHOUSES LIKE '" + dbName + "%'"
            sqlString2 = "Select \"name\" " + \
                        ", \"state\" " + \
                        ", \"type\" "

            self.executeDDL(sqlString1, False)

            tplWarehouses = self.dbConn.cursor().execute(sqlString2 + " from table(result_scan(last_query_id())) ").fetchall()

            return tplWarehouses

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to obtain list of virtual warehouses \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def getEnvRoles(self, roleToUse, dbName, owner):
        try:
            sqlString1 = "USE ROLE " + roleToUse
            sqlString2 = "SHOW ROLES LIKE '%" + dbName + "\\\\_%'"
            sqlString3 = "Select \"name\" " + \
                         ", \"owner\" "

            self.executeDDL(sqlString1, False)
            self.executeDDL(sqlString2, False)

            tplRoles = self.dbConn.cursor().execute(
                sqlString3 + " from table(result_scan(last_query_id())) ").fetchall()

            return tplRoles

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to obtain list of roles \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def dropRole(self, roleToUse, roleName):
        try:
            ddlString1 = "USE ROLE " + roleToUse
            ddlString2 = "DROP ROLE " + roleName

            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Drop Role                                  *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")
                self.outFile.write(ddlString2 + ";\n")

            if self.runDDL.upper() == "TRUE":
                self.logger.info("Drop Role: " + roleName)
                self.executeDDL(ddlString1, False)
                self.executeDDL(ddlString2, True)

        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable to drop role " + roleName + " \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def buildWarehouses(self, sysAdminRole, dbName, dictWarehouses):
        try:

            ddlString1 = "USE ROLE " + sysAdminRole
            if not self.outScript == "":
                self.outFile.write("-- **********************************************\n")
                self.outFile.write("-- * Create Warehouses                          *\n")
                self.outFile.write("-- **********************************************\n")
                self.outFile.write(ddlString1 + ";\n")


            if self.runDDL.upper() == "TRUE":
                self.logger.info("ddlString1")
                self.executeDDL(ddlString1, False)



            for row in dictWarehouses:
                whName = row
                whAttributes = dictWarehouses[row]
                ddlString2 = "CREATE WAREHOUSE " + whName + " WITH WAREHOUSE_TYPE = 'STANDARD' " + whAttributes

                if not self.outScript == "":
                    self.outFile.write(ddlString2 + ";\n")

                if self.runDDL.upper() == "TRUE":
                    self.executeDDL(ddlString2, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable create warehouse  " + dbName + "_" + whName + " \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def create_warehouse(self, warehouse_name, attributes):
        try:

            ddlString = "   CREATE WAREHOUSE IF NOT EXISTS " + warehouse_name + " WITH WAREHOUSE_TYPE = 'STANDARD' " + attributes + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.executeDDL(ddlString, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable create warehouse  " + warehouse_name + " \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise

    def createSDRRole(self, roleName):
        try:

            ddlString = "   CREATE ROLE IF NOT EXISTS " + roleName + ";"

            if not self.outScript == "":
                self.outFile.write(ddlString + "\n")

            if self.runDDL.upper() == "TRUE":
                self.executeDDL(ddlString, False)


        except snowflake.connector.errors.ProgrammingError as sfExp:
            self.outFile.write("-- ERROR: Unable create SDR Role   " + roleName + " \n")
            self.outFile.write("-- ERROR: " + sfExp.msg + "\n")
            raise
    def isNaN(self, num):
        return num != num
