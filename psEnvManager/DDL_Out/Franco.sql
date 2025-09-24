
-- *******************************************************************************************
-- * Date           : 2024-02-09                                                             *
-- * Time           : 09:12                                                                  *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/Franco.xlsx *
-- * Environment(s) : EDW_PRD                                                                *
-- *******************************************************************************************


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
   USE ROLE ACCOUNTADMIN;
   GRANT MANAGE GRANTS ON ACCOUNT TO ROLE PROD_SYSADMIN;

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

   CREATE ROLE IF NOT EXISTS PROD_ETL_DEV_F;
   CREATE ROLE IF NOT EXISTS PROD_ANALYST_F;
   CREATE ROLE IF NOT EXISTS PROD_DATA_SCI_F;
   CREATE ROLE IF NOT EXISTS PROD_POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | Create access roles, Permissive DB Only Access Roles                                                 |
-- +------------------------------------------------------------------------------------------------------+

   CREATE DATABASE ROLE IF NOT EXISTS __DR;
   CREATE DATABASE ROLE IF NOT EXISTS __DW;
   CREATE DATABASE ROLE IF NOT EXISTS __DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the SDR Roles                                                                                 |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;
   CREATE ROLE IF NOT EXISTS _SDR_HIGHLY_CONFIDENTAL;
   CREATE ROLE IF NOT EXISTS _SDR_CONFIDENTIAL;
   CREATE ROLE IF NOT EXISTS _SDR_INTERNAL;
   CREATE ROLE IF NOT EXISTS _SDR_USA;
   CREATE ROLE IF NOT EXISTS _SDR_EMEA;
   CREATE ROLE IF NOT EXISTS _SDR_APAC;
   CREATE ROLE IF NOT EXISTS _SDR_GLOBAL_RESULTS;

-- +------------------------------------------------------------------------------------------------------+
-- | Create warehouse access roles                                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;
   CREATE  ROLE IF NOT EXISTS __PROD_ADHOC_WH_WU;
   CREATE  ROLE IF NOT EXISTS __PROD_ADHOC_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS __PROD_ADHOC_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on warehouse access roles to PROD_SECADMIN                                           |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON ROLE __PROD_ADHOC_WH_WU TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE __PROD_ADHOC_WH_WFULL TO ROLE PROD_SECADMIN;
   GRANT OWNERSHIP ON ROLE __PROD_ADHOC_WH_ALL TO ROLE PROD_SECADMIN;

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

   GRANT ROLE PROD_ETL_DEV_F TO ROLE PROD_SYSADMIN;
   GRANT ROLE PROD_ANALYST_F TO ROLE PROD_SYSADMIN;
   GRANT ROLE PROD_DATA_SCI_F TO ROLE PROD_SYSADMIN;
   GRANT ROLE PROD_POLICY_ADMIN_F TO ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant database functional roles to PROD_SYSADMIN                                                     |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SYSADMIN;
