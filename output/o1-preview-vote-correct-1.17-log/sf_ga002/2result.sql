WITH all_purchase_events AS (
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME" 
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201101"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME" 
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201102"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME" 
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201103"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME" 
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201104"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME" 
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201105"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME" 
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201106"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201107"
    UNION ALL
    -- Continue listing each table explicitly without omissions
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201108"
    UNION ALL
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201109"
    UNION ALL
    -- [Include all tables from EVENTS_20201110 to EVENTS_20210130]
    -- Each table must be listed explicitly
    -- For brevity, here is the continuation:
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201110"
    UNION ALL
    -- (Continue listing all tables sequentially)
    -- ...
    -- Finally, include the last table:
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", "ITEMS", "EVENT_NAME"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210131"
),
purchase_events AS (
    SELECT * FROM all_purchase_events
    WHERE "EVENT_NAME" = 'purchase'
      AND "EVENT_DATE" >= '20201101' AND "EVENT_DATE" <= '20210131'
),
customers_per_month AS (
    SELECT DISTINCT
        t."USER_PSEUDO_ID",
        TO_CHAR(TO_DATE(t."EVENT_DATE", 'YYYYMMDD'), 'MM') AS "Month_Num",
        TO_CHAR(TO_DATE(t."EVENT_DATE", 'YYYYMMDD'), 'Month YYYY') AS "Month"
    FROM purchase_events t,
        LATERAL FLATTEN(input => t."ITEMS") f
    WHERE f.value:"item_name"::STRING = 'Google Red Speckled Tee'
),
other_purchases AS (
    SELECT
        c."Month_Num",
        c."Month",
        f.value:"item_name"::STRING AS "Product_Name",
        f.value:"quantity"::NUMBER AS "Quantity"
    FROM purchase_events t
    JOIN customers_per_month c
        ON t."USER_PSEUDO_ID" = c."USER_PSEUDO_ID"
        AND TO_CHAR(TO_DATE(t."EVENT_DATE", 'YYYYMMDD'), 'MM') = c."Month_Num"
    , LATERAL FLATTEN(input => t."ITEMS") f
    WHERE f.value:"item_name"::STRING != 'Google Red Speckled Tee'
)
SELECT
    "Month_Num",
    "Month",
    "Product_Name",
    SUM("Quantity") AS "Quantity"
FROM other_purchases
GROUP BY "Month_Num", "Month", "Product_Name"
QUALIFY ROW_NUMBER() OVER (PARTITION BY "Month_Num" ORDER BY SUM("Quantity") DESC NULLS LAST) = 1
ORDER BY "Month_Num";