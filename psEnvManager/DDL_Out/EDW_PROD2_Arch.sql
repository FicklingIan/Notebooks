
-- ***********************************************************************************************************
-- * Date           : 2023-11-17                                                                             *
-- * Time           : 17:17                                                                                  *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/EDU_Examples_ArchClass.xlsx *
-- * Environment(s) : PROD_EDW_LAB                                                                           *
-- ***********************************************************************************************************


-- +------------------------------------------------------------------------------------------------------+
-- | Create the security roles for [LOGIN]_PROD2_SYSADMIN and [LOGIN]_PROD2_SECADMIN                      |
-- +------------------------------------------------------------------------------------------------------+

   USE ROLE USERADMIN;

   CREATE ROLE IF NOT EXISTS [LOGIN]_PROD2_SECADMIN;
   CREATE ROLE IF NOT EXISTS [LOGIN]_PROD2_SYSADMIN;

   GRANT CREATE ROLE ON ACCOUNT TO [LOGIN]_PROD2_SECADMIN;
   GRANT ROLE [LOGIN]_PROD2_SECADMIN TO ROLE USERADMIN;
   GRANT ROLE [LOGIN]_PROD2_SYSADMIN TO ROLE SYSADMIN;

   USE ROLE SYSADMIN;

   GRANT CREATE DATABASE ON ACCOUNT TO [LOGIN]_PROD2_SYSADMIN;
   GRANT CREATE WAREHOUSE ON ACCOUNT TO [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role [LOGIN]_PROD2_SYSADMIN                                                               |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create database [login]_PROD2                                                                        |
-- +------------------------------------------------------------------------------------------------------+

   CREATE DATABASE IF NOT EXISTS [login]_PROD2 DATA_RETENTION_TIME_IN_DAYS = 1;
USE DATABASE [login]_PROD2;

-- +------------------------------------------------------------------------------------------------------+
-- | |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Try to use role [LOGIN]_PROD2_SECADMIN                                                               |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Create Account Level functional roles                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE ROLE IF NOT EXISTS [login]_PROD2_ELT_DEV;
   CREATE ROLE IF NOT EXISTS [login]_PROD2_ANALYST;

-- +------------------------------------------------------------------------------------------------------+
-- | Create access roles, Restrictive DB Only Access Roles                                                |
-- +------------------------------------------------------------------------------------------------------+

USE DATABASE [login]_PROD2;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_RO;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_SU;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_RW;
   CREATE DATABASE ROLE IF NOT EXISTS _RAW_SFULL;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_RO;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_SU;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_RW;
   CREATE DATABASE ROLE IF NOT EXISTS _EDW_SFULL;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_RO;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_SU;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_RW;
   CREATE DATABASE ROLE IF NOT EXISTS _MART_SFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the SDR Roles                                                                                 |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SECADMIN;
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

USE ROLE [LOGIN]_PROD2_SECADMIN;
   CREATE  ROLE IF NOT EXISTS _[login]_PROD2_ELT_WH_WU;
   CREATE  ROLE IF NOT EXISTS _[login]_PROD2_ELT_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS _[login]_PROD2_ELT_WH_ALL;
   CREATE  ROLE IF NOT EXISTS _[login]_PROD2_ANALYST_WH_WU;
   CREATE  ROLE IF NOT EXISTS _[login]_PROD2_ANALYST_WH_WFULL;
   CREATE  ROLE IF NOT EXISTS _[login]_PROD2_ANALYST_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant ownership on warehouse access roles to [LOGIN]_PROD2_SECADMIN                                  |
-- +------------------------------------------------------------------------------------------------------+

   GRANT OWNERSHIP ON ROLE _[login]_PROD2_ELT_WH_WU TO ROLE [LOGIN]_PROD2_SECADMIN;
   GRANT OWNERSHIP ON ROLE _[login]_PROD2_ELT_WH_WFULL TO ROLE [LOGIN]_PROD2_SECADMIN;
   GRANT OWNERSHIP ON ROLE _[login]_PROD2_ELT_WH_ALL TO ROLE [LOGIN]_PROD2_SECADMIN;
   GRANT OWNERSHIP ON ROLE _[login]_PROD2_ANALYST_WH_WU TO ROLE [LOGIN]_PROD2_SECADMIN;
   GRANT OWNERSHIP ON ROLE _[login]_PROD2_ANALYST_WH_WFULL TO ROLE [LOGIN]_PROD2_SECADMIN;
   GRANT OWNERSHIP ON ROLE _[login]_PROD2_ANALYST_WH_ALL TO ROLE [LOGIN]_PROD2_SECADMIN;

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
-- | Try to use role [LOGIN]_PROD2_SECADMIN                                                               |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SECADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant account level functional roles to [LOGIN]_PROD2_SYSADMIN                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE [login]_PROD2_ELT_DEV TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT ROLE [login]_PROD2_ANALYST TO ROLE [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant database functional roles to [LOGIN]_PROD2_SYSADMIN                                            |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SYSADMIN;
USE DATABASE [login]_PROD2;
   GRANT DATABASE ROLE ELT_DEV TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE ANALYST TO ROLE [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant database functional roles to account level functional roles                                    |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE ELT_DEV TO ROLE [login]_PROD2_ELT_DEV;
   GRANT DATABASE ROLE ANALYST TO ROLE [login]_PROD2_ANALYST;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant access roles to [LOGIN]_PROD2_SYSADMIN                                                         |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE _RAW_RO TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _RAW_SU TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _RAW_RW TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _RAW_SFULL TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _EDW_RO TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _EDW_SU TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _EDW_RW TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _EDW_SFULL TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _MART_RO TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _MART_SU TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _MART_RW TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT DATABASE ROLE _MART_SFULL TO ROLE [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant access roles to functional roles                                                               |
-- +------------------------------------------------------------------------------------------------------+

   GRANT DATABASE ROLE _RAW_RW TO ROLE [login]_PROD2_ELT_DEV;
   GRANT DATABASE ROLE _EDW_RW TO ROLE [login]_PROD2_ELT_DEV;
   GRANT DATABASE ROLE _EDW_RO TO ROLE [login]_PROD2_ANALYST;
   GRANT DATABASE ROLE _MART_RW TO ROLE [login]_PROD2_ELT_DEV;
   GRANT DATABASE ROLE _MART_RO TO ROLE [login]_PROD2_ANALYST;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant warehouse access roles to [LOGIN]_PROD2_SYSADMIN                                               |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SECADMIN;
   GRANT ROLE _[login]_PROD2_ELT_WH_WU TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT ROLE _[login]_PROD2_ELT_WH_WFULL TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT ROLE _[login]_PROD2_ELT_WH_ALL TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT ROLE _[login]_PROD2_ANALYST_WH_WU TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT ROLE _[login]_PROD2_ANALYST_WH_WFULL TO ROLE [LOGIN]_PROD2_SYSADMIN;
   GRANT ROLE _[login]_PROD2_ANALYST_WH_ALL TO ROLE [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant virtual warehouse access roles to functional roles                                             |
-- +------------------------------------------------------------------------------------------------------+

   GRANT ROLE _[login]_PROD2_ELT_WH_WU TO ROLE [login]_PROD2_ELT_DEV;
   GRANT ROLE _[login]_PROD2_ANALYST_WH_WU TO ROLE [login]_PROD2_ANALYST;

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
-- | Try to use role [LOGIN]_PROD2_SYSADMIN                                                               |
-- +------------------------------------------------------------------------------------------------------+

USE ROLE [LOGIN]_PROD2_SYSADMIN;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant db usage to access roles                                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _RAW_RO;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _RAW_SU;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _RAW_RW;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _RAW_SFULL;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _EDW_RO;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _EDW_SU;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _EDW_RW;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _EDW_SFULL;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _MART_RO;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _MART_SU;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _MART_RW;
   GRANT USAGE ON DATABASE [login]_PROD2 TO DATABASE ROLE _MART_SFULL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the warehouses                                                                                |
-- +------------------------------------------------------------------------------------------------------+

   CREATE WAREHOUSE IF NOT EXISTS [login]_PROD2_ELT_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='xsmall', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;
   CREATE WAREHOUSE IF NOT EXISTS [login]_PROD2_ANALYST_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='medium', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;

-- +------------------------------------------------------------------------------------------------------+
-- | Grant privileges on warehouses to access roles                                                       |
-- +------------------------------------------------------------------------------------------------------+

   GRANT USAGE ON WAREHOUSE [login]_PROD2_ELT_WH TO ROLE _[login]_PROD2_ELT_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE [login]_PROD2_ELT_WH TO ROLE _[login]_PROD2_ELT_WH_WFULL;
   GRANT ALL ON WAREHOUSE [login]_PROD2_ELT_WH TO ROLE _[login]_PROD2_ELT_WH_ALL;
   GRANT USAGE ON WAREHOUSE [login]_PROD2_ANALYST_WH TO ROLE _[login]_PROD2_ANALYST_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE [login]_PROD2_ANALYST_WH TO ROLE _[login]_PROD2_ANALYST_WH_WFULL;
   GRANT ALL ON WAREHOUSE [login]_PROD2_ANALYST_WH TO ROLE _[login]_PROD2_ANALYST_WH_ALL;

-- +------------------------------------------------------------------------------------------------------+
-- | Create the schemas                                                                                   |
-- +------------------------------------------------------------------------------------------------------+

   CREATE SCHEMA IF NOT EXISTS [login]_PROD2.RAW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS [login]_PROD2.EDW WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS [login]_PROD2.MART WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

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
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SU;
   GRANT USAGE ON SCHEMA RAW TO DATABASE ROLE _RAW_SU;
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
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SU;
   GRANT USAGE ON SCHEMA EDW TO DATABASE ROLE _EDW_SU;
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
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SU;
   GRANT USAGE ON SCHEMA MART TO DATABASE ROLE _MART_SU;
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
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA RAW TO DATABASE ROLE _RAW_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA RAW TO DATABASE ROLE _RAW_SU;
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
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA EDW TO DATABASE ROLE _EDW_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA EDW TO DATABASE ROLE _EDW_SU;
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
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA MART TO DATABASE ROLE _MART_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA MART TO DATABASE ROLE _MART_SU;
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
-- | Build of [login]_PROD2 complete - have a nice day                                                    |
-- +------------------------------------------------------------------------------------------------------+


-- +------------------------------------------------------------------------------------------------------+
-- | Thanks for using RBAC Automation Manager                                                             |
-- +------------------------------------------------------------------------------------------------------+

