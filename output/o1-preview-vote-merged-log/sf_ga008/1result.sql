WITH events_unioned AS (
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201101"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201102"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201103"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201104"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201105"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201106"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201107"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201108"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201109"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201110"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201111"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201112"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201113"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201114"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201115"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201116"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201117"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201118"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201119"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201120"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201121"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201122"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201123"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201124"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201125"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201126"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201127"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201128"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201129"
    UNION ALL
    SELECT "EVENT_DATE", "EVENT_NAME", "USER_PSEUDO_ID"
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20201130"
),
buyers AS (
    SELECT DISTINCT "EVENT_DATE", "USER_PSEUDO_ID" 
    FROM events_unioned 
    WHERE "EVENT_NAME" = 'purchase'
),
page_views_by_buyers AS (
    SELECT eu."EVENT_DATE", eu."USER_PSEUDO_ID", COUNT(*) AS page_views
    FROM events_unioned eu
    JOIN buyers b ON eu."EVENT_DATE" = b."EVENT_DATE" AND eu."USER_PSEUDO_ID" = b."USER_PSEUDO_ID"
    WHERE eu."EVENT_NAME" = 'page_view'
    GROUP BY eu."EVENT_DATE", eu."USER_PSEUDO_ID"
),
daily_metrics AS (
    SELECT 
        "EVENT_DATE" AS "Date",
        AVG(page_views) AS "Average_Page_Views_per_Buyer",
        SUM(page_views) AS "Total_Page_Views_Among_Buyers"
    FROM page_views_by_buyers
    GROUP BY "EVENT_DATE"
)
SELECT 
    "Date",
    ROUND("Average_Page_Views_per_Buyer", 4) AS "Average_Page_Views_per_Buyer",
    "Total_Page_Views_Among_Buyers"
FROM daily_metrics
ORDER BY "Date";