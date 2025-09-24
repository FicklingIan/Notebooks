
-- *************************************************************************************************
-- * Date           : 2023-10-27                                                                   *
-- * Time           : 10:16                                                                        *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/EDU_Examples.xlsx *
-- * Environment(s) :                                                                              *
-- *************************************************************************************************

-- **********************************************
-- * Try to use role   *
-- **********************************************
USE ROLE ;

CREATE USER IF NOT EXISTS SF_ELT_DEV PASSWORD = 'TABL_BATCH1' LOGIN_NAME = 'SF_ELT_DEV' DISPLAY_NAME = 'SF_ELT_DEV' DISABLED = False MUST_CHANGE_PASSWORD = True DEFAULT_WAREHOUSE = 'DEV_WH_BATCH_LOAD' DEFAULT_ROLE = 'TRAINING_ROLE' ;
CREATE USER IF NOT EXISTS SF_ANALYST PASSWORD = 'PW123456789!' LOGIN_NAME = 'SF_ANALYST' DISPLAY_NAME = 'SF_ANALYST' DISABLED = False MUST_CHANGE_PASSWORD = True DEFAULT_WAREHOUSE = 'DEV_WH_BATCH_LOAD' DEFAULT_ROLE = 'TRAINING_ROLE' ;
CREATE USER IF NOT EXISTS SF_DATA_SCIENTIST PASSWORD = 'PW123456789!' LOGIN_NAME = 'SF_DATA_SCIENTIST' DISPLAY_NAME = 'SF_DATA_SCIENTIST' DISABLED = False MUST_CHANGE_PASSWORD = True DEFAULT_WAREHOUSE = 'DEV_WH_BATCH_LOAD' DEFAULT_ROLE = 'TRAINING_ROLE' ;
CREATE USER IF NOT EXISTS SF_DATA_GOVERANCE PASSWORD = 'PW123456789!' LOGIN_NAME = 'SF_DATA_GOVERANCE' DISPLAY_NAME = 'SF_DATA_GOVERANCE' DISABLED = False MUST_CHANGE_PASSWORD = True DEFAULT_WAREHOUSE = 'DEV_WH_BATCH_LOAD' DEFAULT_ROLE = 'TRAINING_ROLE' ;

-- ###########################################################################
-- ## Grant or revoke functional roles to / from users                      ##
-- ###########################################################################


-- ###########################################################################
-- ## PROD_EDW                                                              ##
-- ###########################################################################

-- **********************************************
-- * Try to use role SECURITYADMIN              *
-- **********************************************
USE ROLE SECURITYADMIN;

GRANT ROLE PROD_EDW_ETL_DEV TO USER SF_ELT_DEV;
GRANT ROLE PROD_EDW_ANALYST TO USER SF_ANALYST;
GRANT ROLE PROD_EDW_DATA_SCI TO USER SF_DATA_SCIENTIST;
GRANT ROLE PROD_EDW_POLICY_ADMIN TO USER SF_DATA_GOVERANCE;
