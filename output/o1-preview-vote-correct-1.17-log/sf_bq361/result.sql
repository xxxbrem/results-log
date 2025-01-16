WITH jan2020_users AS (
    SELECT 
        "user_id"
    FROM 
        "THELOOK_ECOMMERCE"."THELOOK_ECOMMERCE"."ORDERS"
    GROUP BY 
        "user_id"
    HAVING 
        MIN("created_at") >= 1577836800000000  -- Jan 1, 2020
        AND MIN("created_at") < 1580515200000000  -- Feb 1, 2020
),
monthly_purchases AS (
    SELECT DISTINCT
        u."user_id",
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ(o."created_at" / 1e6)) AS "Month_num",
        TO_CHAR(TO_TIMESTAMP_NTZ(o."created_at" / 1e6), 'Mon-YYYY') AS "Month"
    FROM
        jan2020_users u
        INNER JOIN "THELOOK_ECOMMERCE"."THELOOK_ECOMMERCE"."ORDERS" o
            ON u."user_id" = o."user_id"
    WHERE
        o."created_at" >= 1580515200000000  -- Feb 1, 2020
        AND o."created_at" < 1609459200000000  -- Jan 1, 2021
)

SELECT
    "Month_num",
    "Month",
    ROUND(COUNT(DISTINCT "user_id") * 1.0 / (SELECT COUNT(*) FROM jan2020_users), 4) AS "Proportion"
FROM
    monthly_purchases
GROUP BY
    "Month_num",
    "Month"
ORDER BY
    "Month_num";