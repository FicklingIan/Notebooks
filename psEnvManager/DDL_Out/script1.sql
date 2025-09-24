
-- ***********************************************************************************************************
-- * Date           : 2025-05-19                                                                             *
-- * Time           : 07:50                                                                                  *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/EDU_Examples_ArchClass.xlsx *
-- * Environment(s) : PROD_EDW_LAB                                                                           *
-- ***********************************************************************************************************


-- +------------------------------------------------------------------------------------------------------+
-- | Create the security roles for PROD_SYSADMIN and PROD_SECADMIN                                        |
-- +------------------------------------------------------------------------------------------------------+

   USE ROLE USERADMIN;

   CREATE ROLE IF NOT EXISTS PROD_SECADMIN;
   CREATE ROLE IF NOT EXISTS PROD_SYSADMIN;

   GRANT CREATE ROLE ON ACCOUNT TO PROD_SECADMIN;
   GRANT ROLE PROD_SECADMIN TO ROLE USERADMIN;
   GRANT ROLE PROD_SYSADMIN TO ROLE SYSADMIN;

   USE ROLE SYSADMIN;

   GRANT CREATE DATABASE ON ACCOUNT TO PROD_SYSADMIN;
   GRANT CREATE WAREHOUSE ON ACCOUNT TO PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role PROD_SYSADMIN                                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create database PROD                                                                                 |
-- +------------------------------------------------------------------------------------------------------+

   CREATE DATABASE IF NOT EXISTS PROD DATA_RETENTION_TIME_IN_DAYS = 1;
USE DATABASE PROD;

-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role PROD_SECADMIN                                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create Account Level functional roles                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE ROLE IF NOT EXISTS PROD_ELT_SVC;
   CREATE ROLE IF NOT EXISTS PROD_ANALYST;
   CREATE ROLE IF NOT EXISTS PROD_DATA_SCI;

-- +------------------------------------------------------------------------------------------------------+
-- | Create access roles, Restrictive DB Only Access Roles                                                |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SYSADMIN;
USE DATABASE PROD;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_RO;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_RW;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_SFULL;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_RO;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_RW;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_SFULL;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_RO;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_RW;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_SFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the SDR Roles                                                                                 |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;
   CREATE ROLE IF NOT EXISTS _SDR_HIGHLY_CONFIDENTAL;
   CREATE ROLE IF NOT EXISTS _SDR_CONFIDENTIAL;
   CREATE ROLE IF NOT EXISTS _SDR_AFRICA;
   CREATE ROLE IF NOT EXISTS _SDR_ASIA;
   CREATE ROLE IF NOT EXISTS _SDR_EUROPE;
   CREATE ROLE IF NOT EXISTS _SDR_MIDDLE_EAST;
   CREATE ROLE IF NOT EXISTS _SDR_ALL_REGIONS;

