-- Synthetic sample of the `raw` schema for CI (GitHub Actions).
-- Fake values only: no real customer, product or person data.
-- Mirrors what ingestion/python/load_raw.py writes: every column is text, plus tenant_id and _loaded_at.

drop schema if exists raw cascade;
create schema raw;

create table raw.sales(tenant_id text,id text,user_id text,date text,"Ref" text,is_pos text,client_id text,warehouse_id text,tax_rate text,"TaxNet" text,discount text,shipping text,"GrandTotal" text,paid_amount text,payment_statut text,statut text,notes text,created_at text,updated_at text,deleted_at text,shipping_status text,withhold_rate text,withhold_amount text,_loaded_at text);
insert into raw.sales values
('customer_a','1','1','2026-03-02','SL_1001','1','1','1','0.0','0.0','0.0','0.0','1950.0','1950.0','paid','completed',null,'2026-03-02 09:10:00',null,null,null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','2','1','2026-03-05','SL_1002','0','2','1','0.0','0.0','0.0','0.0','3000.0','1000.0','partial','completed',null,'2026-03-05 10:00:00',null,null,null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','3','1','2026-03-06','SL_1003','0','2','1','0.0','0.0','0.0','0.0','500.0','0.0','unpaid','pending',null,'2026-03-06 10:00:00',null,null,null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','1','2026-04-01','SL_2001','0','1','1','0','0','0','0','100.5','50','partial','completed',null,'2026-04-01 06:06:19',null,'2026-04-03 15:32:15',null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','2','1','2026-04-10','SL_2002','1','1','1','0','0','0','0','2400','2400','paid','completed',null,'2026-04-10 11:00:00',null,null,null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.sale_details(tenant_id text,id text,date text,sale_id text,product_id text,product_variant_id text,imei_number text,price text,sale_unit_id text,"TaxNet" text,tax_method text,discount text,discount_method text,total text,quantity text,created_at text,updated_at text,_loaded_at text);
insert into raw.sale_details values
('customer_a','1','2026-03-02','1','1',null,null,'650.0','1','0.0','1','0.0','2','1950.0','3.0',null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','2','2026-03-05','2','2',null,null,'1500.0','1','0.0','1','0.0','2','3000.0','2.0',null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','3','2026-03-06','3','1',null,null,'500.0','1','0.0','1','0.0','2','500.0','1.0',null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','2026-04-01','1','1',null,null,'100.5','1','0','1','0','2','100.5','1',null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','2','2026-04-10','2','1',null,null,'1200','1','0','1','0','2','2400','2',null,null,'2026-10-01T08:00:00+00:00');

create table raw.products(tenant_id text,id text,code text,"Type_barcode" text,name text,cost text,price text,category_id text,brand_id text,unit_id text,unit_sale_id text,unit_purchase_id text,"TaxNet" text,tax_method text,image text,note text,stock_alert text,is_variant text,is_imei text,not_selling text,product_type text,commission_enabled text,commission_type text,commission_value text,commission_required_qty text,is_active text,created_at text,updated_at text,deleted_at text,sub_category_id text,_loaded_at text);
insert into raw.products values
('customer_a','1','P001','CODE128','Sample oil 5L','400.0','650.0','1','1','1','1','1','0.0','1','no-image.png',null,'2.0','0','0','0','single',null,null,null,null,'1','2026-01-01 08:00:00',null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','2','P002','CODE128','Sample filter','900.0','1500.0','1','1','1','1','1','0.0','1','no-image.png',null,'5.0','0','0','0','single',null,null,null,null,'1','2026-01-01 08:00:00',null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','3','P003','CODE128','Old item','10.0','20.0','1','1','1','1','1','0.0','1','no-image.png',null,'0','0','0','0','single',null,null,null,null,'1','2026-01-01 08:00:00',null,'2026-02-01 08:00:00',null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','B001','CODE128','Sample bottle 1L','8.0','12.0','1',null,'1','1','1','0','1','no-image.png',null,'100','0','0','0','single',null,null,null,null,'1','2026-01-01 08:00:00',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.product_warehouse(tenant_id text,id text,product_id text,warehouse_id text,product_variant_id text,qte text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.product_warehouse values
('customer_a','1','1','1',null,'10.0',null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','2','2','1',null,'3.0',null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','1','1',null,'5000',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.categories(tenant_id text,id text,code text,name text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.categories values ('customer_a','1','OIL','Lubricants',null,null,null,'2026-10-01T08:00:00+00:00'),('customer_b','1','BTL','Bottles',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.brands(tenant_id text,id text,name text,description text,image text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.brands values ('customer_a','1','Brand X',null,null,null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.units(tenant_id text,id text,name text,"ShortName" text,base_unit text,operator text,operator_value text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.units values ('customer_a','1','Piece','pc',null,'*','1',null,null,null,'2026-10-01T08:00:00+00:00'),('customer_b','1','Piece','pc',null,'*','1',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.warehouses(tenant_id text,id text,name text,city text,mobile text,zip text,email text,country text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.warehouses values ('customer_a','1','Main store','City A','000','0','x@example.com','Ethiopia',null,null,null,'2026-10-01T08:00:00+00:00'),('customer_b','1','Factory','City B','000','0','y@example.com','Ethiopia',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.clients(tenant_id text,id text,name text,code text,email text,country text,city text,phone text,adresse text,created_at text,updated_at text,deleted_at text,tax_number text,car_type text,license_plate_number text,_loaded_at text);
insert into raw.clients values
('customer_a','1','walk-in-customer','1',null,'Ethiopia','City A',null,null,null,null,null,null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_a','2','Test Client','2',null,'Ethiopia','City A',null,null,null,null,null,null,null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','walk-in-customer','1',null,'Ethiopia','City B',null,null,null,null,null,null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.settings(tenant_id text,id text,currency_id text,client_id text,warehouse_id text,default_language text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.settings values ('customer_a','1','1','1',null,'en',null,null,null,'2026-10-01T08:00:00+00:00'),('customer_b','1','1','1',null,'en',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.currencies(tenant_id text,id text,code text,name text,symbol text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.currencies values ('customer_a','1','ETB','Birr','Br',null,null,null,'2026-10-01T08:00:00+00:00'),('customer_b','1','USD','US Dollar','$',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.purchases(tenant_id text,id text,user_id text,"Ref" text,date text,provider_id text,warehouse_id text,tax_rate text,"TaxNet" text,discount text,shipping text,"GrandTotal" text,paid_amount text,statut text,payment_statut text,notes text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.purchases values
('customer_a','1','1','PR_1001','2026-02-01','1','1','0','0','200.0','0','4400.0','4400.0','received','paid',null,'2026-02-01 07:00:00',null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','1','PR_2001','2026-03-01','1','1','0','0','0','0','40000','0','received','unpaid',null,'2026-03-01 07:00:00',null,null,'2026-10-01T08:00:00+00:00');

create table raw.purchase_details(tenant_id text,id text,cost text,base_cost text,purchase_unit_id text,"TaxNet" text,tax_method text,discount text,discount_method text,purchase_id text,product_id text,product_variant_id text,imei_number text,total text,quantity text,created_at text,updated_at text,_loaded_at text);
insert into raw.purchase_details values
('customer_a','1','400.0',null,'1','0','1','0','2','1','1',null,null,'4600.0','11.5',null,null,'2026-10-01T08:00:00+00:00'),
('customer_b','1','8',null,'1','0','1','0','2','1','1',null,null,'40000','5000',null,null,'2026-10-01T08:00:00+00:00');

create table raw.providers(tenant_id text,id text,name text,code text,email text,phone text,country text,city text,adresse text,created_at text,updated_at text,deleted_at text,tax_number text,_loaded_at text);
insert into raw.providers values ('customer_a','1','Test Supplier','1','s@example.com','000','Ethiopia','City A','Street 1',null,null,null,null,'2026-10-01T08:00:00+00:00'),('customer_b','1','Test Supplier','1','s@example.com','000','Ethiopia','City B','Street 1',null,null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.productions(tenant_id text,id text,"Ref" text,batch text,production_module_id text,warehouse_id text,operator_id text,shift_id text,date text,finished_product_id text,finished_product_quantity text,statut text,notes text,created_by text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.productions values ('customer_b','1','PRD_1','BATCH-1','1','1','1','1','2026-07-08','1','6000','completed',null,'1','2026-07-08 19:00:00',null,null,'2026-10-01T08:00:00+00:00');

create table raw.production_finished_products(tenant_id text,id text,production_id text,production_module_id text,finished_product_id text,finished_product_quantity text,created_at text,updated_at text,_loaded_at text);
insert into raw.production_finished_products values ('customer_b','1','1','1','1','6000',null,null,'2026-10-01T08:00:00+00:00');

create table raw.production_consumed_products(tenant_id text,id text,production_id text,production_ref text,warehouse_id text,product_id text,quantity text,unit_id text,unit_cost text,total_cost text,batch_number text,expiry_date text,notes text,created_at text,updated_at text,_loaded_at text);
insert into raw.production_consumed_products values ('customer_b','1','1','PRD_1','1','1','6000','1','9.74','58440.0',null,null,null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.production_wastes(tenant_id text,id text,production_id text,raw_material_id text,waste_quantity text,unit_id text,notes text,created_at text,updated_at text,_loaded_at text);
insert into raw.production_wastes values ('customer_b','1','1','1','15','1',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.production_modules(tenant_id text,id text,name text,description text,finished_product_id text,finished_product_quantity text,is_active text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.production_modules values ('customer_b','1','Bottle line',null,'1','1','1',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw.shifts(tenant_id text,id text,name text,start_time text,end_time text,salary text,notes text,is_active text,created_at text,updated_at text,deleted_at text,_loaded_at text);
insert into raw.shifts values ('customer_b','1','Day','06:00','18:00',null,null,'1',null,null,null,'2026-10-01T08:00:00+00:00');

create table raw._load_log(run_id text,tenant_id text,table_name text,row_count integer,status text,loaded_at timestamptz);
insert into raw._load_log values
('ci-sample','customer_a','sales',3,'loaded','2026-10-01T08:00:00+00:00'),
('ci-sample','customer_a','productions',0,'missing_in_source','2026-10-01T08:00:00+00:00'),
('ci-sample','customer_b','sales',2,'loaded','2026-10-01T08:00:00+00:00');
