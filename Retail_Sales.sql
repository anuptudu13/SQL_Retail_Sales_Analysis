-- Retail Sales Analysis --

CREATE DATABASE retail_db;
USE retail_db;

-- Create Tables:
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales;

-- DATA CLEANING
-- Checking for NULL values
SELECT * FROM retail_sales
WHERE sale_date IS NULL
	OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
	gender IS NULL
    OR
	age IS NULL
	OR
    category IS NULL
	OR
    quantiy IS NULL
	OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
	OR
	total_sale IS NULL;

-- Deleting the records that has null values
DELETE FROM retail_sales
WHERE sale_date IS NULL
	OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
	gender IS NULL
    OR
	age IS NULL
	OR
    category IS NULL
	OR
    quantiy IS NULL
	OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration
-- How many sales are present in total?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many unique customer are present?
SELECT COUNT(DISTINCT customer_id) AS customers FROM retail_sales;

-- How many unique categories are there?
SELECT COUNT(DISTINCT category) AS catetory FROM retail_sales;

-- Checking for dintinct categories
SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

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

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 and more in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing' AND 
	sale_date BETWEEN '2022-11-01' AND '2022-11-30' AND
    quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, COUNT(*) AS no_of_sales, SUM(total_sale) AS net_sale FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, round(AVG(age), 2) AS avg_age FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(*) AS total_transactions FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, average_sales FROM
(
	SELECT 
		YEAR(sale_date) AS year,
		MONTH(sale_date) AS month,
		ROUND(AVG(total_sale)) AS average_sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS sales_rank
	FROM retail_sales
	GROUP BY year, month
) AS t1
WHERE sales_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	customer_id,
    SUM(total_sale) AS net_total
FROM retail_sales
GROUP BY customer_id
ORDER BY net_total DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
    COUNT(DISTINCT customer_id) AS no_of_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH shift_sales AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
)
SELECT
	shift,
    COUNT(*) AS sales_per_shift
FROM shift_sales
GROUP BY shift
ORDER BY sales_per_shift;


-- End of project