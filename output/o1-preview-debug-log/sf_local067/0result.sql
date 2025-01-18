WITH Italian_Customers AS (
  SELECT c."cust_id"
  FROM COMPLEX_ORACLE.COMPLEX_ORACLE."CUSTOMERS" c
  JOIN COMPLEX_ORACLE.COMPLEX_ORACLE."COUNTRIES" co ON c."country_id" = co."country_id"
  WHERE co."country_name" = 'Italy'
),
December_2021_Sales AS (
  SELECT s.*
  FROM COMPLEX_ORACLE.COMPLEX_ORACLE."SALES" s
  JOIN COMPLEX_ORACLE.COMPLEX_ORACLE."TIMES" t ON s."time_id" = t."time_id"
  WHERE t."calendar_year" = 2021 AND t."calendar_month_number" = 12
),
Sales_To_Italian_Customers AS (
  SELECT s.*
  FROM December_2021_Sales s
  WHERE s."cust_id" IN (SELECT "cust_id" FROM Italian_Customers)
),
Sales_With_Cost AS (
  SELECT s."cust_id",
         s."amount_sold",
         s."quantity_sold",
         cst."unit_cost",
         ROUND(s."amount_sold" - (cst."unit_cost" * s."quantity_sold"), 4) AS "profit"
  FROM Sales_To_Italian_Customers s
  JOIN COMPLEX_ORACLE.COMPLEX_ORACLE."COSTS" cst 
    ON s."prod_id" = cst."prod_id" AND s."time_id" = cst."time_id"
),
Total_Profit_Per_Customer AS (
  SELECT "cust_id",
         ROUND(SUM("profit"), 4) AS "total_profit"
  FROM Sales_With_Cost
  GROUP BY "cust_id"
),
Ranked_Customers AS (
  SELECT "cust_id",
         "total_profit",
         NTILE(10) OVER (ORDER BY "total_profit" DESC NULLS LAST) AS "Tier"
  FROM Total_Profit_Per_Customer
)
SELECT "Tier",
       MAX("total_profit") AS "Highest_Profit",
       MIN("total_profit") AS "Lowest_Profit"
FROM Ranked_Customers
GROUP BY "Tier"
ORDER BY "Tier";