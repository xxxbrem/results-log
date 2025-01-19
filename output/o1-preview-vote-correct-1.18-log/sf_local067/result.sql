WITH italy_country_id AS (
    SELECT "country_id"
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.COUNTRIES
    WHERE "country_name" = 'Italy'
), italian_customers AS (
    SELECT C."cust_id"
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.CUSTOMERS C
    JOIN italy_country_id IC ON C."country_id" = IC."country_id"
), times_dec2021 AS (
    SELECT "time_id"
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.TIMES
    WHERE "calendar_month_number" = 12 AND "calendar_year" = 2021
), italian_sales_dec2021 AS (
    SELECT S.*
    FROM COMPLEX_ORACLE.COMPLEX_ORACLE.SALES S
    JOIN italian_customers IC ON S."cust_id" = IC."cust_id"
    JOIN times_dec2021 T ON S."time_id" = T."time_id"
), sales_with_costs AS (
    SELECT S.*, C."unit_cost"
    FROM italian_sales_dec2021 S
    LEFT JOIN COMPLEX_ORACLE.COMPLEX_ORACLE.COSTS C
        ON S."prod_id" = C."prod_id" AND S."time_id" = C."time_id"
), sales_with_profit AS (
    SELECT S.*, ROUND(S."amount_sold" - COALESCE(S."unit_cost", 0) * S."quantity_sold", 4) as profit
    FROM sales_with_costs S
), customer_profits AS (
    SELECT S."cust_id", ROUND(SUM(S.profit), 4) as total_profit
    FROM sales_with_profit S
    GROUP BY S."cust_id"
), customer_profits_with_tier AS (
    SELECT CP.*,
        NTILE(10) OVER (ORDER BY CP.total_profit DESC NULLS LAST) as Tier
    FROM customer_profits CP
)
SELECT 
    CPWT.Tier,
    ROUND(MAX(CPWT.total_profit), 4) as Highest_Profit,
    ROUND(MIN(CPWT.total_profit), 4) as Lowest_Profit
FROM customer_profits_with_tier CPWT
GROUP BY CPWT.Tier
ORDER BY CPWT.Tier;