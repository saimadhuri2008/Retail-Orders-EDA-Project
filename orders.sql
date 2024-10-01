use project;
show tables;
select * from orders;
desc orders;

-- find top 10 highest reveue generating products
select product_id, round(sum(sale_price*quantity),2) as revenue from orders group by product_id order by revenue desc limit 10;

-- find top 5 highest selling products in each region
with cte as (
select region , product_id , sum(quantity) as quantity, dense_rank() over(partition by region order by sum(quantity) desc) as r from orders group by region,product_id)
select region ,product_id,quantity,r from cte where r<=5;

-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
select month(order_date) as month, round(sum(case when year(order_date)=2022 then sale_price*quantity else 0 end),2) as '2022',
 round(sum(case when year(order_date)=2023 then sale_price else 0 end),2) as '2023' from orders group by month(order_date)  order by month(order_date);
 
 
-- for each category which month had highest sales 
with cte as (
select category, CONCAT(CAST(EXTRACT(MONTH FROM order_date) AS CHAR), '-', CAST(EXTRACT(YEAR FROM order_date) AS CHAR)) as month , round(sum(sale_price*quantity),2) as sales, 
dense_rank() over(partition by category order by sum(sale_price*quantity) desc) as r from orders group by category, CONCAT(CAST(EXTRACT(MONTH FROM order_date) AS CHAR), '-', CAST(EXTRACT(YEAR FROM order_date) AS CHAR)) )
select category, month, sales from cte where r=1;

-- which sub category had highest growth by profit in 2023 compare to 2022
select sub_category, sum(case when year(order_date)=2022 then profit else 0 end) as "2022",
 sum(case when year(order_date)=2023 then profit*quantity else 0 end) as "2023", 
 (sum(case when year(order_date)=2023 then profit*quantity else 0 end) - sum(case when year(order_date)=2022 then profit*quantity else 0 end))*100.0/sum(case when year(order_date)=2022 then profit*quantity else 0 end) as growth_pct
 from orders
 group by sub_category
 order by growth_pct desc ;



 
 

