-- SQL Retail Sales Anlysis - P1

CREATE DATABASE sql_project;

-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
transaction_id INT PRIMARY KEY,
sales_date DATE ,
sales_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sales FLOAT
);
SELECT * FROM retail_sales;

SELECT COUNT(*)
FROM retail_sales;

-- DATA COLUMN
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

-- IF WE HAVE TO CHECK NULL VALUES FOR EACH COLUMN
SELECT * FROM retail_sales
WHERE 
     transaction_id IS NULL
     OR
     sales_date IS NULL
     OR
     sales_time IS NULL
	OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR
   quantity IS NULL
    OR
   price_per_unit IS NULL
    OR
   cogs IS NULL
    OR
 total_sales IS NULL;
 
 -- DATA EXPLORATION
 -- HOW MANY SALES WE HAVE?
 SELECT COUNT(*) AS total_sales FROM retail_sales;
 
 -- HOW MANY CUSTOMERS WE HAVE?
 SELECT COUNT(DISTINCT customer_id) as cust_id FROM retail_sales;
 
 SELECT DISTINCT category FROM retail_sales;
 
 
 -- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS:
 
 -- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sales_date = '2022-11-05';
 
 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT  *
FROM retail_sales
WHERE category = 'Clothing' 
     AND
     DATE_FORMAT(sales_date, '%Y-%m') = '2022-11'
     AND
     quantity = 4
;
 
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
 SUM(total_sales) as net_sales,
 COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
ROUND(AVG(age) ,2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sales is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sales > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, 
gender,
COUNT(*) as total_trans
From retail_sales
GROUP BY category, gender2
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
year,
month,
avg_sales
FROM
(
SELECT 
       YEAR(sales_date) as year,    -- TO EXTRACT YEAR
       MONTH(sales_date) as month,
	   ROUND(AVG(total_sales) ,2) as avg_sales,
       RANK() OVER(PARTITION BY YEAR(sales_date) ORDER BY AVG(total_sales) DESC) AS rank_year  -- best selling month in each year
FROM retail_sales
GROUP BY 1,2
) AS t1       -- 
WHERE rank_year = 1;
-- ORDER BY 1,3 DESC;       


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
customer_id,
SUM(total_sales) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5 ;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
category,
COUNT(DISTINCT customer_id) 
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales                                     -- CTE
AS
(
SELECT *,
CASE 
     WHEN HOUR(sales_time)  <12 THEN 'Morning'
     WHEN HOUR(sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
END  as shift   
 FROM retail_sales
 )
 SELECT 
 shift,
 COUNT(*) AS total_orders
 FROM hourly_sales
 GROUP BY shift;

-- END OF PROJECT








