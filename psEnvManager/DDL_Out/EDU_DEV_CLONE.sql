
-- *************************************************************************************************
-- * Date           : 2023-04-12                                                                   *
-- * Time           : 13:50                                                                        *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/EDU_Examples.xlsx *
-- * Environment(s) : DEV_EDU                                                                      *
-- *************************************************************************************************


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the security roles for DEV_EDU_SYSADMIN and DEV_EDU_USERADMIN                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   USE ROLE USERADMIN;

   CREATE ROLE IF NOT EXISTS DEV_EDU_USERADMIN;
   CREATE ROLE IF NOT EXISTS DEV_EDU_SYSADMIN;

   GRANT CREATE ROLE ON ACCOUNT TO DEV_EDU_USERADMIN;
   GRANT ROLE DEV_EDU_USERADMIN TO ROLE USERADMIN;
   GRANT ROLE DEV_EDU_SYSADMIN TO ROLE SYSADMIN;

   USE ROLE SYSADMIN;

   GRANT CREATE DATABASE ON ACCOUNT TO DEV_EDU_SYSADMIN;
   GRANT CREATE WAREHOUSE ON ACCOUNT TO DEV_EDU_SYSADMIN;
-- *************************
-- * Clone Database        *
-- *************************
USE ROLE PROD_EDU_SYSADMIN;
CREATE  DATABASE IF NOT EXISTS DEV_EDU CLONE PROD_EDU;
-- ********************************************
-- * Granting Ownership on DB to Role         *
-- * Granting Ownership on all schemas in DB  *
-- *******************************************
GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE  DEV_EDU TO ROLE DEV_EDU_SYSADMIN REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON DATABASE DEV_EDU TO ROLE DEV_EDU_SYSADMIN;
-- ***********************************
-- * Granting Ownership on schemas   *
-- ***********************************
USE ROLE DEV_EDU_SYSADMIN;
GRANT OWNERSHIP ON ALL TABLES IN SCHEMA DEV_EDU.SALES TO ROLE DEV_EDU_SYSADMIN REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON ALL TABLES IN SCHEMA DEV_EDU.INVENTGORY TO ROLE DEV_EDU_SYSADMIN REVOKE CURRENT GRANTS;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ██████████████████████████████████████████ Switch role... ██████████████████████████████████████████ ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role USERADMIN                                                                            ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE USERADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create functional roles                                                                              ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS DEV_EDU_DEVELOPER;
   CREATE ROLE IF NOT EXISTS DEV_EDU_Analyst;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on functional roles to DEV_EDU_USERADMIN                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE DEV_EDU_DEVELOPER TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE DEV_EDU_Analyst TO ROLE DEV_EDU_USERADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create access roles, Permissive DB Only Access Roles                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create access roles, Restrictive DB Only Access Roles                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS _DEV_EDU_SALES_RO;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_SALES_SU;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_SALES_RW;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_SALES_SFULL;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_INVENTGORY_RO;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_INVENTGORY_SU;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_INVENTGORY_RW;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_INVENTGORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on schema access roles to DEV_EDU_USERADMIN                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE _DEV_EDU_SALES_RO TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_SALES_SU TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_SALES_RW TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_SALES_SFULL TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_INVENTGORY_RO TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_INVENTGORY_SU TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_INVENTGORY_RW TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_INVENTGORY_SFULL TO ROLE DEV_EDU_USERADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create warehouse access roles                                                                        ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS _DEV_EDU_ADHOC_WH_WU;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_ADHOC_WH_WFULL;
   CREATE ROLE IF NOT EXISTS _DEV_EDU_ADHOC_WH_ALL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on warehouse access roles to DEV_EDU_USERADMIN                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE _DEV_EDU_ADHOC_WH_WU TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_ADHOC_WH_WFULL TO ROLE DEV_EDU_USERADMIN;
   GRANT OWNERSHIP ON ROLE _DEV_EDU_ADHOC_WH_ALL TO ROLE DEV_EDU_USERADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create Super-Roles  (ownership stays with USERADMIN)                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant super-roles to users                                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ██████████████████████████████████████████ Switch role... ██████████████████████████████████████████ ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role DEV_EDU_USERADMIN                                                                    ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE DEV_EDU_USERADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to DEV_EDU_SYSADMIN                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE DEV_EDU_DEVELOPER TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE DEV_EDU_Analyst TO ROLE DEV_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant access roles to DEV_EDU_SYSADMIN                                                               ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_EDU_SALES_RO TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_SALES_SU TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_SALES_RW TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_SALES_SFULL TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_INVENTGORY_RO TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_INVENTGORY_SU TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_INVENTGORY_RW TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_INVENTGORY_SFULL TO ROLE DEV_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant access roles to functional roles                                                               ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_EDU_SALES_RW TO ROLE DEV_EDU_DEVELOPER;
   GRANT ROLE _DEV_EDU_SALES_RO TO ROLE DEV_EDU_Analyst;
   GRANT ROLE _DEV_EDU_INVENTGORY_RW TO ROLE DEV_EDU_DEVELOPER;
   GRANT ROLE _DEV_EDU_INVENTGORY_RO TO ROLE DEV_EDU_Analyst;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant warehouse access roles to DEV_EDU_SYSADMIN                                                     ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_EDU_ADHOC_WH_WU TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_ADHOC_WH_WFULL TO ROLE DEV_EDU_SYSADMIN;
   GRANT ROLE _DEV_EDU_ADHOC_WH_ALL TO ROLE DEV_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant virtual warehouse access roles to functional roles                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _DEV_EDU_ADHOC_WH_WU TO ROLE DEV_EDU_DEVELOPER;
   GRANT ROLE _DEV_EDU_ADHOC_WH_WU TO ROLE DEV_EDU_Analyst;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to super-roles                                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to users                                                                      ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ ██████████████████████████████████████████ Switch role... ██████████████████████████████████████████ ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role DEV_EDU_SYSADMIN                                                                     ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE DEV_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Clone database DEV_EDU                                                                               ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant db usage to access roles                                                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_SALES_SU;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON DATABASE DEV_EDU TO ROLE _DEV_EDU_INVENTGORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the warehouses                                                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE WAREHOUSE IF NOT EXISTS DEV_EDU_ADHOC_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='xsmall', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant privileges on warehouses to access roles                                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON WAREHOUSE DEV_EDU_ADHOC_WH TO ROLE _DEV_EDU_ADHOC_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE DEV_EDU_ADHOC_WH TO ROLE _DEV_EDU_ADHOC_WH_WFULL;
   GRANT ALL ON WAREHOUSE DEV_EDU_ADHOC_WH TO ROLE _DEV_EDU_ADHOC_WH_ALL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the schemas                                                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE SCHEMA IF NOT EXISTS DEV_EDU.SALES WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS DEV_EDU.INVENTGORY WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on objects to access roles                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant privileges on objects to access roles                                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT SELECT ON ALL TABLES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SU;
   GRANT USAGE ON SCHEMA SALES TO ROLE _DEV_EDU_SALES_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT SELECT ON ALL TABLES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT USAGE ON SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant future privileges on objects to access roles                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT SELECT ON FUTURE TABLES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _DEV_EDU_SALES_SFULL;
   GRANT SELECT ON FUTURE TABLES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA INVENTGORY TO ROLE _DEV_EDU_INVENTGORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Build of DEV_EDU complete - have a nice day                                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Thanks for using RBAC Automation Manager                                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

