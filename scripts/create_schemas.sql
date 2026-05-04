/*=======================================================================
 * Create Database Schemas
 * ======================================================================
 * Script Purpose:
 * 	  This script creates a new database name 'Datawarehouse' after checking if it already exisits.
 *    if the database exixts, it is droped and recreated, Additionally, the script sets up three schemas 
 *    within the database: 'bronze', 'silver' and 'Gold'
 * 
 * WARNING:
 * Ensure you have data backed up before using this script as it will delete the entire datawarehouse
 * 
 * ASSUMPTIONS: I have assumed you are already connected to the database in question 
 * 
 * */

--create database
DROP DATABASE IF EXISTS datawarehouse;

CREATE database datawarehouse;

\c datawarehouse
--create schemas

CREATE schema bronze;
create schema silver;
create schema gold;
