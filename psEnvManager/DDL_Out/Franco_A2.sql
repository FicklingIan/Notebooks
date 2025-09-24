
-- *******************************************************************************************
-- * Date           : 2024-02-12                                                             *
-- * Time           : 09:49                                                                  *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/Franco.xlsx *
-- * Environment(s) : EDW_PRD                                                                *
-- *******************************************************************************************


-- +------------------------------------------------------------------------------------------------------+
-- | Create the security roles for DBRV3_SYSADMIN and DBRV3_SECADMIN                                      |
-- +------------------------------------------------------------------------------------------------------+

   USE ROLE USERADMIN;

   CREATE ROLE IF NOT EXISTS DBRV3_SECADMIN;
   CREATE ROLE IF NOT EXISTS DBRV3_SYSADMIN;

   GRANT CREATE ROLE ON ACCOUNT TO DBRV3_SECADMIN;
   GRANT ROLE DBRV3_SECADMIN TO ROLE USERADMIN;
   GRANT ROLE DBRV3_SYSADMIN TO ROLE SYSADMIN;

   USE ROLE SYSADMIN;

   GRANT CREATE DATABASE ON ACCOUNT TO DBRV3_SYSADMIN;
   GRANT CREATE WAREHOUSE ON ACCOUNT TO DBRV3_SYSADMIN;
   USE ROLE ACCOUNTADMIN;
   GRANT MANAGE GRANTS ON ACCOUNT TO ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role DBRV3_SYSADMIN                                                                       |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create database DBRV3                                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE DATABASE IF NOT EXISTS DBRV3 DATA_RETENTION_TIME_IN_DAYS = 1;
USE DATABASE DBRV3;

-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role DBRV3_SECADMIN                                                                       |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create Account Level functional roles                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE ROLE IF NOT EXISTS DBRV3_ETL_DEV_F;
   CREATE ROLE IF NOT EXISTS DBRV3_ANALYST_F;
   CREATE ROLE IF NOT EXISTS DBRV3_DATA_SCI_F;
   CREATE ROLE IF NOT EXISTS DBRV3_POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | Create Database Level functional roles                                                               |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;
USE DATABASE DBRV3;
   CREATE DATABASE ROLE IF NOT EXISTS ETL_DEV_F;
   CREATE DATABASE ROLE IF NOT EXISTS ANALYST_F;
   CREATE DATABASE ROLE IF NOT EXISTS DATA_SCI_F;
   CREATE DATABASE ROLE IF NOT EXISTS POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | Create access roles, Permissive DB Only Access Roles                                                 |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;
USE DATABASE DBRV3;
   CREATE DATABASE ROLE IF NOT EXISTS __DR;
   CREATE DATABASE ROLE IF NOT EXISTS __DW;
   CREATE DATABASE ROLE IF NOT EXISTS __DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the SDR Roles                                                                                 |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SECADMIN;
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

USE ROLE DBRV3_SECADMIN;
   CREATE  ROLE IF NOT EXISTS __DBRV3_ADHOC_WH_WU;
   CREATE  ROLE IF NOT EXISTS __DBRV3_ADHOC_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS __DBRV3_ADHOC_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on warehouse access roles to DBRV3_SECADMIN                                          |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON ROLE __DBRV3_ADHOC_WH_WU TO ROLE DBRV3_SECADMIN;
   GRANT OWNERSHIP ON ROLE __DBRV3_ADHOC_WH_WFULL TO ROLE DBRV3_SECADMIN;
   GRANT OWNERSHIP ON ROLE __DBRV3_ADHOC_WH_ALL TO ROLE DBRV3_SECADMIN;

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
-- | Try to use role DBRV3_SECADMIN                                                                       |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant account level functional roles to DBRV3_SYSADMIN                                               |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE DBRV3_ETL_DEV_F TO ROLE DBRV3_SYSADMIN;
   GRANT ROLE DBRV3_ANALYST_F TO ROLE DBRV3_SYSADMIN;
   GRANT ROLE DBRV3_DATA_SCI_F TO ROLE DBRV3_SYSADMIN;
   GRANT ROLE DBRV3_POLICY_ADMIN_F TO ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant database functional roles to DBRV3_SYSADMIN                                                    |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;
USE DATABASE DBRV3;
   GRANT DATABASE ROLE ETL_DEV_F TO ROLE DBRV3_SYSADMIN;
   GRANT DATABASE ROLE ANALYST_F TO ROLE DBRV3_SYSADMIN;
   GRANT DATABASE ROLE DATA_SCI_F TO ROLE DBRV3_SYSADMIN;
   GRANT DATABASE ROLE POLICY_ADMIN_F TO ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant database functional roles to account level functional roles                                    |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE ETL_DEV_F TO ROLE DBRV3_ETL_DEV_F;
   GRANT DATABASE ROLE ANALYST_F TO ROLE DBRV3_ANALYST_F;
   GRANT DATABASE ROLE DATA_SCI_F TO ROLE DBRV3_DATA_SCI_F;
   GRANT DATABASE ROLE POLICY_ADMIN_F TO ROLE DBRV3_POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | ... Permissive. Grant access roles to DBRV3_SYSADMIN                                                 |
