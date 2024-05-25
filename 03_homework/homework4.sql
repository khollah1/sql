--Coalesce ---
SELECT 
product_name || ', ' || coalesce(Product_size,'')|| ' (' || coalesce(product_qty_type,"Unit") || ')'
FROM product;


--Windowed Function --

SELECT row_number() OVER(PARTITION BY Names order by market_date ASC) as [row_number],Names, market_date
FROM (
SELECT customer_first_name||" "|| customer_last_name AS Names, market_date
FROM
customer_purchases cp
JOIN customer c ON cp.customer_id = c.customer_id)x;

SELECT dense_rank() OVER(PARTITION BY Names order by market_date ASC) as [row_number],Names, market_date
FROM (
SELECT customer_first_name||" "|| customer_last_name AS Names, market_date
FROM
customer_purchases cp
JOIN customer c ON cp.customer_id = c.customer_id)x;


---ROW NUMBER----
SELECT *
FROM (

SELECT row_number() OVER(PARTITION BY Names order by market_date DESC) AS My_Cust_rank,Names, market_date
FROM (
SELECT customer_first_name||" "|| customer_last_name AS Names, market_date
FROM
customer_purchases cp
JOIN customer c ON cp.customer_id = c.customer_id)
)
WHERE My_Cust_rank = 1;

----DENSE RANK-----
SELECT *
FROM (

SELECT dense_rank() OVER(PARTITION BY Names order by market_date DESC) AS My_Cust_rank, Names, market_date
FROM (
SELECT customer_first_name||" "|| customer_last_name AS Names, market_date
FROM
customer_purchases cp
JOIN customer c ON cp.customer_id = c.customer_id)
)

where My_Cust_rank = 1;

SELECT row_number() OVER(PARTITION BY Cust_names order by prod_id asc) AS Pur_Cxt, COUNT(*),Cust_names, prod_id, product_name
FROM
(
SELECT
customer_first_name||" "|| customer_last_name AS Cust_names, p.product_id AS prod_id, product_name
FROM
customer_purchases cp
JOIN customer C on cp.customer_id = c.customer_id
JOIN product P on cp.product_id = p.product_id
)
GROUP BY Cust_names, prod_id, product_name

---STRING MANIPULATION-----
SELECT product_name, rtrim(LTRIM(substr(product_name, instr(product_name,'-') +1)))as Description
FROM
product;

SELECT rank() OVER(PARTITION BY Sales order by market_date DESC) Mkt_rnk, market_date, sales
FROM
(
SELECT market_date, sum((quantity * cost_to_customer_per_qty)) AS Sales
FROM 
customer_purchases
group by market_date
order by market_date)


---UNION---
Select * from 
(
SELECT market_date, sales, "Best Day" as Status
FROM
(
SELECT market_date, sales,min(MKT_RNK)
from (
SELECT *, rank() OVER(order by Sales DESC) Mkt_rnk
FROM
(SELECT market_date, round(sum((quantity * cost_to_customer_per_qty)),0) AS Sales
FROM 
customer_purchases
group by market_date
)
)
)

UNION

SELECT market_date, sales, "Worst Day" as Status
FROM
(
SELECT market_date, sales,Max(MKT_RNK)
from (
SELECT *, rank() OVER(order by Sales DESC) Mkt_rnk
FROM
(SELECT market_date, round(sum((quantity * cost_to_customer_per_qty)),0) AS Sales
FROM 
customer_purchases
group by market_date
)
)
)
)




