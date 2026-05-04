CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
declare start_time timestamp;
declare end_time timestamp;
begin
	start_time := clock_timestamp();

	RAISE NOTICE '=================================================================';
    RAISE NOTICE 'Loading Bronze layer';
    RAISE NOTICE '=================================================================';
	
	RAISE NOTICE '------------------------------------------------------------------';
    RAISE NOTICE 'Loading CRM tables';
	RAISE NOTICE '------------------------------------------------------------------';
	
	
    RAISE NOTICE '>>> truncating table: bronze.crm_cust_info';
	TRUNCATE table bronze.crm_cust_info;
	RAISE NOTICE '>>> Inserting data into table: bronze.crm_cust_info';
	COPY bronze.crm_cust_info
	FROM 'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
	    FORMAT csv,
	    HEADER True,
	    DELIMITER ','
	);
	RAISE NOTICE '>>> truncating table: bronze.crm_prd_info';
	TRUNCATE table bronze.crm_prd_info;
		RAISE NOTICE '>>> inserting data into table: bronze.crm_prd_info';
	COPY bronze.crm_prd_info
	FROM 'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
	    FORMAT csv,
	    HEADER True,
	    DELIMITER ','
	);
	RAISE NOTICE '>>> truncating table: bronze.crm_sales_details';
	truncate table bronze.crm_sales_details;
	RAISE NOTICE '>>> inserting data into table: bronze.crm_sales_details';
	COPY bronze.crm_sales_details
	FROM 'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
	    FORMAT csv,
	    HEADER True,
	    DELIMITER ','
	);
	RAISE NOTICE '=====================================================';
    RAISE NOTICE 'Loading ERP tables';
	RAISE NOTICE '======================================================';


	RAISE NOTICE '>>> truncating table: bronze.erp_cust_az12';
	truncate bronze.erp_cust_az12;
	RAISE NOTICE '>>> inserting data into table: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12
	FROM 'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
	    FORMAT csv,
	    HEADER True,
	    DELIMITER ','
	);
	RAISE NOTICE '>>> truncating table: bronze.erp_loc_a101';
	truncate table bronze.erp_loc_a101;
	RAISE NOTICE '>>> Inserting data into table: bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101
	FROM 'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
	    FORMAT csv,
	    HEADER True,
	    DELIMITER ','
	);
	RAISE NOTICE '>>> truncating table: bronze.erp_px_cat_g1v2';
	truncate table  bronze.erp_px_cat_g1v2;
	RAISE NOTICE '>>> Inseritng Data into table: bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2
	FROM 'D:\Pc\work\Data analytics\telecom churn analysis\SQL-DATA WAREHOUSING\data warehouse\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
	    FORMAT csv,
	    HEADER True,
	    DELIMITER ','
	);
	end_time := clock_timestamp();

    RAISE NOTICE 'Total load time: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));
	EXCEPTION
		when others then
			raise notice ' An eror occured during load of bronze layer';
			RAISE NOTICE 'Error message: %', SQLERRM;
        	RAISE NOTICE 'Error code: %', SQLSTATE;
	
	
end 
$$