USE DATABASE PROD;
   GRANT DATABASE ROLE ETL_DEV_F TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE ANALYST_F TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE DATA_SCI_F TO ROLE PROD_SYSADMIN;
   GRANT DATABASE ROLE POLICY_ADMIN_F TO ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant database functional roles to account level functional roles                                    |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE ETL_DEV_F TO ROLE PROD_ETL_DEV_F;
   GRANT DATABASE ROLE ANALYST_F TO ROLE PROD_ANALYST_F;
   GRANT DATABASE ROLE DATA_SCI_F TO ROLE PROD_DATA_SCI_F;
   GRANT DATABASE ROLE POLICY_ADMIN_F TO ROLE PROD_POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | ... Permissive. Grant access roles to PROD_SYSADMIN                                                  |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE __ TO ROLE PROD_PROD_SYSADMIN;
   GRANT DATABASE ROLE __ TO ROLE PROD_PROD_SYSADMIN;
   GRANT DATABASE ROLE __ TO ROLE PROD_PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | ... Permissive. Grant DB level access roles to functional roles                                      |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE __PROD_DFULL TO ROLE ETL_DEV_F;
   GRANT DATABASE ROLE __PROD_DR TO ROLE ANALYST_F;
   GRANT DATABASE ROLE __PROD_DR TO ROLE DATA_SCI_F;
   GRANT DATABASE ROLE __PROD_DW TO ROLE POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant warehouse access roles to PROD_SYSADMIN                                                        |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE PROD_SECADMIN;
   GRANT ROLE __PROD_ADHOC_WH_WU TO ROLE PROD_SYSADMIN;
   GRANT ROLE __PROD_ADHOC_WH_WFULL TO ROLE PROD_SYSADMIN;
   GRANT ROLE __PROD_ADHOC_WH_ALL TO ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant virtual warehouse access roles to functional roles                                             |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE __PROD_ADHOC_WH_WU TO ROLE PROD_ETL_DEV_F;
   GRANT ROLE __PROD_ADHOC_WH_WU TO ROLE PROD_ANALYST_F;
   GRANT ROLE __PROD_ADHOC_WH_WU TO ROLE PROD_DATA_SCI_F;
   GRANT ROLE __PROD_ADHOC_WH_WU TO ROLE PROD_POLICY_ADMIN_F;

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
-- | ... Permissive. Grant db usage to access roles                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON DATABASE PROD TO ROLE __PROD_DR;
   GRANT USAGE ON DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE ON DATABASE PROD TO ROLE __PROD_DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | ...Permissive. Grant DB Level privileges  for DB: PROD                                               |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON FUTURE SCHEMAS IN DATABASE  PROD TO ROLE __PROD_DR;
   GRANT SELECT ON FUTURE TABLES IN DATABASE PROD TO ROLE __PROD_DR;
   GRANT USAGE,READ ON FUTURE STAGES IN DATABASE PROD TO ROLE __PROD_DR;
   GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE PROD TO ROLE __PROD_DR;
   GRANT SELECT ON FUTURE STREAMS IN DATABASE PROD TO ROLE __PROD_DR;
   GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE PROD TO ROLE __PROD_DR;
   GRANT USAGE ON FUTURE PROCEDURES IN DATABASE PROD TO ROLE __PROD_DR;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT SELECT ON FUTURE VIEWS IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT SELECT ON FUTURE STREAMS IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE ON FUTURE SEQUENCES IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE ON FUTURE PROCEDURES IN DATABASE PROD TO ROLE __PROD_DW;
   GRANT USAGE ON FUTURE SCHEMAS IN DATABASE  PROD TO ROLE __PROD_DW;
   GRANT ALL ON FUTURE TABLES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE VIEWS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE STAGES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE STREAMS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE SEQUENCES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE PROCEDURES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT ALL ON FUTURE SCHEMAS IN DATABASE  PROD TO ROLE __PROD_DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the warehouses                                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE WAREHOUSE IF NOT EXISTS PROD_ADHOC_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='xsmall', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant privileges on warehouses to access roles                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON WAREHOUSE PROD_ADHOC_WH TO ROLE __PROD_ADHOC_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE PROD_ADHOC_WH TO ROLE __PROD_ADHOC_WH_WFULL;
   GRANT ALL ON WAREHOUSE PROD_ADHOC_WH TO ROLE __PROD_ADHOC_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the schemas                                                                                   |
-- +------------------------------------------------------------------------------------------------------+

   CREATE SCHEMA IF NOT EXISTS PROD.RAW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS PROD.EDW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS PROD.MART WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS PROD.GOVERN WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on objects to access roles                                                           |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | ...Permissive. Grant future ownership on objects to access roles                                     |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON FUTURE TABLES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE VIEWS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE STAGES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE FILE FORMATS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE STREAMS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE TASKS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE SEQUENCES IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE FUNCTIONS IN DATABASE PROD TO ROLE __PROD_DFULL;
   GRANT OWNERSHIP ON FUTURE PROCEDURES IN DATABASE PROD TO ROLE __PROD_DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant privileges on objects to access roles                                                          |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Grant future privileges on objects to access roles                                                   |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Revoke Manage grants                                                                                 |
-- +------------------------------------------------------------------------------------------------------+

   USE ROLE ACCOUNTADMIN;
   REVOKE MANAGE GRANTS ON ACCOUNT FROM ROLE PROD_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Build of PROD complete - have a nice day                                                             |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Thanks for using RBAC Automation Manager                                                             |
-- +------------------------------------------------------------------------------------------------------+

