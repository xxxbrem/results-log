WITH Italian_Customers AS (
  SELECT CUST."cust_id"
  FROM COMPLEX_ORACLE.COMPLEX_ORACLE.CUSTOMERS CUST
  JOIN COMPLEX_ORACLE.COMPLEX_ORACLE.COUNTRIES COU
    ON CUST."country_id" = COU."country_id"
  WHERE COU."country_name" = 'Italy'
),
December2021_Sales AS (
  SELECT S.*
  FROM COMPLEX_ORACLE.COMPLEX_ORACLE.SALES S
  JOIN COMPLEX_ORACLE.COMPLEX_ORACLE.TIMES T
    ON S."time_id" = T."time_id"
  WHERE T."calendar_year" = 2021
    AND T."calendar_month_number" = 12
),
Sales_To_Italian_Customers AS (
  SELECT S.*
  FROM December2021_Sales S
  JOIN Italian_Customers IC
    ON S."cust_id" = IC."cust_id"
),
Sales_With_Cost AS (
  SELECT S.*, C."unit_cost"
  FROM Sales_To_Italian_Customers S
  JOIN COMPLEX_ORACLE.COMPLEX_ORACLE.COSTS C
    ON S."prod_id" = C."prod_id"
    AND S."time_id" = C."time_id"
    AND S."promo_id" = C."promo_id"
    AND S."channel_id" = C."channel_id"
),
Customer_Profits AS (
  SELECT S."cust_id",
         SUM(S."amount_sold" - (S."quantity_sold" * S."unit_cost")) AS "total_profit"
  FROM Sales_With_Cost S
  GROUP BY S."cust_id"
),
Ranked_Customers AS (
  SELECT "cust_id",
         "total_profit",
         NTILE(10) OVER (ORDER BY "total_profit" DESC NULLS LAST) AS "Tier"
  FROM Customer_Profits
)
SELECT "Tier",
       ROUND(MIN("total_profit"), 4) AS "Lowest_Profit",
       ROUND(MAX("total_profit"), 4) AS "Highest_Profit"
FROM Ranked_Customers
GROUP BY "Tier"
ORDER BY "Tier";