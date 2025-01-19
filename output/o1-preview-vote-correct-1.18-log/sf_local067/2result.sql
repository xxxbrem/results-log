WITH Italian_Customers AS (
    SELECT c."cust_id"
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.CUSTOMERS c
    JOIN COMPLEX_ORACLE.COMPLEX_ORACLE.COUNTRIES co ON c."country_id" = co."country_id"
    WHERE co."country_name" ILIKE '%Italy%'
),
December2021Sales AS (
    SELECT s.*
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.SALES s
    JOIN COMPLEX_ORACLE.COMPLEX_ORACLE.TIMES t ON s."time_id" = t."time_id"
    WHERE t."calendar_year" = 2021 AND t."calendar_month_number" = 12
),
Italian_December2021Sales AS (
    SELECT s.*
    FROM December2021Sales s
    JOIN Italian_Customers ic ON s."cust_id" = ic."cust_id"
),
Avg_Costs AS (
    SELECT
        "prod_id",
        AVG("unit_cost") AS "avg_unit_cost"
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.COSTS
    GROUP BY "prod_id"
),
Sales_With_Profit AS (
    SELECT
        s."cust_id",
        s."prod_id",
        s."quantity_sold",
        s."amount_sold",
        ac."avg_unit_cost",
        (s."amount_sold" - s."quantity_sold" * ac."avg_unit_cost") AS "profit"
    FROM Italian_December2021Sales s
    LEFT JOIN Avg_Costs ac ON s."prod_id" = ac."prod_id"
),
Customer_Profit AS (
    SELECT
        s."cust_id",
        SUM(COALESCE(s."profit", 0)) AS "total_profit"
    FROM Sales_With_Profit s
    GROUP BY s."cust_id"
),
Customer_Tiers AS (
    SELECT
        cp."cust_id",
        cp."total_profit",
        NTILE(10) OVER (ORDER BY cp."total_profit" DESC NULLS LAST) AS "profit_tier"
    FROM Customer_Profit cp
)
SELECT
    "profit_tier" AS "Profit_Tier",
    ROUND(MIN("total_profit"), 4) AS "Lowest_Profit",
    ROUND(MAX("total_profit"), 4) AS "Highest_Profit"
FROM Customer_Tiers
GROUP BY "profit_tier"
ORDER BY "profit_tier";