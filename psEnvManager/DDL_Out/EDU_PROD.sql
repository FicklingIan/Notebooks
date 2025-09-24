
-- *************************************************************************************************
-- * Date           : 2023-09-25                                                                   *
-- * Time           : 14:15                                                                        *
-- * Spreadsheet    : /Users/ifickling/Documents/GitHub/psEnvManager/SpreadSheet/EDU_Examples.xlsx *
-- * Environment(s) : PROD_EDU                                                                     *
-- *************************************************************************************************


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the security roles for PROD_EDU_SYSADMIN and PROD_EDU_SECADMIN                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   USE ROLE USERADMIN;

   CREATE ROLE IF NOT EXISTS PROD_EDU_SECADMIN;
   CREATE ROLE IF NOT EXISTS PROD_EDU_SYSADMIN;

   GRANT CREATE ROLE ON ACCOUNT TO PROD_EDU_SECADMIN;
   GRANT ROLE PROD_EDU_SECADMIN TO ROLE USERADMIN;
   GRANT ROLE PROD_EDU_SYSADMIN TO ROLE SYSADMIN;

   USE ROLE SYSADMIN;

   GRANT CREATE DATABASE ON ACCOUNT TO PROD_EDU_SYSADMIN;
   GRANT CREATE WAREHOUSE ON ACCOUNT TO PROD_EDU_SYSADMIN;

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

   CREATE ROLE IF NOT EXISTS PROD_EDU_APP_DEV;
   CREATE ROLE IF NOT EXISTS PROD_EDU_Analyst;
   CREATE ROLE IF NOT EXISTS PROD_EDU_ELT_DEV;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on functional roles to PROD_EDU_SECADMIN                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE PROD_EDU_APP_DEV TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE PROD_EDU_Analyst TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE PROD_EDU_ELT_DEV TO ROLE PROD_EDU_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create access roles, Permissive DB Only Access Roles                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create access roles, Restrictive DB Only Access Roles                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS _PROD_EDU_SALES_RO;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_SALES_SU;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_SALES_RW;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_SALES_SFULL;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_INVENTORY_RO;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_INVENTORY_SU;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_INVENTORY_RW;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_INVENTORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on schema access roles to PROD_EDU_SECADMIN                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE _PROD_EDU_SALES_RO TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_SALES_SU TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_SALES_RW TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_SALES_SFULL TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_INVENTORY_RO TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_INVENTORY_SU TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_INVENTORY_RW TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_INVENTORY_SFULL TO ROLE PROD_EDU_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create warehouse access roles                                                                        ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE ROLE IF NOT EXISTS _PROD_EDU_ADHOC_WH_WU;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_ADHOC_WH_WFULL;
   CREATE ROLE IF NOT EXISTS _PROD_EDU_ADHOC_WH_ALL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on warehouse access roles to PROD_EDU_SECADMIN                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON ROLE _PROD_EDU_ADHOC_WH_WU TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_ADHOC_WH_WFULL TO ROLE PROD_EDU_SECADMIN;
   GRANT OWNERSHIP ON ROLE _PROD_EDU_ADHOC_WH_ALL TO ROLE PROD_EDU_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create Super-Roles  (ownership stays with USERADMIN)                                                 ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant super-roles to users                                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role PROD_EDU_SECADMIN                                                                    ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE PROD_EDU_SECADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to PROD_EDU_SYSADMIN                                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE PROD_EDU_APP_DEV TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE PROD_EDU_Analyst TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE PROD_EDU_ELT_DEV TO ROLE PROD_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant access roles to PROD_EDU_SYSADMIN                                                              ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _PROD_EDU_SALES_RO TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_SALES_SU TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_SALES_RW TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_SALES_SFULL TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_INVENTORY_RO TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_INVENTORY_SU TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_INVENTORY_RW TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_INVENTORY_SFULL TO ROLE PROD_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant access roles to functional roles                                                               ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _PROD_EDU_SALES_SFULL TO ROLE PROD_EDU_APP_DEV;
   GRANT ROLE _PROD_EDU_SALES_RO TO ROLE PROD_EDU_Analyst;
   GRANT ROLE _PROD_EDU_SALES_RW TO ROLE PROD_EDU_ELT_DEV;
   GRANT ROLE _PROD_EDU_INVENTORY_SFULL TO ROLE PROD_EDU_APP_DEV;
   GRANT ROLE _PROD_EDU_INVENTORY_RO TO ROLE PROD_EDU_Analyst;
   GRANT ROLE _PROD_EDU_INVENTORY_RW TO ROLE PROD_EDU_ELT_DEV;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant warehouse access roles to PROD_EDU_SYSADMIN                                                    ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _PROD_EDU_ADHOC_WH_WU TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_ADHOC_WH_WFULL TO ROLE PROD_EDU_SYSADMIN;
   GRANT ROLE _PROD_EDU_ADHOC_WH_ALL TO ROLE PROD_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant virtual warehouse access roles to functional roles                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT ROLE _PROD_EDU_ADHOC_WH_WU TO ROLE PROD_EDU_APP_DEV;
   GRANT ROLE _PROD_EDU_ADHOC_WH_WU TO ROLE PROD_EDU_Analyst;
   GRANT ROLE _PROD_EDU_ADHOC_WH_WU TO ROLE PROD_EDU_ELT_DEV;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to super-roles                                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant functional roles to users                                                                      ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ |||||||||||||||||||||||||||||||||||||||||| Switch role... |||||||||||||||||||||||||||||||||||||||||| ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Try to use role PROD_EDU_SYSADMIN                                                                    ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

