create or replace procedure silver.load_silver()
LANGUAGE plpgsql
AS $$
declare start_time timestamp;
declare end_time timestamp;
begin
	start_time := clock_timestamp();
	RAISE NOTICE '=================================================================';
    RAISE NOTICE 'Loading Silver layer';
    RAISE NOTICE '=================================================================';
	
	RAISE NOTICE '------------------------------------------------------------------';
    RAISE NOTICE 'Loading CRM tables';
	RAISE NOTICE '------------------------------------------------------------------';
	
	TRUNCATE table silver.crm_cust_info;
	raise notice '>>> Inserting data into silver.crm_cust_info';
	insert into silver.crm_cust_info (
				cst_id,cst_key,cst_firstname,cst_lastname,cst_gndr,cst_marital_status,cst_create_date
				) 
						select 
						cst_id,
						cst_key,
						trim(cst_firstname) as cst_firstname,
						trim(cst_lastname) as cst_lastname,
						case 
							when upper(TRIM(cst_gndr)) = 'F' then 'Female'
							when upper(TRIM(cst_gndr)) ='M' then 'Male'
							else 'n/a'		
						end  as cst_gndr, 
						case
							when upper(TRIM(cst_marital_status)) = 'M' then 'Married'
							when upper(TRIM(cst_marital_status)) ='S' then 'Single'
							else 'n/a'
						end as cst_marital_status,
						cst_create_date 
						from (
						select 
						*,
						row_number() over (partition by cst_id order by cst_create_date DESC) as flag_last
						from bronze.crm_cust_info) where flag_last =1;
						
	truncate table silver.crm_prd_info;
	raise notice '>>>Inserting data into silver.silver.crm_prd_info table';
	insert into silver.crm_prd_info(
		prd_id,
	    cat_id,
	    prd_key ,
	    prd_nm,
	    prd_cost ,
	    prd_line ,
	    prd_start_dt,
	    prd_end_dt 
	  )
		select 
		prd_id,
			replace(substring(prd_key,1,5),'-','_') as cat_id,
			substring(prd_key, 7,length(prd_key) )as prd_key,
			prd_nm,
			COALESCE(prd_cost, 0) as prd_cost,
			case 
				when upper(trim(prd_line)) ='M' then 'Mountian'
				when upper(trim(prd_line)) ='R' then 'Road'
				when upper(trim(prd_line)) ='S' then 'other Sales'
				when upper(trim(prd_line)) ='T' then 'Touring'
				else 'n/a'
			end  as prd_line,
			prd_start_dt :: date as prd_start_dt,
			(LEAD(prd_start_dt) OVER (
			    PARTITION BY prd_key 
			    ORDER BY prd_start_dt
			) - INTERVAL '1 day'):: date AS prd_end_dt
			from bronze.crm_prd_info;
			
	----------------------------------------crm_sls_sales_details------------------------------------------------------
	truncate table silver.crm_sales_details;
	raise notice '>>>Inserting data into silver.silver.crm_sales_deatails table';
	insert into silver.crm_sales_details(
		 sls_ord_num,sls_prd_key,sls_cust_id,
		 sls_order_dt, sls_ship_dt,sls_due_dt,
		 sls_sales,sls_quantity,sls_price)				
	select 
		sls_ord_num,
	    sls_prd_key,
	    sls_cust_id,
	    case 
	    	when sls_order_dt = 0 or length(sls_order_dt::text) !=8 then null
	    	else sls_order_dt ::text :: date
	    end as sls_order_dt,
	    case 
	    	when sls_ship_dt =0 or length(sls_ship_dt:: text) !=8 then null
	    	else sls_ship_dt ::text :: date
	    end as sls_ship_dt,
	    case 
	    	when sls_due_dt =0 or length(sls_ship_dt:: text) !=8 then null
	    	else sls_due_dt ::text :: date
	    end as sls_due_dt,
	    case 
			when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * ABS(sls_price)
			then sls_quantity * ABS(sls_price)
			else sls_sales
		end as sls_sales,
	    sls_quantity,
	    case
			when sls_price is null or sls_price <=0
			then sls_sales /nullif(sls_quantity,0) 
			 else sls_price
	end as sls_price
	from bronze.crm_sales_details;
	
	RAISE NOTICE '=====================================================';
    RAISE NOTICE 'Loading ERP tables';
	RAISE NOTICE '======================================================';	
	
	truncate table silver.erp_cust_az12;
	raise notice '>>>Inserting data into silver.silver.erp_cust_az12 table';
	insert into silver.erp_cust_az12 (cid,bdate,gen)
	select 
	case
		when cid  like 'NAS%' then substring(cid,4,length(cid))
		else cid
	end as cid,
	case
		when bdate > NOW() then null 
		else bdate
	end as bdate,
	case
		when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
		when upper(trim(gen)) in ('M', 'MALE') then 'Male'
		else 'n/a'
	end as gen
	from bronze.erp_cust_az12;
	
	truncate table silver.erp_loc_a101;
	raise notice '>>>Inserting data into silver.silver.erp_loc_a101 table';
	insert into silver.erp_loc_a101(cid,cntry)
	select 
	replace(cid, '-','') cid,
	case
		when TRIM(cntry)  ='DE' then 'Germany'
		when TRIM(cntry) in ('US', 'USA') then 'United State'
		when TRIM(cntry )= '' or cntry is NULL then 'n/a'
		else TRIM(cntry)
	end as cntry  
	from
	bronze.erp_loc_a101;
	
	truncate table silver.erp_px_cat_g1v2;
	raise notice '>>>Inserting data into silver.silver.erp_px_cat_g1v2e'; 
	insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
	select 
	id,
	cat,subcat,
	maintenance
	from bronze.erp_px_cat_g1v2;
	
	end_time := clock_timestamp();

    RAISE NOTICE 'Total load time: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));
    
    exception
    	
		when others then
		
			raise notice ' An eror occured during load of silver layer';
			RAISE NOTICE 'Error message: %', SQLERRM;
        	RAISE NOTICE 'Error code: %', SQLSTATE;
    end
$$

