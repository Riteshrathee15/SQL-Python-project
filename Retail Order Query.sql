create table df_orders (
[order_id] int primary key,
[order_date] date,
[ship_mode] varchar(20),
[segment] varchar(20),
[country] varchar(20),
[city] varchar(20),
[state] varchar(20),
[postal_code] varchar(20),
[region] varchar(20),
[category] varchar(20),
[sub_category] varchar(20),
[product_id] varchar(50),
[quantity] int,
[discount] decimal(7,2),
[sale_price] decimal(7,2),
[profit] decimal (7,2));

SELECT * FROM df_orders;

--find top 10 highest reveue generating products 
SELECT top 10 sub_category as products,sum(sale_price) as Revenue 
FROM df_orders
GROUP BY sub_category
order by Revenue desc

--find top 5 highest selling products in each region
with cte as (
select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
With cte as(
select year(order_date) order_year,month(order_date)order_month,sum(sale_price)sales
from df_orders
group by month(order_date),year(order_date) 
--order by order_month,order_year
)
select order_month,
sum(case when order_year='2022' then sales else 0 end) sales_2022,
sum(case when order_year='2023' then sales else 0 end) sales_2023
from cte
group by order_month
order by order_month

--for each category which month had highest sales 
SELECT distinct category FROM df_orders;
SELECT format(order_date,'yyyyMM') OrderYearMOn,
SUM(sale_price)sales,
category
FROM df_orders
GROUP BY category,format(order_date,'yyyyMM')
ORDER BY category,format(order_date,'yyyyMM')




with cte as
(
select month(order_date)order_month,year(order_date)order_year,sum(sale_price)sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
)