USE ROLE PROD_EDU_SYSADMIN;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create database PROD_EDU                                                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE DATABASE IF NOT EXISTS PROD_EDU DATA_RETENTION_TIME_IN_DAYS = 1;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant db usage to access roles                                                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_SALES_SU;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON DATABASE PROD_EDU TO ROLE _PROD_EDU_INVENTORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the warehouses                                                                                ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE WAREHOUSE IF NOT EXISTS PROD_EDU_ADHOC_WH WITH WAREHOUSE_TYPE = 'STANDARD' warehouse_size='xsmall', scaling_policy='standard',min_cluster_count=1, max_cluster_count=1, auto_suspend=300,auto_resume=true, initially_suspended=true;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant privileges on warehouses to access roles                                                       ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT USAGE ON WAREHOUSE PROD_EDU_ADHOC_WH TO ROLE _PROD_EDU_ADHOC_WH_WU;
   GRANT USAGE, OPERATE,MODIFY ON WAREHOUSE PROD_EDU_ADHOC_WH TO ROLE _PROD_EDU_ADHOC_WH_WFULL;
   GRANT ALL ON WAREHOUSE PROD_EDU_ADHOC_WH TO ROLE _PROD_EDU_ADHOC_WH_ALL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Create the schemas                                                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   CREATE SCHEMA IF NOT EXISTS PROD_EDU.SALES WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';
   CREATE SCHEMA IF NOT EXISTS PROD_EDU.INVENTORY WITH MANAGED ACCESS data_retention_time_in_days=1 comment = '';

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant ownership on objects to access roles                                                           ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant future ownership on objects to access roles                                                    ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT OWNERSHIP ON FUTURE TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE TASKS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE SEQUENCES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT OWNERSHIP ON FUTURE TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE TASKS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE SEQUENCES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT OWNERSHIP ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant privileges on objects to access roles                                                          ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT SELECT ON ALL TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SU;
   GRANT USAGE ON SCHEMA SALES TO ROLE _PROD_EDU_SALES_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT SELECT ON ALL TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT SELECT ON ALL VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE,READ ON ALL STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT SELECT ON ALL STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT USAGE ON SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON ALL TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT SELECT ON ALL VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE,READ,WRITE ON ALL STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON ALL FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT SELECT ON ALL STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT MONITOR, OPERATE ON ALL TASKS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON ALL SEQUENCES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON ALL FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON ALL PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT ALL ON ALL TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT MONITOR,OPERATE ON ALL TASKS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON ALL PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Grant future privileges on objects to access roles                                                   ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

   GRANT SELECT ON FUTURE TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA SALES TO ROLE _PROD_EDU_SALES_SFULL;
   GRANT SELECT ON FUTURE TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE,READ ON FUTURE STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RO;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SU;
   GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES ON FUTURE TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT SELECT ON FUTURE VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE,READ,WRITE ON FUTURE STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT SELECT ON FUTURE STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON FUTURE SEQUENCES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_RW;
   GRANT ALL ON FUTURE TABLES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE VIEWS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE STAGES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE FILE FORMATS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE STREAMS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT MONITOR,OPERATE ON FUTURE TASKS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE SEQUENCES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE FUNCTIONS IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;
   GRANT ALL ON FUTURE PROCEDURES IN SCHEMA INVENTORY TO ROLE _PROD_EDU_INVENTORY_SFULL;

-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Build of PROD_EDU complete - have a nice day                                                         ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟


-- ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
-- ▌ Thanks for using RBAC Automation Manager                                                             ▐
-- ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

