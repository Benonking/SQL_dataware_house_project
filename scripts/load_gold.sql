create or replace
view gold.dim_customers as
select
	row_number() over (order by cst_id) 
	as customer_key,
	cu.cst_id as customer_id,
	cu.cst_key as customer_number,
	cu.cst_firstname as first_name,
	cu.cst_lastname as last_name,
	ex.cntry as country,
	cu.cst_marital_status as marital_status,
	case
		when cu.cst_gndr != 'n/a' then cu.cst_gndr
		--CRM is the master for genger info
		else coalesce(ca.gen, 'n/a')
	end as gender,
	ca.bdate as birthdate,
	cu.cst_create_date as create_date
from
	silver.crm_cust_info cu
left join silver.erp_cust_az12 ca
on
	cu.cst_key = ca.cid
left join silver.erp_loc_a101 ex
on
	cu.cst_key = ex.cid;

create or replace
view gold.dim_product as 
select
	row_number() over 
	(order by prd_crm.prd_start_dt,prd_crm.prd_key) as product_key,
	prd_id as product_id,
	prd_key as product_number,
	prd_nm as product_name,
	cat_id as category_id,
	erp_cat.cat as category,
	erp_cat.subcat as sub_category,
	erp_cat.maintenance,
	prd_cost as cost,
	prd_line as product_line,
	prd_start_dt as start_date
from
	silver.crm_prd_info prd_crm
left join silver.erp_px_cat_g1v2 erp_cat
on
	prd_crm.cat_id = erp_cat.id
where
	prd_end_dt is null;
--filter out all historical information


create or replace
view gold.fact_sales as
select
	sd.sls_ord_num as order_number,
	pr.product_key,
	cs.customer_key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shiping_date,
	sd.sls_due_dt as due_date,
	sd.sls_quantity as quantity,
	sd.sls_price as price,
	sd.sls_sales as sales_amount
from
	silver.crm_sales_details sd
left join gold.dim_product pr
on
	sd.sls_prd_key = pr.product_number
left join gold.dim_customers cs
on
	sd.sls_cust_id = cs.customer_id;
	
	

