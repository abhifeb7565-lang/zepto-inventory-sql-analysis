--create Table and Import the data from csv

create table zepto (
"sku_id" SERIAL PRIMARY KEY,
"category" VARCHAR(120),
"name" VARCHAR(150) NOT NULL,
"mrp" NUMERIC(8,2),
"discountPercent" NUMERIC(5,2),
"availableQuantity" INTEGER,
"discountedSellingPrice" NUMERIC(8,2),
"weightInGms" INTEGER,
"outOfStock" BOOLEAN,	
"quantity" INTEGER
);

-- data exploration 

--count of rows

SELECT COUNT(*) FROM zepto;

--sample data 
SELECT * FROM zepto
LIMIT 10;

-- null values
SELECT * FROM zepto
where "name" IS NULL
OR
 "category" IS NULL
OR
 "mrp" IS NULL
OR
 "discountPercent" IS NULL
OR
 "discountedSellingPrice" IS NULL
OR
 "outOfStock" IS NULL
OR
"quantity" IS NULL;


--diff product category

SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product in stock vs out of stock

SELECT "outOfStock", COUNT(sku_id) FROM zepto
GROUP BY "outOfStock";

--product names present multiple times

SELECT "name" , COUNT(sku_id) as "NUMber of SKU" FROM zepto
GROUP BY "name"
HAVING COUNT(sku_id) >1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING


--PRODUCT WITH PRICE =O

SELECT * FROM zepto
WHERE "mrp" = 0 OR "discountedSellingPrice" = 0;

DELETE FROM zepto 
WHERE "mrp" = 0;



--conver piase into rupess
UPDATE zepto
SET "mrp" = mrp/100.0,
"discountedSellingPrice" = "discountedSellingPrice"/100.0;

SELECT "mrp" , "discountedSellingPrice" FROM zepto 

--Buisness Insights

-- Q1. Find top 10 best-value products based on discoount percentage

SELECT DISTINCT "name" ,"mrp", "discountPercent" FROM zepto
ORDER BY  "discountPercent" DESC
LIMIT 10;

--Q2 What are the products with HIGH MRP  but out of stock

SELECT DISTINCT "name" , "mrp" FROM zepto
WHERE "outOfStock" = TRUE AND "mrp" > 300
ORDER BY "mrp" DESC;

--Q3 calculate total revenue for each category 

SELECT "category"  ,  SUM("discountedSellingPrice"  * "availableQuantity") AS "total_Revenue" FROM zepto
GROUP BY "category"
ORDER BY "total_Revenue";

--Q4 Find all products WHERE MRP is greater than 500 and discount is less than 10%

SELECT  DISTINCT "name" , "mrp"  ,"discountPercent" FROM zepto
WHERE "mrp" > 500 AND "discountPercent" < 10

ORDER BY "mrp" DESC ,"discountPercent" DESC;

--Q5 Identify the top 5 categories offering the highest average discount percentage.

SELECT "category" , ROUND(avg("discountPercent"),2) AS "avgdis" FROM zepto
GROUP BY "category"
ORDER BY "avgdis" DESC
LIMIT 5;

--Q6 Find the price per gram for products above 100gm and sort by best value 

SELECT DISTINCT "name" ,"weightInGms" , "discountedSellingPrice", ROUND("discountedSellingPrice"/"weightInGms",2) AS "price_pergm" FROM zepto
WHERE "weightInGms" >=100
ORDER BY price_pergm;

--Q7. Group the products into categroies like low,medium,Bulk

SELECT DISTINCT "name" ,"weightInGms",
CASE WHEN "weightInGms" <1000 THEN 'Low'
     WHEN "weightInGms" <5000 THEN 'Medium'
   ELSE 'BULK'
   END AS "weight_category"
   FROM zepto ;

--Q8 what is the Total Inventory Weight Per category

SELECT "category" , SUM("weightInGms" * "availableQuantity") AS "Total_inventory-weight" FROM zepto
GROUP BY "category" 
ORDER BY "Total_inventory-weight" DESC;
