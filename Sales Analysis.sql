
CREATE TABLE sales_data (
    Order_Date DATE,
    Order_ID VARCHAR(10) PRIMARY KEY,
    City VARCHAR(50),
    Region VARCHAR(50),
    Category VARCHAR(50),
    Product VARCHAR(50),
    Sales_Channel VARCHAR(50),
    Quantity INT,
    Unit_Price NUMERIC(10,2),
    Revenue NUMERIC(12,2),
    Discount_Percent INT
);
--Task 1: Basic SQL Questions
--1. Display all records from the sales_data table.
SELECT * FROM sales_data;
--2. Count the total number of records.
SELECT COUNT(*) FROM sales_data;
--3.Display only the Order_ID, City, Product, and Revenue columns.
SELECT order_id,city,product,revenue FROM sales_data;
--4.Find all unique cities in the dataset.
SELECT DISTINCT city FROM sales_data;
--5.Display all orders where the revenue is greater than ₹50,000.
SELECT * FROM sales_data
WHERE revenue > 50000;
--6.Find all sales made in Mumbai.
SELECT * FROM sales_data
WHERE city = 'Mumbai';
--7.Display all products in the Electronics category.
SELECT * FROM sales_data
WHERE category = 'Electronics';
--8. Find orders where the discount is greater than 5%.
SELECT * FROM sales_data
WHERE discount_percent > 5;

SELECT * FROM sales_data;
--Task 2: Aggregate Functions
--9. Calculate the total revenue.
SELECT SUM(revenue) AS total_revenue FROM sales_data;
--10. Calculate the total quantity sold.
SELECT SUM(quantity) AS total_quantity FROM sales_data;
--11. Find the average revenue per order.
SELECT AVG(revenue) AS avg_revenue FROM sales_data;
--12. Find the highest revenue from a single order.
SELECT MAX(revenue) AS highest_revenue FROM sales_data;
--13. Find the lowest revenue from a single order.
SELECT MIN(revenue) AS lowest_revenue FROM sales_data;
--14. Count the total number of orders.
SELECT COUNT(order_id) AS total_order FROM sales_data;
--15. Calculate the average discount percentage
SELECT AVG(discount_percent) AS avg_disc_percentage FROM sales_data;
--Task 3: GROUP BY and ORDER BY
-- 16. Calculate total revenue by city.
SELECT city,SUM(revenue) 
AS total_revenue FROM sales_data
GROUP BY city;
-- 17. Calculate total revenue by region.
SELECT region,SUM(revenue) 
AS total_revenue FROM sales_data
GROUP BY region;
-- 18. Calculate total revenue by product.
SELECT product,SUM(revenue) 
AS total_revenue FROM sales_data
GROUP BY product;
-- 19. Calculate total quantity sold by product.
SELECT product,SUM(quantity) 
AS total_quantity FROM sales_data
GROUP BY product;
-- 20. Calculate total revenue by category.
SELECT category,SUM(revenue) 
AS total_revenue FROM sales_data
GROUP BY category;
-- 21. Calculate total revenue by sales channel (Online vs Store).
SELECT sales_channel,SUM(revenue) 
AS total_revenue FROM sales_data
GROUP BY sales_channel;

SELECT * FROM sales_data;
-- 22. Display products in descending order of total revenue.
SELECT product,SUM(revenue) 
AS total_revenue FROM sales_data
GROUP BY product
ORDER BY total_revenue DESC;
-- 23. Find the number of orders in each city.
SELECT city,COUNT(order_id) 
AS total_orders FROM sales_data
GROUP BY city
ORDER BY total_orders DESC;

-- Task 4: Date-Based Analysis
-- 24. Calculate total revenue by month.

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;
-- 25. Find the highest-revenue order date.
SELECT
    order_date,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY order_date
ORDER BY total_revenue DESC
LIMIT 1;

SELECT * FROM sales_data;
-- 26. Find the total revenue for January 2026.
SELECT SUM(revenue) AS total_revenue
FROM sales_data
WHERE order_date >= '2026-01-01'
  AND order_date < '2026-02-01';

