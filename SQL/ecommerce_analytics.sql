create database ecommerce_analytics;
use ecommerce_analytics;
create table customers (
	customer_id int,
	customer_name varchar(100),
	gender varchar(20),
    age int, 
	city varchar(100),
    state varchar(100),	
    customer_segment varchar(50),
    registration_date date
);
 
CREATE TABLE products (
	product_id INT, 
    product_name varchar(100),
    category varchar(100),
    sub_category varchar(100),
	brand varchar(100),
    unit_cost decimal(12,2),
    unit_price decimal(12,2)
    );
    
create table orders (
	order_id int,
    customer_id	int,
    order_date date,
    ship_date date,
    delivery_date date,
    payment_method varchar(100),
    shipping_mode varchar(100),
    order_status varchar(100)
);

create table order_details (
	order_id int,
    product_id int,
    quantity int,
    discount decimal(5,2),
    sales_amount decimal (12,2),
    profit decimal(12,2)
);

select * from customers;
select * from order_details;
select * from orders;
select * from products;

-- Now check row counts:

select 'customers' as table_name, count(*) as row_count 
from customers
union all 
select 'products', count(*) 
from products 
union all 
select 'orders', count(*)
from orders
union all 
select 'order_details', count(*)
from order_details;

-- Find duplicate customers ?
select 
	customer_id,
    count(*) as duplicate_count 
    from customers 
    group by customer_id
    having count(*) >1 ;
-- Find duplicate orders ?
select 
	order_id, 
    count(*) as duplicate_count
    from orders
    group by order_id
    having count(*) >1 ;
-- Find duplicate order details ?
select
	order_id,
    product_id,
    quantity,
    discount,
    sales_amount, 
    profit, 
    count(*) as duplicate_count
from order_details
group by 
	order_id, 
    product_id,
    quantity,
    discount,
    sales_amount,
    profit
having count(*) >1;

-- Check missing values Customer table 

select 
	sum(customer_id is null) as missing_customer_id,
    sum(customer_name is null) as missing_customer_name, 
    sum(gender is null) as missing_gender,
    sum(age is null) as missing_age,
    sum(city is null) as missing_city,
    SUM(state IS NULL) AS missing_state,
    sum(customer_segment is null) as missing_customer_segment,
    sum(registration_date is null) as missing_registeration_date
from customers;

-- Check missing values orders table 

select 
	sum(order_id is null) as missing_order_id,
    sum(customer_id is null) as missing_customer_id,
    SUM(order_date IS NULL) AS missing_order_date,
    sum(ship_date is null) as missing_ship_date,
    sum(delivery_date is null) as missing_delivery_date,
    sum(payment_method is null) as missing_payment_method,
    sum(shipping_mode is null) as missing_shipping_mode,
    sum(order_status is null) as missing_order_status
from orders;

-- Check missing values product table ?

select 
	sum(product_id is null) as missing_product_id, 
    sum(product_name is null) as missing_product_name, 
    sum(category is null) as missing_category, 
    sum(sub_category is null) as missing_sub_category, 
    sum(brand is null) as missing_brand,
    sum(unit_cost is null) as missing_unit_cost, 
    sum(unit_price is null) as missing_unit_price
from products;

-- -- Check missing values order_details Table

select 
	sum(order_id is null) as missing_order_id,
    sum(product_id is null) as missing_product_id,
    sum(quantity is null) as missing_quantity,
    sum(discount is null) as missing_discount,
    sum(sales_amount is null) as missing_sales_amount,
    sum(profit is null) as missing_profit
from order_details;

-- Create CLEAN tables 

create table customers_clean as 
select distinct
	customer_id, 
    customer_name, 
    gender, 
    age, 
    city, 
    state, 
    customer_segment, 
    registration_date
from customers;

create table products_clean as
select distinct
	product_id,
    product_name, 
    category, 
    sub_category, 
    brand, 
    unit_cost, 
    unit_price
from products; 

create table orders_clean as 
select distinct
	order_id, 
    customer_id, 
    order_date, 
    ship_date ,
    delivery_date, 
    payment_method,
    shipping_mode, 
    order_status
from orders;

create table order_details_clean as 
select distinct
	order_id, 
    product_id, 
    quantity, 
    discount, 
    sales_amount, 
    profit
from order_details;
    
show tables; 

select count(*) from customers_clean;
select count(*) from products_clean;

