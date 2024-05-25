
---CROSS JOIN---
SELECT 
    DISTINCT VI.vendor_id ,VI.product_id,vendor_name,product_name,(original_price * 5) AS Orig_Price
    FROM 
    vendor_inventory VI
JOIN 
    vendor V ON VI.vendor_id = V.vendor_id
JOIN 
    product P ON VI.product_id = P.product_id
CROSS JOIN 
    (SELECT DISTINCT customer_id, product_id, vendor_id
     FROM customer_purchases) AS CP;

---INSERT---
create temp table product_units AS
SELECT *,CURRENT_TIMESTAMP AS snapshot_timestamp
FROM product
where product_qty_type = "unit";

INSERT INTO product_units
VALUES(24,'Apple Pie','Small',4,'unit',CURRENT_TIMESTAMP)

--SELECT * FROM product_units where product_name = 'Apple Pie'

DELETE from product_units
WHERE product_id = 7;

ALTER TABLE product_units
ADD current_quantity INT;

UPDATE product_units
SET current_quantity = COALESCE((
SELECT quantity
FROM (
SELECT product_id, quantity, RANK() OVER(PARTITION BY product_id ORDER BY market_date DESC) AS Mkt_rnk
FROM vendor_inventory
) AS X
WHERE X.product_id = product_units.product_id
AND X.mkt_rnk = 1
), 0);

Select * from product_units




