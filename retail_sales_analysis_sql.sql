--Create a database as retail_sales
CREATE DATABASE retail_sales;

--Create a table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,	
				customer_id INT,
				gender VARCHAR(10),	
				age INT,
				category VARCHAR(20),	
				quantiy INT,	
				price_per_unit FLOAT,	
				cogs FLOAT,	
				total_sale FLOAT

				)

--Cleaning the data
DELETE FROM retail_sales
Where 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR 
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantiy IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL

--Data Exploration

--How many customers we have?
Select Count(distinct customer_id) as total_customer from retail_sales

---How many category we have?
select distinct category from retail_sales;

--Data Analysis & Business Key Problems & Answer

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

Select * from retail_sales
where sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
Select * 
from retail_sales
where category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantiy>=4

--Write a SQL query to calculate the total sales (total_sale) for each category
Select category, sum(total_sale) as net_sale, count(*) as total_order
from retail_sales
group by 1

---Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
Select round(avg(age),2) as avg_age from retail_sales
where category = 'Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000

Select * from retail_sales
where total_sale>1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select
	year,
	month,
	avg_sale
from
(
Select
	Extract(year from sale_date) as year,
	Extract(month from sale_date) as month,
	Avg(total_sale) as Avg_Sale,
	RANK() Over(Partition by Extract(year from sale_date) Order by Avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1

--Write a SQL query to find the top 5 customers based on the highest total sales
Select
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by 2 desc
limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category

Select 
category,
COUNT(DISTINCT customer_id) as cnt_unique_cs
from retail_sales
group by category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