-- +------------------------------------------------------------------------------------------------------+
-- | Create warehouse access roles                                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;
   CREATE  ROLE IF NOT EXISTS _PROD_ELT_WH_WU;
   CREATE  ROLE IF NOT EXISTS _PROD_ELT_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS _PROD_ELT_WH_ALL;
   CREATE  ROLE IF NOT EXISTS _PROD_ANALYST_WH_WU;
   CREATE  ROLE IF NOT EXISTS _PROD_ANALYST_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS _PROD_ANALYST_WH_ALL;
   CREATE  ROLE IF NOT EXISTS _PROD_DATA_SCI_WH_WU;
   CREATE  ROLE IF NOT EXISTS _PROD_DATA_SCI_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS _PROD_DATA_SCI_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on warehouse access roles to PROD_SECADMIN                                           |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON ROLE _PROD_ELT_WH_WU TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_ELT_WH_WFULL TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_ELT_WH_ALL TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_ANALYST_WH_WU TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_ANALYST_WH_WFULL TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_ANALYST_WH_ALL TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_DATA_SCI_WH_WU TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_DATA_SCI_WH_WFULL TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_DATA_SCI_WH_ALL TO ROLE PROD_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create Super-Roles  (ownership stays with USERADMIN)                                                 |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Grant super-roles to users                                                                           |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role PROD_SECADMIN                                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant account level functional roles to PROD_SYSADMIN                                                |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE PROD_ELT_SVC TO ROLE PROD_SYSADMIN;
   GRANT ROLE PROD_ANALYST TO ROLE PROD_SYSADMIN;
   GRANT ROLE PROD_DATA_SCI TO ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant access roles to PROD_SYSADMIN                                                                  |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _RAW_RO TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _RAW_RW TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _RAW_SFULL TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _EDW_RO TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _EDW_RW TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _EDW_SFULL TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _MART_RO TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _MART_RW TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE _MART_SFULL TO ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant access roles to functional roles                                                               |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE _RAW_RW to role PROD_ELT_SVC;
   GRANT DATABASE ROLE _RAW_RW to role PROD_DATA_SCI;
   GRANT DATABASE ROLE _EDW_RW to role PROD_ELT_SVC;
   GRANT DATABASE ROLE _EDW_RO to role PROD_ANALYST;
   GRANT DATABASE ROLE _EDW_RO to role PROD_DATA_SCI;
   GRANT DATABASE ROLE _MART_RW to role PROD_ELT_SVC;
   GRANT DATABASE ROLE _MART_RO to role PROD_ANALYST;
   GRANT DATABASE ROLE _MART_RO to role PROD_DATA_SCI;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant warehouse access roles to PROD_SYSADMIN                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;
   GRANT ROLE _PROD_ELT_WH_WU TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_ELT_WH_WFULL TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_ELT_WH_ALL TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_ANALYST_WH_WU TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_ANALYST_WH_WFULL TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_ANALYST_WH_ALL TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_DATA_SCI_WH_WU TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_DATA_SCI_WH_WFULL TO ROLE PROD_SYSADMIN;
   GRANT ROLE _PROD_DATA_SCI_WH_ALL TO ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant virtual warehouse access roles to functional roles                                             |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE _PROD_ELT_WH_WU TO ROLE PROD_ELT_SVC;
   GRANT ROLE _PROD_ANALYST_WH_WU TO ROLE PROD_ANALYST;
   GRANT ROLE _PROD_DATA_SCI_WH_WU TO ROLE PROD_DATA_SCI;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant functional roles to super-roles                                                                |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Grant functional roles to users                                                                      |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role PROD_SYSADMIN                                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant db usage to access roles                                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _RAW_SFULL;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _EDW_SFULL;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON DATABASE PROD TO DATABASE ROLE _MART_SFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the warehouses                                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE WAREHOUSE IF NOT EXISTS PROD_ELT_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='SMALL', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;
   CREATE WAREHOUSE IF NOT EXISTS PROD_ANALYST_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='SMALL', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;
   CREATE WAREHOUSE IF NOT EXISTS PROD_DATA_SCI_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='medium', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant privileges on warehouses to access roles                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON WAREHOUSE PROD_ELT_WH TO ROLE _PROD_ELT_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE PROD_ELT_WH TO ROLE _PROD_ELT_WH_WFULL;
   GRANT ALL ON WAREHOUSE PROD_ELT_WH TO ROLE _PROD_ELT_WH_ALL;
   GRANT USAGE ON WAREHOUSE PROD_ANALYST_WH TO ROLE _PROD_ANALYST_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE PROD_ANALYST_WH TO ROLE _PROD_ANALYST_WH_WFULL;
   GRANT ALL ON WAREHOUSE PROD_ANALYST_WH TO ROLE _PROD_ANALYST_WH_ALL;
   GRANT USAGE ON WAREHOUSE PROD_DATA_SCI_WH TO ROLE _PROD_DATA_SCI_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE PROD_DATA_SCI_WH TO ROLE _PROD_DATA_SCI_WH_WFULL;
   GRANT ALL ON WAREHOUSE PROD_DATA_SCI_WH TO ROLE _PROD_DATA_SCI_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the schemas                                                                                   |
-- +------------------------------------------------------------------------------------------------------+

   CREATE SCHEMA IF NOT EXISTS PROD.RAW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS PROD.EDW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS PROD.MART WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on objects to access roles                                                           |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON ALL TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL TASKS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL SEQUENCES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL TASKS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL SEQUENCES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL TABLES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STAGES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL TASKS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL SEQUENCES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL REVOKE CURRENT GRANTS;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant future ownership on objects to access roles                                                    |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Grant privileges on objects to access roles                                                          |
-- +------------------------------------------------------------------------------------------------------+

   GRANT SELECT ON ALL TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT SELECT ON ALL TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT SELECT ON ALL TABLES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON SCHEMA MART TO DATABASE ROLE _MART_SFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant future privileges on objects to access roles                                                   |
-- +------------------------------------------------------------------------------------------------------+

   GRANT SELECT ON FUTURE TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_RO;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SFULL;
   GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_RO;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SFULL;
   GRANT SELECT ON FUTURE TABLES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_RO;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Build of PROD complete - have a nice day                                                             |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Thanks for using RBAC Automation Manager                                                             |
-- +------------------------------------------------------------------------------------------------------+

