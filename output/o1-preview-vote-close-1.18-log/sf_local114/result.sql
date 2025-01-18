WITH "rep_sales" AS (
   SELECT
       S."id" AS "sales_rep_id",
       S."name" AS "sales_rep_name",
       R."name" AS "region_name",
       SUM(O."total_amt_usd") AS "sales_rep_total"
   FROM
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ORDERS" O
   JOIN
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ACCOUNTS" A ON O."account_id" = A."id"
   JOIN
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_SALES_REPS" S ON A."sales_rep_id" = S."id"
   JOIN
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_REGION" R ON S."region_id" = R."id"
   GROUP BY
       S."id", S."name", R."name"
),
"region_orders" AS (
   SELECT
       R."name" AS "region_name",
       COUNT(DISTINCT O."id") AS "num_orders",
       SUM(O."total_amt_usd") AS "total_sales_amount"
   FROM
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ORDERS" O
   JOIN
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_ACCOUNTS" A ON O."account_id" = A."id"
   JOIN
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_SALES_REPS" S ON A."sales_rep_id" = S."id"
   JOIN
       "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."WEB_REGION" R ON S."region_id" = R."id"
   GROUP BY
       R."name"
),
"top_rep" AS (
   SELECT
       "region_name",
       "sales_rep_name",
       "sales_rep_total",
       ROW_NUMBER() OVER (PARTITION BY "region_name" ORDER BY "sales_rep_total" DESC NULLS LAST) AS "rn"
   FROM
       "rep_sales"
)
SELECT
   ro."region_name" AS "Region",
   ro."num_orders" AS "Number_of_Orders",
   ROUND(ro."total_sales_amount", 4) AS "Total_Sales_Amount",
   tr."sales_rep_name" AS "Top_Sales_Rep_Name",
   ROUND(tr."sales_rep_total", 4) AS "Top_Sales_Amount"
FROM
   "region_orders" ro
JOIN
   (
       SELECT "region_name", "sales_rep_name", "sales_rep_total"
       FROM "top_rep"
       WHERE "rn" = 1
   ) tr ON ro."region_name" = tr."region_name"
ORDER BY
   ro."region_name" ASC NULLS LAST;