DROP TABLE if EXISTS retail_sales

CREATE TABLE [dbo].[retail_sales](
	[transactions_id] [smallint] NOT NULL,
	[sale_date] [date] NOT NULL,
	[sale_time] [time](7) NOT NULL,
	[customer_id] [tinyint] NOT NULL,
	[gender] [nvarchar](50) NOT NULL,
	[age] [tinyint] NULL,
	[category] [nvarchar](50) NOT NULL,
	[quantity] [tinyint] NULL,
	[price_per_unit] [smallint] NULL,
	[cogs] [float] NULL,
	[total_sale] [smallint] NULL
) 

select COUNT(*) FROM dbo.retail_sales
SELECT *  
FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL      -- must match your table definition
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

    EXEC sp_rename 'retail_sales.quantiy', 'quantity', 'COLUMN';

 delete FROM retail_sales
WHERE
transactions_id	 IS NULL
OR
sale_date	IS NULL
OR
sale_time	IS NULL
OR
customer_id	 IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR  
category IS NULL
OR
quantity IS NULL
OR
price_per_unit	 IS NULL
OR
cogs is NULL
OR
total_sale is NULL


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retail_sales';






--Data Analysis

--Q1.  write a query to retrive all data from sales made on '2022-11-05'
SELECT * from retail_sales
WHERE sale_date = '2022-11-05';

--Q2. write a query to retrive all the transaction where the category is  "clothing" and quqntinty sold is more then 10 in the month of november-2022
SELECT * FROM retail_sales
WHERE 
category = 'Clothing' AND 
 YEAR(sale_date) = 2022
  AND 
  MONTH(sale_date) = 11
  AND
quantity >= 4

--Q3. writ a sql query to calculate total sales (total_sales) for each category.
SELECT category , 
SUM(total_sale) AS TotalSales ,
COUNT(*) as TotalOrder FROM
retail_sales 
GROUP BY category

--Q4. write sql query to find the average age of the customers who purchased items from the 'Beauty' category.
SELECT AVG(age) as avg_age FROM 
retail_sales
WHERE category = 'Beauty'

--Q5. write a sql qurey where total sales is greater then 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

--Q6. write a sql query to calculate the avg sale for each month. find out bestbest selling month ineach year
SELECT
YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
avg(total_sale) AS avg_sale
FROM
retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR, avg_sale DESC

WITH MonthlySales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT *
FROM MonthlySales m
WHERE avg_sale = (
    SELECT MAX(avg_sale)
    FROM MonthlySales
    WHERE year = m.year
);

--Q8 write a sql query to find the number of unique customer who purchesed item from each category.
SELECT 
category,
COUNT(distinct customer_id) AS cnt_unique_cs
FROM
retail_sales
GROUP BY category	

--Q9 write a sql query to create each shift and number of order(example Morning <= 12, Afternoon between 12 and 17, evening > 17).
SELECT 
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY shift;

--END OF PROJECT