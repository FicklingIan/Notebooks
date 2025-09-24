
-- ************************************************************************************************
-- * Date           : 2023-04-05                                                                  *
-- * Time           : 14:41                                                                       *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/RBAC_Sanofi.xlsx *
-- * Environment(s) : DEV                                                                         *
-- ************************************************************************************************


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the security roles for DEV_SYSADMIN and DEV_SECADMIN                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   USE ROLE USERADMIN;

   CREATE ROLE IF NOT EXISTS DEV_SECADMIN;
   CREATE ROLE IF NOT EXISTS ;
   CREATE ROLE IF NOT EXISTS DEV_SYSADMIN;
   CREATE ROLE IF NOT EXISTS ;

   GRANT CREATE ROLE ON ACCOUNT TO DEV_SECADMIN;
   GRANT ROLE DEV_SECADMIN TO ROLE USERADMIN;
   GRANT ROLE DEV_SYSADMIN TO ROLE SYSADMIN;
   GRANT ROLE DEV_SECADMIN TO ROLE ;
   GRANT ROLE DEV_SYSADMIN TO ROLE ;

   USE ROLE SYSADMIN;

   GRANT CREATE DATABASE ON ACCOUNT TO DEV_SYSADMIN;
   GRANT CREATE WAREHOUSE ON ACCOUNT TO DEV_SYSADMIN;
   USE ROLE ACCOUNTADMIN;
   GRANT MANAGE GRANTS ON ACCOUNT TO ROLE DEV_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role USERADMIN                                                                            ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE USERADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create functional roles                                                                              ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS DEV_DEVELOPER;
   CREATE ROLE IF NOT EXISTS DEV_KEY_DEVELOPER;
   CREATE ROLE IF NOT EXISTS DEV_PLATFORM_MGR;
   CREATE ROLE IF NOT EXISTS DEV_ADMIN;
   CREATE ROLE IF NOT EXISTS DEV_SUPPORT;
   CREATE ROLE IF NOT EXISTS DEV_ETL_PROC;
   CREATE ROLE IF NOT EXISTS DEV_BI_PROC;
   CREATE ROLE IF NOT EXISTS DEV_DS_PROC_2;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on functional roles to DEV_SECADMIN                                                  ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE DEV_DEVELOPER TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_KEY_DEVELOPER TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_PLATFORM_MGR TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_ADMIN TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_SUPPORT TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_ETL_PROC TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_BI_PROC TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE DEV_DS_PROC_2 TO ROLE DEV_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create access roles, Permissive DB Only Access Roles                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS _DEV_DR;
   CREATE ROLE IF NOT EXISTS _DEV_DW;
   CREATE ROLE IF NOT EXISTS _DEV_DFULL;
   CREATE ROLE IF NOT EXISTS _DEV_TECH_TMP_SR;
   CREATE ROLE IF NOT EXISTS _DEV_TECH_TMP_SW;
   CREATE ROLE IF NOT EXISTS _DEV_TECH_TMP_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ... Permissive: Grant ownership on access roles to DEV_SECADMIN                                      ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE _DEV_DR TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_DW TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_DFULL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_TECH_TMP_SR TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_TECH_TMP_SW TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create warehouse access roles                                                                        ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS _DEV_WH_ADHOC_WU;
   CREATE ROLE IF NOT EXISTS _DEV_WH_ADHOC_WFULL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_ADHOC_ALL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_ETL_WU;
   CREATE ROLE IF NOT EXISTS _DEV_WH_ETL_WFULL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_ETL_ALL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_BI_WU;
   CREATE ROLE IF NOT EXISTS _DEV_WH_BI_WFULL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_BI_ALL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_LABS_WU;
   CREATE ROLE IF NOT EXISTS _DEV_WH_LABS_WFULL;
   CREATE ROLE IF NOT EXISTS _DEV_WH_LABS_ALL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on warehouse access roles to DEV_SECADMIN                                            ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE _DEV_WH_ADHOC_WU TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_ADHOC_WFULL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_ADHOC_ALL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_ETL_WU TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_ETL_WFULL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_ETL_ALL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_BI_WU TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_BI_WFULL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_BI_ALL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_LABS_WU TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_LABS_WFULL TO ROLE DEV_SECADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_WH_LABS_ALL TO ROLE DEV_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create Super-Roles  (ownership stays with USERADMIN)                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS SUPER_CONTROL;
   CREATE ROLE IF NOT EXISTS SUPER_ETL;
   CREATE ROLE IF NOT EXISTS SUPER_READER;
   CREATE ROLE IF NOT EXISTS SUPER_WRITER;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant super-roles to users                                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE SUPER_READER TO USER USER001;
   GRANT ROLE SUPER_READER TO USER USER002;
   GRANT ROLE SUPER_CONTROL TO USER PRD_ADMIN;
   GRANT ROLE SUPER_READER TO USER PRD_ADMIN;
   GRANT ROLE SUPER_WRITER TO USER PRD_ADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role DEV_SECADMIN                                                                         ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE DEV_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to DEV_SYSADMIN                                                               ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE DEV_DEVELOPER TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_KEY_DEVELOPER TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_PLATFORM_MGR TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_ADMIN TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_SUPPORT TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_ETL_PROC TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_BI_PROC TO ROLE DEV_SYSADMIN;
   GRANT ROLE DEV_DS_PROC_2 TO ROLE DEV_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ... Permissive. Grant access roles to DEV_SYSADMIN                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_DR TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_DW TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_DFULL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_TECH_TMP_SR TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_TECH_TMP_SW TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ... Permissive. Grant DB level access roles to functional roles                                      ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_DW TO ROLE DEV_DEVELOPER;
   GRANT ROLE _DEV_DFULL TO ROLE DEV_KEY_DEVELOPER;
   GRANT ROLE _DEV_DFULL TO ROLE DEV_PLATFORM_MGR;
   GRANT ROLE _DEV_DFULL TO ROLE DEV_ADMIN;
   GRANT ROLE _DEV_DW TO ROLE DEV_SUPPORT;
   GRANT ROLE _DEV_DW TO ROLE DEV_ETL_PROC;
   GRANT ROLE _DEV_DR TO ROLE DEV_BI_PROC;
   GRANT ROLE _DEV_DR TO ROLE DEV_DS_PROC_2;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_DEVELOPER;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_KEY_DEVELOPER;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_PLATFORM_MGR;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_ADMIN;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_SUPPORT;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_ETL_PROC;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_BI_PROC;
   GRANT ROLE _DEV_TECH_TMP_SFULL TO ROLE DEV_DS_PROC_2;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant warehouse access roles to DEV_SYSADMIN                                                         ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_WH_ADHOC_WU TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_ADHOC_WFULL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_ADHOC_ALL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_ETL_WU TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_ETL_WFULL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_ETL_ALL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_BI_WU TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_BI_WFULL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_BI_ALL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_LABS_WU TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_LABS_WFULL TO ROLE DEV_SYSADMIN;
   GRANT ROLE _DEV_WH_LABS_ALL TO ROLE DEV_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant virtual warehouse access roles to functional roles                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_WH_ADHOC_WU TO ROLE DEV_DEVELOPER;
   GRANT ROLE _DEV_WH_ADHOC_WU TO ROLE DEV_KEY_DEVELOPER;
   GRANT ROLE _DEV_WH_ADHOC_WU TO ROLE DEV_PLATFORM_MGR;
   GRANT ROLE _DEV_WH_ADHOC_WFULL TO ROLE DEV_ADMIN;
   GRANT ROLE _DEV_WH_ADHOC_WU TO ROLE DEV_SUPPORT;
   GRANT ROLE _DEV_WH_ETL_WFULL TO ROLE DEV_ADMIN;
   GRANT ROLE _DEV_WH_ETL_WU TO ROLE DEV_ETL_PROC;
   GRANT ROLE _DEV_WH_BI_WFULL TO ROLE DEV_ADMIN;
   GRANT ROLE _DEV_WH_BI_WU TO ROLE DEV_BI_PROC;
   GRANT ROLE _DEV_WH_LABS_WFULL TO ROLE DEV_ADMIN;
   GRANT ROLE _DEV_WH_LABS_WU TO ROLE DEV_DS_PROC_2;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to super-roles                                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE DEV_ADMIN TO ROLE SUPER_READER;
   GRANT ROLE DEV_ADMIN TO ROLE SUPER_WRITER;
   GRANT ROLE DEV_ADMIN TO ROLE SUPER_CONTROL;
   GRANT ROLE DEV_KEY_DEVELOPER TO ROLE SUPER_ETL;
   GRANT ROLE DEV_PLATFORM_MGR TO ROLE SUPER_ETL;
   GRANT ROLE DEV_ADMIN TO ROLE SUPER_ETL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to users                                                                      ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE DEV_ADMIN TO USER USER001;
   GRANT ROLE DEV_KEY_DEVELOPER TO USER USER002;
   GRANT ROLE DEV_ADMIN TO USER PRD_ADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role DEV_SYSADMIN                                                                         ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE DEV_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create database DEV                                                                                  ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE DATABASE IF NOT EXISTS DEV DATA_RETENTION_TIME_IN_DAYS = 1 DEFAULT_DDL_COLLATION = '''' ;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ... Permissive. Grant db usage to access roles                                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON DATABASE DEV TO ROLE _DEV_DR;
   GRANT USAGE ON DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE ON DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT USAGE ON DATABASE DEV TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON DATABASE DEV TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON DATABASE DEV TO ROLE _DEV_TECH_TMP_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ...Permissive. Grant DB Level privileges  for DB: DEV                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON FUTURE SCHEMAS IN DATABASE  DEV TO ROLE _DEV_DR;
   GRANT SELECT ON FUTURE TABLES IN DATABASE DEV TO ROLE _DEV_DR;
   GRANT USAGE,READ ON FUTURE STAGES IN DATABASE DEV TO ROLE _DEV_DR;
   GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE DEV TO ROLE _DEV_DR;
   GRANT SELECT ON FUTURE STREAMS IN DATABASE DEV TO ROLE _DEV_DR;
   GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE DEV TO ROLE _DEV_DR;
   GRANT USAGE ON FUTURE PROCEDURES IN DATABASE DEV TO ROLE _DEV_DR;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT SELECT ON FUTURE VIEWS IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT SELECT ON FUTURE STREAMS IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE ON FUTURE SEQUENCES IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE ON FUTURE PROCEDURES IN DATABASE DEV TO ROLE _DEV_DW;
   GRANT USAGE ON FUTURE SCHEMAS IN DATABASE  DEV TO ROLE _DEV_DW;
   GRANT ALL ON FUTURE TABLES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE VIEWS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE STAGES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE STREAMS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE SEQUENCES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE PROCEDURES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT ALL ON FUTURE SCHEMAS IN DATABASE  DEV TO ROLE _DEV_DFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the warehouses                                                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE WAREHOUSE IF NOT EXISTS DEV_WH_ADHOC WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='small', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=600,auto_resume=true;
   CREATE WAREHOUSE IF NOT EXISTS DEV_WH_ETL WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='small', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=600,auto_resume=true;
   CREATE WAREHOUSE IF NOT EXISTS DEV_WH_BI WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='small', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=600,auto_resume=true;
   CREATE WAREHOUSE IF NOT EXISTS DEV_WH_LABS WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='small', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=600,auto_resume=true;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant privileges on warehouses to access roles                                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON WAREHOUSE DEV_WH_ADHOC TO ROLE _DEV_WH_ADHOC_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE DEV_WH_ADHOC TO ROLE _DEV_WH_ADHOC_WFULL;
   GRANT ALL ON WAREHOUSE DEV_WH_ADHOC TO ROLE _DEV_WH_ADHOC_ALL;
   GRANT USAGE ON WAREHOUSE DEV_WH_ETL TO ROLE _DEV_WH_ETL_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE DEV_WH_ETL TO ROLE _DEV_WH_ETL_WFULL;
   GRANT ALL ON WAREHOUSE DEV_WH_ETL TO ROLE _DEV_WH_ETL_ALL;
   GRANT USAGE ON WAREHOUSE DEV_WH_BI TO ROLE _DEV_WH_BI_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE DEV_WH_BI TO ROLE _DEV_WH_BI_WFULL;
   GRANT ALL ON WAREHOUSE DEV_WH_BI TO ROLE _DEV_WH_BI_ALL;
   GRANT USAGE ON WAREHOUSE DEV_WH_LABS TO ROLE _DEV_WH_LABS_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE DEV_WH_LABS TO ROLE _DEV_WH_LABS_WFULL;
   GRANT ALL ON WAREHOUSE DEV_WH_LABS TO ROLE _DEV_WH_LABS_ALL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the schemas                                                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE SCHEMA IF NOT EXISTS DEV.STA WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV.PSA WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV.RSV WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV.DWH WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV.DMT WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV.TECH WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV.TECH_TMP WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on objects to access roles                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ALL TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL TASKS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL SEQUENCES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;
   GRANT OWNERSHIP ON ALL PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL REVOKE CURRENT GRANTS;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ...Permissive. Grant future ownership on objects to access roles                                     ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON FUTURE TABLES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE VIEWS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE STAGES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE FILE FORMATS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE STREAMS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE TASKS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE SEQUENCES IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE FUNCTIONS IN DATABASE DEV TO ROLE _DEV_DFULL;
   GRANT OWNERSHIP ON FUTURE PROCEDURES IN DATABASE DEV TO ROLE _DEV_DFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant privileges on objects to access roles                                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT SELECT ON ALL TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT SELECT ON ALL VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT SELECT ON ALL STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT ALL ON ALL TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant future privileges on objects to access roles                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT SELECT ON FUTURE TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SR;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA TECH_TMP TO ROLE _DEV_TECH_TMP_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Revoke Manage grants                                                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   USE ROLE ACCOUNTADMIN;
   REVOKE MANAGE GRANTS ON ACCOUNT FROM ROLE DEV_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Build of DEV complete - have a nice day                                                              ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Thanks for using RBAC Automation Manager                                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

