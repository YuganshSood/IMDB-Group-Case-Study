use supply_db ;
/*

Question 1: Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.

*/

-- Solution 1:

SELECT p.product_name, p.product_id 
FROM product_info AS p 
INNER JOIN category AS c 
ON 
p.category_id = c.id 
WHERE c.name LIKE '%GOLF%' 
ORDER BY p.product_id; 

-- **********************************************************************************************************************************

/*
Question 2: Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


*/
-- Solution 2

 SELECT p.product_name AS Product_Name, Sum(oi.sales) AS Sales 
 FROM product_info AS p 
 INNER JOIN category AS c 
 ON p.category_id = c.id 
 INNER JOIN ordered_items AS oi
 ON p.product_id = oi.item_id 
 WHERE 
 c.name LIKE '%GOLF%' 
 GROUP BY p.product_name 
 ORDER BY sales 
 DESC LIMIT 10;

-- **********************************************************************************************************************************

/*
Question 3: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders


*/

-- Solution 3

 SELECT ci.segment AS customer_segment, Count(DISTINCT order_id) AS ORDERS 
 FROM 
 orders AS o INNER JOIN customer_info AS ci 
 ON ci.id = o.customer_id 
 GROUP BY ci.segment 
 ORDER BY orders DESC;
 
-- **********************************************************************************************************************************
/*
Question 4: Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/

-- Solution 4

WITH shipping_summary AS 
( 
 SELECT 
 ci.segment AS customer_segment, count(o.order_id) AS orders 
 FROM customer_info AS ci 
 LEFT JOIN orders AS o 
 ON ci.id = o.customer_id 
 WHERE o.real_shipping_days = 6 
 GROUP BY ci.segment 
 ) 
 SELECT a.customer_segment, round(a.orders/sum(b.orders)*100,1) AS percentage_order_split 
 FROM shipping_summary AS a 
 INNER JOIN shipping_summary AS b 
 GROUP BY a.customer_segment 
 ORDER BY percentage_order_split 
 DESC;
 
-- **********************************************************************************************************************************
