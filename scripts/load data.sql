/*====================================================================
 * Stored Procedure : Load data into the Bronze layer tables (source -> Bronze)
 * 
 * ====================================================================
 * Srcipt Purpose:
 * 		This stored procedure loads data into the 'bronze' schema from external csv files.
 * 		it performs the following:
 * 			- Truncates the bronze layer tables before loading data
 * 			- Calculates how the entire loading process takes
 * 	USE
 * 	- CALL bronze.load_bronze();
 * ======================================================================
 * */

create or replace
procedure bronze.load_bronze()
language plpgsql
as $$
declare start_time timestamp;

declare end_time timestamp;

begin
	start_time := clock_timestamp();

raise notice '=================================================================';

raise notice 'Loading Bronze layer';

raise notice '=================================================================';

raise notice '------------------------------------------------------------------';

raise notice 'Loading CRM tables';

raise notice '------------------------------------------------------------------';

raise notice '>>> truncating table: bronze.crm_cust_info';

truncate
	table bronze.crm_cust_info;

raise notice '>>> Inserting data into table: bronze.crm_cust_info';

copy bronze.crm_cust_info
from
'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
	    FORMAT csv,
	    header true,
	    delimiter ','
	);

raise notice '>>> truncating table: bronze.crm_prd_info';

truncate
	table bronze.crm_prd_info;

raise notice '>>> inserting data into table: bronze.crm_prd_info';

copy bronze.crm_prd_info
from
'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
	    FORMAT csv,
	    header true,
	    delimiter ','
	);

raise notice '>>> truncating table: bronze.crm_sales_details';

truncate
	table bronze.crm_sales_details;

raise notice '>>> inserting data into table: bronze.crm_sales_details';

copy bronze.crm_sales_details
from
'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
	    FORMAT csv,
	    header true,
	    delimiter ','
	);

raise notice '=====================================================';

raise notice 'Loading ERP tables';

raise notice '======================================================';

raise notice '>>> truncating table: bronze.erp_cust_az12';

truncate
	bronze.erp_cust_az12;

raise notice '>>> inserting data into table: bronze.erp_cust_az12';

copy bronze.erp_cust_az12
from
'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	with (
	    FORMAT csv,
	    header true,
	    delimiter ','
	);

raise notice '>>> truncating table: bronze.erp_loc_a101';

truncate
	table bronze.erp_loc_a101;

raise notice '>>> Inserting data into table: bronze.erp_loc_a101';

copy bronze.erp_loc_a101
from
'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	with (
	    FORMAT csv,
	    header true,
	    delimiter ','
	);

raise notice '>>> truncating table: bronze.erp_px_cat_g1v2';

truncate
	table bronze.erp_px_cat_g1v2;

raise notice '>>> Inseritng Data into table: bronze.erp_px_cat_g1v2';

copy bronze.erp_px_cat_g1v2
from
'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	with (
	    FORMAT csv,
	    header true,
	    delimiter ','
	);

end_time := clock_timestamp();

raise notice 'Total load time: % seconds',
    extract(EPOCH from (end_time - start_time));

exception
when others then
			raise notice ' An eror occured during load of bronze layer';

raise notice 'Error message: %',
sqlerrm;

raise notice 'Error code: %',
sqlstate;
end 
$$
