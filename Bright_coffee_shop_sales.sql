select * from `bright_coffe`.`default`.`bright_coffee_shop_sales_1`;


SELECT
     -- Date & Time
     transaction_date,
     transaction_time,

     -- Derived Time Features
     EXTRACT(HOUR FROM transaction_time) AS hour,
     DAYNAME(transaction_date) AS day_name,

     CASE 
     WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekend'
     ELSE 'Weekday'
     END AS day_type,

     --Time of Day Buckets
     CASE 
     WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
     WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 18 AND 23 THEN 'Evening'
     ELSE 'Night'
     END AS time_of_day,

     -- Product Info
     product_category,
     product_type,
     product_detail,

     -- Metrics
     SUM(transaction_qty) AS total_quantity,
     SUM(unit_price * transaction_qty) AS total_revenue,
     COUNT(transaction_id) AS total_transactions

     FROM bright_coffe.default.bright_coffee_shop_sales_1

     GROUP BY
     transaction_date,
     transaction_time,
     hour,
     day_name,
     day_type,
     time_of_day,
     product_category,
     product_type,
     product_detail
     ORDER BY transaction_date, hour;