-- +------------------------------------------------------------------------------------------------------+

-- ... For Permissive with DB Access roles, there is no grant of DB access role to DBRV3_SYSADMIN

-- +------------------------------------------------------------------------------------------------------+
-- | ... Permissive. Grant DB level access roles to functional roles                                      |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;
USE DATABASE DBRV3;
   GRANT DATABASE ROLE __DFULL TO DATABASE ROLE ETL_DEV_F;
   GRANT DATABASE ROLE __DR TO DATABASE ROLE ANALYST_F;
   GRANT DATABASE ROLE __DR TO DATABASE ROLE DATA_SCI_F;
   GRANT DATABASE ROLE __DW TO DATABASE ROLE POLICY_ADMIN_F;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant warehouse access roles to DBRV3_SYSADMIN                                                       |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SECADMIN;
   GRANT ROLE __DBRV3_ADHOC_WH_WU TO ROLE DBRV3_SYSADMIN;
   GRANT ROLE __DBRV3_ADHOC_WH_WFULL TO ROLE DBRV3_SYSADMIN;
   GRANT ROLE __DBRV3_ADHOC_WH_ALL TO ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant virtual warehouse access roles to functional roles                                             |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE __DBRV3_ADHOC_WH_WU TO ROLE DBRV3_ETL_DEV_F;
   GRANT ROLE __DBRV3_ADHOC_WH_WU TO ROLE DBRV3_ANALYST_F;
   GRANT ROLE __DBRV3_ADHOC_WH_WU TO ROLE DBRV3_DATA_SCI_F;
   GRANT ROLE __DBRV3_ADHOC_WH_WU TO ROLE DBRV3_POLICY_ADMIN_F;

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
-- | Try to use role DBRV3_SYSADMIN                                                                       |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | ... Permissive. Grant db usage to access roles                                                       |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE DBRV3_SYSADMIN;
   GRANT USAGE ON DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT USAGE ON DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE ON DATABASE DBRV3 TO DATABASE ROLE __DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | ...Permissive. Grant DB Level privileges  for DB: DBRV3                                              |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON FUTURE SCHEMAS IN DATABASE  DBRV3 TO DATABASE ROLE __DR;
   GRANT SELECT ON FUTURE TABLES IN DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT USAGE,READ ON FUTURE STAGES IN DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT SELECT ON FUTURE STREAMS IN DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT USAGE ON FUTURE PROCEDURES IN DATABASE DBRV3 TO DATABASE ROLE __DR;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT SELECT ON FUTURE VIEWS IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT SELECT ON FUTURE STREAMS IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE ON FUTURE SEQUENCES IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE ON FUTURE PROCEDURES IN DATABASE DBRV3 TO DATABASE ROLE __DW;
   GRANT USAGE ON FUTURE SCHEMAS IN DATABASE  DBRV3 TO DATABASE ROLE __DW;
   GRANT ALL ON FUTURE TABLES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE VIEWS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE STAGES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE STREAMS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE SEQUENCES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE PROCEDURES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT ALL ON FUTURE SCHEMAS IN DATABASE  DBRV3 TO DATABASE ROLE __DFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the warehouses                                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE WAREHOUSE IF NOT EXISTS DBRV3_ADHOC_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='xsmall', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant privileges on warehouses to access roles                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON WAREHOUSE DBRV3_ADHOC_WH TO ROLE __DBRV3_ADHOC_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE DBRV3_ADHOC_WH TO ROLE __DBRV3_ADHOC_WH_WFULL;
   GRANT ALL ON WAREHOUSE DBRV3_ADHOC_WH TO ROLE __DBRV3_ADHOC_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the schemas                                                                                   |
-- +------------------------------------------------------------------------------------------------------+

   CREATE SCHEMA IF NOT EXISTS DBRV3.RAW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DBRV3.EDW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DBRV3.MART WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DBRV3.GOVERN WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on objects to access roles                                                           |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | ...Permissive. Grant future ownership on objects to access roles                                     |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON FUTURE TABLES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE VIEWS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE STAGES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE FILE FORMATS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE STREAMS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE TASKS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE SEQUENCES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE FUNCTIONS IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;
   GRANT OWNERSHIP ON FUTURE PROCEDURES IN DATABASE DBRV3 TO DATABASE ROLE __DFULL;

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
   REVOKE MANAGE GRANTS ON ACCOUNT FROM ROLE DBRV3_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Build of DBRV3 complete - have a nice day                                                            |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Thanks for using RBAC Automation Manager                                                             |
-- +------------------------------------------------------------------------------------------------------+

