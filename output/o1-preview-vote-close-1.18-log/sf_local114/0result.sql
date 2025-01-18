WITH order_data AS (
    SELECT
        WO."id" AS "order_id",
        WO."account_id",
        WO."total_amt_usd",
        WA."sales_rep_id",
        WSR."name" AS "sales_rep_name",
        WSR."region_id",
        WR."name" AS "region_name"
    FROM 
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.WEB_ORDERS WO
    JOIN 
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.WEB_ACCOUNTS WA
        ON WO."account_id" = WA."id"
    JOIN 
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.WEB_SALES_REPS WSR
        ON WA."sales_rep_id" = WSR."id"
    JOIN
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.WEB_REGION WR
        ON WSR."region_id" = WR."id"
),
sales_rep_sales AS (
    SELECT
        "region_id",
        "region_name",
        "sales_rep_id",
        "sales_rep_name",
        SUM("total_amt_usd") AS "sales_rep_total_sales"
    FROM order_data
    GROUP BY
        "region_id",
        "region_name",
        "sales_rep_id",
        "sales_rep_name"
),
top_sales_reps AS (
    SELECT
        "region_id",
        "region_name",
        "sales_rep_id",
        "sales_rep_name",
        "sales_rep_total_sales",
        ROW_NUMBER() OVER (
            PARTITION BY "region_id"
            ORDER BY "sales_rep_total_sales" DESC NULLS LAST
        ) AS "sales_rep_rank"
    FROM sales_rep_sales
),
region_sales AS (
    SELECT
        "region_id",
        "region_name",
        COUNT(*) AS "Number_of_Orders",
        SUM("total_amt_usd") AS "Total_Sales_Amount"
    FROM order_data
    GROUP BY
        "region_id",
        "region_name"
)
SELECT
    RS."region_name" AS "Region",
    RS."Number_of_Orders",
    ROUND(RS."Total_Sales_Amount", 4) AS "Total_Sales_Amount",
    TSR."sales_rep_name" AS "Top_Sales_Rep_Name",
    ROUND(TSR."sales_rep_total_sales", 4) AS "Top_Sales_Rep_Sales_Amount"
FROM
    region_sales RS
LEFT JOIN
    top_sales_reps TSR
    ON RS."region_id" = TSR."region_id" AND TSR."sales_rep_rank" = 1
ORDER BY
    RS."region_name";