WITH Italian_Customers AS (
    SELECT DISTINCT C."cust_id"
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."CUSTOMERS" C
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COUNTRIES" CO
        ON C."country_id" = CO."country_id"
    WHERE CO."country_name" = 'Italy'
),
December2021_Times AS (
    SELECT T."time_id"
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."TIMES" T
    WHERE T."calendar_month_number" = 12 AND T."calendar_year" = 2021
),
Sales_With_Profit AS (
    SELECT S."cust_id",
           SUM(S."amount_sold" - (CS."unit_cost" * S."quantity_sold")) AS "total_profit"
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."SALES" S
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COSTS" CS
        ON S."prod_id" = CS."prod_id"
       AND S."time_id" = CS."time_id"
       AND S."channel_id" = CS."channel_id"
       AND S."promo_id" = CS."promo_id"
    WHERE S."time_id" IN (SELECT "time_id" FROM December2021_Times)
      AND S."cust_id" IN (SELECT "cust_id" FROM Italian_Customers)
    GROUP BY S."cust_id"
),
Ranked_Customers AS (
    SELECT SWP."cust_id",
           SWP."total_profit",
           NTILE(10) OVER (ORDER BY SWP."total_profit") AS "Tier"
    FROM Sales_With_Profit SWP
)
SELECT "Tier",
       ROUND(MAX("total_profit"), 4) AS "Highest_Profit",
       ROUND(MIN("total_profit"), 4) AS "Lowest_Profit"
FROM Ranked_Customers
GROUP BY "Tier"
ORDER BY "Tier";