-- 27. Count the number of orders in each month.

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(order_id) AS total_orders
FROM sales_data
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;


-- 28. Display all orders placed after February 1, 2026.
SELECT *
FROM sales_data
WHERE order_date > '2026-02-01'
ORDER BY order_date;

-- Task 5: HAVING and Business Questions
-- 29. Find cities with total revenue greater than ₹1,00,000.
SELECT 
    city,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY city
HAVING SUM(revenue) > 100000
ORDER BY total_revenue DESC;
-- 30. Find products with total quantity sold greater than 10.
SELECT
    product,
    SUM(quantity) AS total_quantity_sold
FROM sales_data
GROUP BY product
HAVING SUM(quantity) > 10
ORDER BY total_quantity_sold DESC;
-- 31. Find categories with average revenue greater than ₹20,000.
SELECT
    category,
    AVG(revenue) AS average_revenue
FROM sales_data
GROUP BY category
HAVING AVG(revenue) > 20000
ORDER BY average_revenue DESC;
-- 32. Find sales channels with more than 10 orders.
SELECT
    sales_channel,
    COUNT(order_id) AS total_orders
FROM sales_data
GROUP BY sales_channel
HAVING COUNT(order_id) > 10
ORDER BY total_orders DESC;

-- 33. Identify the top 5 orders by revenue.
SELECT
    order_id,
    city,
    product,
    revenue
FROM sales_data
ORDER BY revenue DESC
LIMIT 5;

-- 34. Rank products by total revenue using RANK().
SELECT
    product,
    SUM(revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM sales_data
GROUP BY product
ORDER BY revenue_rank;

-- 35. Calculate running total revenue by order date.
SELECT
    order_date,
    order_id,
    revenue,
    SUM(revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM sales_data
ORDER BY order_date, order_id;

-- 36. Find each city's percentage contribution to total revenue.
SELECT
    city,
    SUM(revenue) AS city_revenue,
    ROUND(
        SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (),
        2
    ) AS revenue_percentage
FROM sales_data
GROUP BY city
ORDER BY revenue_percentage DESC;
-- 37. Use a CTE to find the top 3 cities by revenue.
WITH CityRevenue AS (
    SELECT
        city,
        SUM(revenue) AS total_revenue
    FROM sales_data
    GROUP BY city
)
SELECT
    city,
    total_revenue
FROM CityRevenue
ORDER BY total_revenue DESC
LIMIT 3;

-- 38. Use a CASE statement to classify orders as High, Medium, or Low Revenue.
SELECT
    order_id,
    city,
    product,
    revenue,
    CASE
        WHEN revenue >= 50000 THEN 'High Revenue'
        WHEN revenue >= 20000 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_category
FROM sales_data
ORDER BY revenue DESC;
-- 39. Find orders with revenue above the overall average revenue.
SELECT
    order_id,
    order_date,
    city,
    product,
    revenue
FROM sales_data
WHERE revenue > (
    SELECT AVG(revenue)
    FROM sales_data
)
ORDER BY revenue DESC;

--Q40. Total revenue, quantity, and order count by region
SELECT region,
    SUM(revenue) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(order_id) AS total_orders
FROM sales_data
GROUP BY region
ORDER BY total_revenue DESC;

--Q41. Product-wise revenue and quantity
SELECT product,
    SUM(revenue) AS total_revenue,
    SUM(quantity) AS total_quantity
FROM sales_data
GROUP BY product
ORDER BY total_revenue DESC;

--Q42. Monthly revenue for a trend chart
SELECT
    DATE_TRUNC('month', order_date)::DATE AS sales_month,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY sales_month;

--Q43. Revenue by sales channel
SELECT
    sales_channel,
    SUM(revenue) AS total_revenue,
    COUNT(order_id) AS total_orders
FROM sales_data
GROUP BY sales_channel
ORDER BY total_revenue DESC;

--Q44. Top 5 products by revenue
SELECT
    product,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY product
ORDER BY total_revenue DESC
LIMIT 5;


