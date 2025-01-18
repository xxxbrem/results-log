WITH customer_profits AS (
  SELECT c."cust_id",
         SUM(s."amount_sold" - (cs."unit_cost" * s."quantity_sold")) AS total_profit
  FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."SALES" s
  JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."CUSTOMERS" c ON s."cust_id" = c."cust_id"
  JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COUNTRIES" co ON c."country_id" = co."country_id"
  JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."TIMES" t ON s."time_id" = t."time_id"
  JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COSTS" cs ON s."prod_id" = cs."prod_id" AND s."time_id" = cs."time_id"
  WHERE co."country_name" = 'Italy'
    AND t."calendar_month_number" = 12
    AND t."calendar_year" = 2021
  GROUP BY c."cust_id"
)
SELECT "Tier",
       MAX(ROUND(total_profit, 4)) AS "Highest_Profit",
       MIN(ROUND(total_profit, 4)) AS "Lowest_Profit"
FROM (
  SELECT cp."cust_id", cp.total_profit,
         NTILE(10) OVER (ORDER BY total_profit DESC NULLS LAST) AS "Tier"
  FROM customer_profits cp
) ranked_customers
GROUP BY "Tier"
ORDER BY "Tier";