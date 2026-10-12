create database if not exists walmart;
use walmart;

 
CREATE TABLE sales (
    invoice_id VARCHAR(20) NOT NULL PRIMARY KEY,
    branch VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    customer_type VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    vat DECIMAL(10,4) NOT NULL,
    total DECIMAL(10,4) NOT NULL,
    dates DATETIME NOT NULL,
    times TIME NOT NULL,
    payment VARCHAR(20) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT NOT NULL,
    gross_income DECIMAL(10,4) NOT NULL,
    rating FLOAT(2,1) NOT NULL
);
ALTER TABLE sales
MODIFY COLUMN dates VARCHAR(30) NOT NULL;

-- import csv file --

select * from sales;
 show global variables like 'local_infile';
  set global local_infile=1;
  
  -- data cleaning
  select count(*) as total_record
  from sales;
  
  select invoice_id,count(*) as total
  from sales
  group by invoice_id
  having count(*) > 1 ;
  
SELECT
SUM(invoice_id IS NULL) invoice_id,
SUM(branch IS NULL) branch,
SUM(city IS NULL) city,
SUM(customer_type IS NULL) customer_type,
SUM(gender IS NULL) gender,
SUM(product_line IS NULL) product_line,
SUM(unit_price IS NULL) unit_price,
SUM(quantity IS NULL) quantity,
SUM(vat IS NULL) vat,
SUM(total IS NULL) total,
SUM(times IS NULL) sale_time,
SUM(payment IS NULL) payment,
SUM(cogs IS NULL) cogs,
SUM(gross_margin_pct IS NULL) gross_margin_pct,
SUM(gross_income IS NULL) gross_income,
SUM(rating IS NULL) rating
FROM sales;

SELECT *
FROM sales
WHERE TRIM(city)=''
OR TRIM(branch)=''
OR TRIM(customer_type)=''
OR TRIM(product_line)=''
OR TRIM(payment)='';

set sql_safe_updates =0;

UPDATE sales
SET
city = TRIM(city),
branch = TRIM(branch),
customer_type = TRIM(customer_type),
gender = TRIM(gender),
product_line = TRIM(product_line),
payment = TRIM(payment);
  
  describe sales;
  
  select * from sales
  where quantity <=0;
  
  select * from sales
   where unit_price =0;
   
   -- freature and  engineering
   
select times,
(case when `times` between "00:00:00" and "12:00:00" then  "morning" 
when `times` between "12:01:00" and "16:00:00" then  "afternoon" else
"evening" end) as time_of_order from sales;


 alter table sales add column state varchar(20) not null after city ;
 
  alter table sales add column times_of_day varchar(20) not null ;

 
 select * from sales;
 describe sales;
 
 update sales
  set times_of_day=(
  case when times between "00:00:00" and "12:00:00" then "morning"
   when times between "12:01:00" and "06:00:00" then "afternoon"
  else "evening" end);
  select times_of_day from sales limit 10;
  
  
  select dates,
  dayname(dates) as day_name
  from sales;
  
  alter table sales
  add column day_name varchar(20);
  
  
  update sales
  set dates= str_to_date(dates,"%d-%m-%Y%H:%i");
  
  update sales
  set day_name = dayname(dates);

   
 alter table sales
 add column month_name varchar(20);
 
select dates,
monthname(dates) as month_name
from sales;

update sales
set month_name = monthname(dates);
   
   
-- eda exploratary data analysis--
-- 1.How many distinct cities are present in the dataset?
SELECT *  FROM sales;

-- 2.In which city is each branch situated?
select distinct branch,city from sales;

-- Product Analysis

-- 1.How many distinct product lines are there in the dataset?
  
 select count(distinct product_line) from sales;
 -- 2. What is the most common payment method?

 select payment,count(payment) as common_payment
 from sales
 group by payment
 order by common_payment asc limit 1;
 
 -- 3.What is the most selling product line?
select product_line,count(product_line) as most_selling_product
from sales
group by product_line
order by most_selling_product desc limit 10;

-- 4.What is the total revenue by month?
 
 select month_name,sum(total) as total_revenue
 from sales
 group by month_name
 order by total_revenue desc;
 
-- 5. Which month recorded the highest Cost of Goods Sold (COGS)?
select month_name,sum(cogs) as hight_cogs
from sales
group by month_name
order by hight_cogs desc;




-- 6.Which product line generated the highest revenue?
select product_line,sum(total) as high_revenue
from sales
group by product_line
order by high_revenue desc limit 1;


-- 7.Which city has the highest revenue?
select city,sum(total) as high_revenue
from sales
group by city
order by high_revenue desc limit 1;


-- 8.Which product line incurred the highest GST?
select product_line,sum(vat) as high_gst
from sales
group by product_line
order by high_gst desc limit 1;
-- 9. Retrieve each product line and add a column product_category, 


-- indicating 'Good' or 'Bad,'based on whether its sales are above the average.
alter table sales
add product_category varchar(20);

set @avg_total = (select avg(total)  from sales);

