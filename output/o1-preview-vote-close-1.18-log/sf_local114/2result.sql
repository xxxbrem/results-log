WITH region_totals AS (
    SELECT
        r."id" AS "region_id",
        r."name" AS "Region",
        COUNT(o."id") AS "Number_of_Orders",
        SUM(o."total_amt_usd") AS "Total_Sales_Amount"
    FROM
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ORDERS" o
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ACCOUNTS" a ON o."account_id" = a."id"
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_SALES_REPS" sr ON a."sales_rep_id" = sr."id"
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_REGION" r ON sr."region_id" = r."id"
    GROUP BY
        r."id", r."name"
),
sales_rep_totals AS (
    SELECT
        r."id" AS "region_id",
        sr."id" AS "sales_rep_id",
        sr."name" AS "Sales_Rep_Name",
        SUM(o."total_amt_usd") AS "Sales_Rep_Total_Sales"
    FROM
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ORDERS" o
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ACCOUNTS" a ON o."account_id" = a."id"
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_SALES_REPS" sr ON a."sales_rep_id" = sr."id"
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_REGION" r ON sr."region_id" = r."id"
    GROUP BY
        r."id", sr."id", sr."name"
),
top_sales_reps AS (
    SELECT
        "region_id",
        "Sales_Rep_Name",
        "Sales_Rep_Total_Sales",
        ROW_NUMBER() OVER (PARTITION BY "region_id" ORDER BY "Sales_Rep_Total_Sales" DESC NULLS LAST) AS "rn"
    FROM sales_rep_totals
    WHERE "Sales_Rep_Total_Sales" IS NOT NULL
)
SELECT
    rt."Region",
    rt."Number_of_Orders",
    ROUND(rt."Total_Sales_Amount", 4) AS "Total_Sales_Amount",
    tsr."Sales_Rep_Name" AS "Top_Sales_Rep_Name",
    ROUND(tsr."Sales_Rep_Total_Sales", 4) AS "Top_Sales_Amount"
FROM region_totals rt
JOIN top_sales_reps tsr ON rt."region_id" = tsr."region_id" AND tsr."rn" = 1
ORDER BY rt."Region";