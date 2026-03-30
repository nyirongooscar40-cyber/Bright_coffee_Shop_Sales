-- I want to see my sample table
SELECT * 
FROM workspace.default.bright_coffee_shop
LIMIT 20;



-----------------------------------------------
--1. Checking the date range
-----------------------------------------------
-- They started collecting the data in 2023 1st of January
select min(transaction_date) AS min_date 
FROM workspace.default.bright_coffee_shop;




--They last collected data in 2023 30th of June
select max(transaction_date) AS max_date 
FROM workspace.default.bright_coffee_shop;




--The Duration of the data is 6 months

--------------------------------------------------------
--2. Checking How many stores are there and their names
--------------------------------------------------------
-- We have 3 stores and their names are: Lower Manhattan, Hell's Kitchen and Astoria
select distinct store_location
FROM workspace.default.bright_coffee_shop;




--------------------------------------------------------
--3. What are the items being sold at the stores
--------------------------------------------------------
--There are 9 product categorys being sold which are
SELECT DISTINCT product_category
FROM workspace.default.bright_coffee_shop;




-------------------------------------------------------------------------------
--4. The Price ranges of the products sold the highest price and lowest price And which products are those
-------------------------------------------------------------------------------
select Product_category, 
       max (unit_price) AS highest_price
from workspace.default.bright_coffee_shop
GROUP BY Product_category
order by highest_price desc;





--Highest Price is 45 which are COFEE BEANS
select min (unit_price) AS lowest_price
from workspace.default.bright_coffee_shop;




-- Lowest Price is 0.8 Which are FLAVOURS

---------------------------------------------------------------------------------
--5. Understanding the products and the data that is in the table
--------------------------------------------------------------------------------- 
SELECT DISTINCT product_category AS category, 
                product_detail AS product_name
FROM workspace.default.bright_coffee_shop;




---------------------------------------------------------
--6. The Highest sold Product and the total sum of quantity sold
-- The Highest sold Product is Hot Chocolate
-------------------------------------------------------------
SELECT
    product_category,
    product_type,
    product_detail,
    SUM(unit_price) AS total_quantity_sold
FROM bright_coffee_shop
GROUP BY
    product_category,
    product_type,
    product_detail
ORDER BY total_quantity_sold DESC
LIMIT 1;




------------------------------------------------------------------------------
--7 The Lowest sold product and the total sum of quantity sold
--The Lowest sold Product is Dark chocolate,Drinking chocolate
------------------------------------------------------------------------------
SELECT
    product_category,
    product_type,
    product_detail,
    SUM(unit_price) AS total_quantity_sold
FROM bright_coffee_shop
GROUP BY
    product_category,
    product_type,
    product_detail
ORDER BY total_quantity_sold ASC
LIMIT 1;




-------------------------------------------------------------------------------------------
--8. Confirming which products were the most sold to the least sold within the six months
-------------------------------------------------------------------------------------------
SELECT
    product_category,
    product_type,
    product_detail,
    SUM(unit_price) AS total_quantity_sold
FROM bright_coffee_shop
GROUP BY product_category, product_type, product_detail
ORDER BY total_quantity_sold DESC;




---------------------------------------------------------------------------------------------------
--9. Fully understanding how many rows does my data have,number of products, sales and the stores.
---------------------------------------------------------------------------------------------------
SELECT COUNT(*) AS number_of_rows,
       COUNT(DISTINCT transaction_id) AS number_of_sales,
       COUNT(DISTINCT store_id) AS number_of_stores,
       COUNT(DISTINCT product_id) AS number_of_products
       FROM bright_coffee_shop;



-----------------------------------------------------------------------------------------------

SELECT transaction_id,
       transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) As Month_name,
       transaction_qty*unit_price AS Revenue_per_transaction
       FROM bright_coffee_shop;



-----------------------------------------------------------------------------------------

SELECT
       --Dates
       transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) As Month_name,
       dayofmonth(transaction_date) AS Day_of_month,

       CASE
           WHEN DAYNAME(transaction_date) IN ('SUN','SAT') THEN 'Weekend'
           ELSE 'Weekday'
           END AS day_classification,
       
       --date_format(transaction_time, 'HH:mm:ss') AS purchase_time,
       CASE
           WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
           WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
           When date_format(transaction_time,'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
           END AS time_buckets,

       --Counts Of ID'S
       COUNT (DISTINCT transaction_id) AS Number_of_sales,
       COUNT (DISTINCT product_id) AS Number_of_products,
       COUNT (DISTINCT store_id) AS Number_of_stores,

       --Revenue
       SUM(transaction_qty*unit_price) AS Revenue_per_day,

       CASE
           WHEN SUM(transaction_qty*unit_price) <=50 THEN '01. Low Spend'
           WHEN SUM(transaction_qty*unit_price) BETWEEN 51 AND 100 THEN '02. Medium Spend'
           ELSE '03. High Spend'
           END AS spend_bucket,
           
      --Categorical columns
       store_location,
       product_category,
       product_type,
       product_detail

       FROM workspace.default.bright_coffee_shop
       GROUP BY transaction_date,
                Dayname(transaction_date),
                Monthname(transaction_date),
                Dayofmonth(transaction_date),

                CASE 
                     WHEN DAYNAME(transaction_date) IN ('SUN','SAT') THEN 'Weekend'
                     ELSE 'Weekday'
                END,

                CASE 
                    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
                    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
                    When date_format(transaction_time,'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
                END,

                store_location,
                product_category,
                product_detail,
                product_type;

-----------------------------------------------------------------------------------------------------------------

