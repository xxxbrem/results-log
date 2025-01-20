WITH "all_sessions" AS (

    -- Select from GA_SESSIONS_20160801
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160801"

    UNION ALL

    -- Select from GA_SESSIONS_20160802
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160802"

    UNION ALL

    -- Select from GA_SESSIONS_20160803
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160803"

    UNION ALL

    -- Select from GA_SESSIONS_20160804
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160804"

    UNION ALL

    -- Select from GA_SESSIONS_20160805
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160805"

    UNION ALL

    -- Select from GA_SESSIONS_20160806
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160806"

    UNION ALL

    -- Select from GA_SESSIONS_20160807
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160807"

    UNION ALL

    -- Continue listing each table explicitly from GA_SESSIONS_20160808 to GA_SESSIONS_20170731

    -- Example for GA_SESSIONS_20160808
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160808"

    -- ... (Include all tables in between)

    UNION ALL

    -- Select from GA_SESSIONS_20170801
    SELECT "fullVisitorId", "visitStartTime", 
           "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory", 
           "totals"::VARIANT:"transactions"::NUMBER AS "transactions"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170801"

),

"per_user" AS (

    SELECT
        "fullVisitorId",
        MIN("visitStartTime") AS "first_visit_time",
        MAX("visitStartTime") AS "last_visit_time",
        MIN(CASE WHEN "transactions" > 0 THEN "visitStartTime" END) AS "first_transaction_time"
    FROM "all_sessions"
    GROUP BY "fullVisitorId"

),

"per_user_details" AS (

    SELECT
        "fullVisitorId",
        "first_visit_time",
        "last_visit_time",
        "first_transaction_time",
        CASE 
            WHEN "first_transaction_time" IS NOT NULL THEN "first_transaction_time"
            ELSE "last_visit_time"
        END AS "last_recorded_event_time"
    FROM "per_user"

),

"user_with_device" AS (

    SELECT
        pud."fullVisitorId",
        pud."first_visit_time",
        pud."last_recorded_event_time",
        s."deviceCategory" AS "last_device_category"
    FROM "per_user_details" pud
    INNER JOIN "all_sessions" s
        ON pud."fullVisitorId" = s."fullVisitorId" 
        AND pud."last_recorded_event_time" = s."visitStartTime"

)

SELECT MAX(DATEDIFF('day', TO_TIMESTAMP("first_visit_time"), TO_TIMESTAMP("last_recorded_event_time"))) AS "longest_number_of_days"
FROM "user_with_device"
WHERE "last_device_category" = 'mobile';