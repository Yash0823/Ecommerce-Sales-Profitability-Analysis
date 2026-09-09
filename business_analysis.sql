select * from order_details_clean;
select * from customers_clean;
select * from orders_clean;
select * from products_clean;

-- KPI 1 — Total Sales
select 
	sum(od.sales_amount) as total_sales 
from order_details_clean od
join orders_clean o
	ON o.order_id = od.order_id
where o.order_status = "Delivered";

-- KPI total_profit 

select 
	sum(od.profit) as total_profit
    from order_details_clean od
inner join orders_clean o
on od.order_id = o.order_id
where o.order_status = "Delivered";

-- KPI 3 — Total Orders
select 
	count(distinct order_id) as total_orders 
from orders_clean
where order_status = "Delivered";

-- KPI 4 — Total Customers
select 
	count(distinct customer_id) as total_customers
    from orders_clean
    where order_status = "Delivered";

-- KPI 5 — Average Order values
SELECT
    ROUND(
        SUM(od.sales_amount) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders_clean o
JOIN order_details_clean od
    ON o.order_id = od.order_id
WHERE o.order_status = 'Delivered';

-- PHASE 8 — Monthly Sales Analysis
select 
	year(o.order_date) as year,
    month(o.order_date) as month, 
    sum(od.sales_amount) as sales, 
    sum(od.profit) as profit 
from orders_clean o 
join order_details_clean od 
on o.order_id=od.order_id
where order_status = "Delivered" 
group by 
	year(o.order_date),
    month(o.order_date)
order by 
year, month;

-- PHASE 9 — Category Performance
select 
	p.category, 
    sum(od.sales_amount) as sales, 
    sum(od.profit) as profit, 
    sum(od.quantity) as unit_sold
from order_details_clean od
join products_clean p
on od.product_id = p.product_id
join orders_clean o 
on od.order_id = o.order_id 
where order_status = "Delivered" 
group by p.category 
order by sales desc;

-- PHASE 10 — Top 10 Products
select 
	p.product_name, 
    p.category, 
    sum(od.quantity) as unit_sold, 
    sum(od.sales_amount) as sales,
    sum(od.profit) as profit
from order_details_clean od
Inner Join products_clean p
	on od.product_id = p.product_id
inner join orders_clean o
	on o.order_id = od.order_id
where o.order_status = "Delivered" 
group by 
	p.product_name, p.category
order by sales desc
limit 10 ;

-- PHASE 11 — Customer Segment Analysis
select 
	c.customer_segment, 
    count(distinct c.customer_id) as customers, 
    sum(od.sales_amount) as sales, 
    sum(od.profit) as profit
from customers_clean c 
join orders_clean o 
	on c.customer_id = o.customer_id
join order_details_clean od 
	on o.order_id = od.order_id
where order_status = "Delivered" 
group by customer_segment
order by sales desc;

-- PHASE 12 — State Performance
select 
	c.state, 
    sum(od.sales_amount) as sales, 
    sum(od.profit) as profit, 
    count(distinct o.order_id) as orders 
from customers_clean c
inner join orders_clean o 
	On c.customer_id = o.customer_id
inner join order_details_clean od
	on o.order_id = od.order_id
where order_status = "Delivered" 
group by c.state 
order by sales desc; 

-- PHASE 13 — Payment Method Analysis
select 
	payment_method, 
    count(distinct o.order_id) as orders,
    sum(od.sales_amount) as sales 
from orders_clean o 
inner join order_details_clean od 	
ON o.order_id = od.order_id 
where order_status = "Delivered"
group by payment_method
order by sales desc;
    
-- PHASE 14 — Return & Cancellation Analysis
select 
	order_status, 
    count(distinct order_id) as orders
from orders_clean 
group by order_status 
order by orders desc; 

-- Then calculate rates:
select 
	count(distinct case
		when order_status = "Cancelled"
        then order_id END) * 100.0
        / count(distinct order_id) as cancellation_rate,
        
	count(distinct case 
		when order_status = "Returned" 
        then order_id end) * 100.0
        / count(distinct order_id) as returned_rate
from orders_clean;

-- PHASE 15 — Delivery Performance
select 
	avg(datediff(delivery_date, order_date)) as avg_delivery_days
from orders_clean
where order_status = "Delivered" ;

-- State-wise delivery:
select 
	c.state, 
    avg(datediff(o.delivery_date, o.order_date)) as avg_delivery_date 
from orders_clean o 
join customers_clean c
on o.customer_id = c.customer_id
where order_status = "Delivered" 
group by c.state
order by avg_delivery_date desc;


-- Advance SQL 
-- Top 3 products in each category
with product_sales as 
( 
	select 
		p.category, 
        p.product_name, 
        sum(od.sales_amount)as sales
	from products_clean p 
    join order_details_clean od
		 on p.product_id = od.product_id 
	join orders_clean o
		on o.order_id = od.order_id 
	where order_status = "Delivered" 
    group by 
		p.category, 
        p.product_name
), 
	ranked_products as 
		( select 
        *, 
        rank() over ( 
			partition by category 
            order by sales desc
            ) as product_rank 
		from product_sales
        ) 
select * 
from ranked_products 
where product_rank <= 3;


-- PHASE 17 — Create a SQL View for Power BI

-- Now create a clean analytical view.

create view vw_sales_analysis as 
select 
	o.order_id, 
    o.order_date, 
    o.customer_id, 
    o.order_status,
    o.payment_method, 
    o.shipping_mode, 
    od.product_id, 
    od.quantity,
    od.discount,
    od.sales_amount, 
    od.profit
from orders_clean o 
join order_details_clean od
on o.order_id = od.order_id;

SELECT *
FROM vw_sales_analysis
LIMIT 10;