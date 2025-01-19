SELECT
  "Tier",
  ROUND(MAX(profit), 4) AS "Highest_Profit",
  ROUND(MIN(profit), 4) AS "Lowest_Profit"
FROM (
  SELECT
    NTILE(10) OVER (ORDER BY profit DESC NULLS LAST) AS "Tier",
    profit
  FROM (
    SELECT
      s."cust_id",
      ROUND(s."amount_sold" - cst."unit_cost" * s."quantity_sold", 4) AS profit
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."SALES" s
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."CUSTOMERS" c ON s."cust_id" = c."cust_id"
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COUNTRIES" co ON c."country_id" = co."country_id"
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."TIMES" t ON s."time_id" = t."time_id"
    JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COSTS" cst ON s."prod_id" = cst."prod_id" AND s."time_id" = cst."time_id"
    WHERE co."country_name" = 'Italy'
      AND t."calendar_year" = 2021
      AND t."calendar_month_number" = 12
      AND s."amount_sold" IS NOT NULL
      AND cst."unit_cost" IS NOT NULL
  ) profit_data
  WHERE profit IS NOT NULL
) tiered_profits
GROUP BY "Tier"
ORDER BY "Tier";