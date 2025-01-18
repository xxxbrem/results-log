WITH cte_avg_costs AS (
    SELECT
        "prod_id",
        ROUND(AVG("unit_cost"), 4) AS "avg_unit_cost"
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COSTS"
    GROUP BY "prod_id"
),
cte_sales AS (
    SELECT
        s."cust_id",
        s."prod_id",
        s."quantity_sold",
        s."amount_sold",
        s."time_id",
        c."avg_unit_cost" AS "unit_cost",
        ROUND(s."amount_sold" - (s."quantity_sold" * c."avg_unit_cost"), 4) AS "profit"
    FROM "COMPLEX_ORACLE"."COMPLEX_ORACLE"."SALES" s
    INNER JOIN cte_avg_costs c
        ON s."prod_id" = c."prod_id"
    WHERE s."time_id" BETWEEN '2021-12-01' AND '2021-12-31'
),
cte_italian_customers AS (
    SELECT
        s."cust_id",
        s."profit"
    FROM cte_sales s
    INNER JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."CUSTOMERS" cu
        ON s."cust_id" = cu."cust_id"
    INNER JOIN "COMPLEX_ORACLE"."COMPLEX_ORACLE"."COUNTRIES" co
        ON cu."country_id" = co."country_id"
    WHERE co."country_name" = 'Italy'
),
cte_customer_profits AS (
    SELECT
        "cust_id",
        ROUND(SUM("profit"), 4) AS "total_profit"
    FROM cte_italian_customers
    GROUP BY "cust_id"
),
cte_deciles AS (
    SELECT
        "cust_id",
        "total_profit",
        NTILE(10) OVER (ORDER BY "total_profit") AS "Tier"
    FROM cte_customer_profits
)
SELECT 
    "Tier",
    CONCAT((("Tier" - 1) * 10), '% - ', ("Tier" * 10), '%') AS "Profit_Percentile_Range",
    ROUND(MIN("total_profit"), 4) AS "Lowest_Profit",
    ROUND(MAX("total_profit"), 4) AS "Highest_Profit"
FROM cte_deciles
GROUP BY "Tier"
ORDER BY "Tier";