update sales
set product_category = case when total>=@avg_total then "Good" else
"Bad" end;

-- 10. Which branch sold more products than average product sold?
 -- average branchs - 
 -- branch 
 -- qty
 select branch,sum(quantity) as quantity
 from sales
 group by branch having sum(quantity) > avg(quantity)
 order by quantity desc limit 1;
 -- 11.What is the most common product line by gender?
 select gender,product_line,count(gender) as commom_pdt
 from sales
 group by gender,product_line
 order by commom_pdt desc;
-- 12.What is the average rating of each product line?
select product_line, round(avg(rating),2) avg_rating
from sales
group by product_line
order by avg_rating desc;
select * from sales;

--  Top 10 Advanced SQL Questions for Sales Analysis

-- 1. Which products contribute to 80% of total revenue? (Pareto Analysis)
 with product_cts as(
 select product_name,sum(total) as revenue
 from sales
 group by product_name),
  pareto as(select *,
  sum(revenue) over(order by revenue desc) as sales_running,
  sum(revenue) over() as sales_revenue
  from product_cts)
  select *,
  round((sales_running/sales_revenue)*100,2) as percentage
  from pareto
  where (sales_running/sales_revenue)<=0.80;
  
-- 2. Rank Products by Revenue within each State 

select state,product_name,sum(total) as revenue,
rank() over(partition by state order by sum(total)) as total_ranking
from sales
group by state,product_name;

WITH monthly_sales AS
	(
	SELECT
	MONTH(dates) month_no,
	MONTHNAME(dates) month_name,
	SUM(total) sales
	FROM sales
	GROUP BY MONTH(dates),MONTHNAME(dates)
	)

	SELECT *,
	LAG(sales) OVER(ORDER BY month_no) previous_month,
	ROUND(
	((sales-LAG(sales) OVER(ORDER BY month_no))/LAG(sales) OVER(ORDER BY month_no))*100,2) growth_percentage
	FROM monthly_sales;
    
    -- Top 3 Products in Every Branch
    with product_sales as(
    select branch,
    product_name,
    sum(total) as total_sales,
    dense_rank() over(partition by branch order by sum(total) desc)ranks
    from sales
    group by branch,product_name)
    select * from product_sales
    where ranks<=3 ;
    
-- Which Payment Method Generates Highest Revenue?

select payment,
count(*) total_order,
sum(total) as total
from sales
group by payment
order by total desc;

-- Sales Contribution by State
	SELECT
	state,
	SUM(total) sales,
	ROUND(
	SUM(total)*100/
	(SUM(SUM(total)) OVER()),2
	) contribution_percentage
	FROM sales
	GROUP BY state
	ORDER BY sales DESC;
    
    select * from sales;
   -- Which Day Generates Maximum Revenue?
   
   select day_name,sum(total) as total,
   rank() over( order by sum(total) desc) ranks
   from sales
   group by day_name;
   
  -- Best Selling Product by Quantity
  
    select product_name,
    sum(quantity) quantity,
    dense_rank() over( order by sum(quantity) desc) as bestsell_product
    from sales
    group by product_name;
    
-- #Sales Analysis
-- 1.Number of sales made in 
-- each time of the day per weekday
select * from sales;
select day_name, times_of_day,
sum(invoice_id) as saless
from sales 
group by day_name,times_of_day
having day_name not in ("Sunday","Saturday")
order by saless desc;

-- 2.Identify the customer type that generates the highest revenue.
select customer_type,sum(total) as revenue,
rank() over(order by sum(total) desc) high_revenue
from sales
group by customer_type;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,sum(vat) as tax
from sales
group by city
order by tax desc limit 1;

-- 4.Which customer type pays the most in VAT?
select customer_type,sum(vat) as tax
from sales
group by customer_type
order by tax;

-- Customer Analysis

-- 1.How many unique customer types does the data have?

select count(distinct customer_type) from sales;

-- 2.How many unique payment methods does the data have?
select count(distinct payment) from sales;

-- 3.Which is the most common customer type?

select customer_type,count(customer_type) as common
 from sales
 group by customer_type
 order by common desc limit 1;
 
-- 4.Which customer type buys the most?
select customer_type, count(customer_type) as total_buy
from sales
group by customer_type
order by total_buy desc  limit 1;

-- 5.What is the gender of most of the customers?
select gender,count(*) as most_customer
from sales
group by gender
order by most_customer desc;

-- 6.What is the gender distribution per branch?
select branch,gender,count(gender) as total
from sales
group by branch,gender
order by total desc;

-- 7.Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS average_rating
FROM sales GROUP BY time_of_day ORDER BY average_rating DESC LIMIT 1;

-- 8.Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, AVG(rating) AS average_rating
FROM sales GROUP BY branch, time_of_day ORDER BY average_rating DESC;



-- 9.Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name ORDER BY average_rating DESC LIMIT 1;

-- 10.Which day of the week has the best average ratings per branch?
SELECT  branch, day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name, branch ORDER BY average_rating DESC;


