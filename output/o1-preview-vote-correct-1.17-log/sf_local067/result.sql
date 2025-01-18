WITH customer_profits AS (
    SELECT s."cust_id",
           ROUND(SUM(s."amount_sold" - (s."quantity_sold" * cost."unit_cost")), 4) AS "profit"
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."SALES" s
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."CUSTOMERS" c ON s."cust_id" = c."cust_id"
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COUNTRIES" co ON c."country_id" = co."country_id"
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."TIMES" t ON s."time_id" = t."time_id"
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COSTS" cost
      ON s."prod_id" = cost."prod_id"
     AND s."time_id" = cost."time_id"
     AND s."promo_id" = cost."promo_id"
     AND s."channel_id" = cost."channel_id"
    WHERE co."country_name" = 'Italy'
      AND t."calendar_month_name" = 'December'
      AND t."calendar_year" = 2021
    GROUP BY s."cust_id"
),
customer_profits_with_tier AS (
    SELECT "cust_id",
           "profit",
           NTILE(10) OVER (ORDER BY "profit") AS "tier_number"
    FROM customer_profits
)
SELECT 
    "tier_number",
    MIN("profit") AS "profit_range_lower",
    MAX("profit") AS "profit_range_upper",
    MIN("profit") AS "lowest_profit",
    MAX("profit") AS "highest_profit"
FROM customer_profits_with_tier
GROUP BY "tier_number"
ORDER BY "tier_number";