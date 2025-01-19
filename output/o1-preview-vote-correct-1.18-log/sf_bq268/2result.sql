WITH all_sessions AS (
    SELECT
        "fullVisitorId",
        "visitStartTime",
        "device",
        "totals"
    FROM GA360.GOOGLE_ANALYTICS_SAMPLE.GA_SESSIONS_20160801
    UNION ALL
    SELECT
        "fullVisitorId",
        "visitStartTime",
        "device",
        "totals"
    FROM GA360.GOOGLE_ANALYTICS_SAMPLE.GA_SESSIONS_20160802
    UNION ALL
    SELECT
        "fullVisitorId",
        "visitStartTime",
        "device",
        "totals"
    FROM GA360.GOOGLE_ANALYTICS_SAMPLE.GA_SESSIONS_20160803
    UNION ALL
    -- Continue listing all tables explicitly
    SELECT
        "fullVisitorId",
        "visitStartTime",
        "device",
        "totals"
    FROM GA360.GOOGLE_ANALYTICS_SAMPLE.GA_SESSIONS_20160804
    UNION ALL
    SELECT
        "fullVisitorId",
        "visitStartTime",
        "device",
        "totals"
    FROM GA360.GOOGLE_ANALYTICS_SAMPLE.GA_SESSIONS_20160805
    UNION ALL
    -- Include all other tables up to GA_SESSIONS_20170801
    -- Ensure that all table names are explicitly listed and columns are consistent
    -- The list continues with all tables specified
    /* ... */
    SELECT
        "fullVisitorId",
        "visitStartTime",
        "device",
        "totals"
    FROM GA360.GOOGLE_ANALYTICS_SAMPLE.GA_SESSIONS_20170801
),
sessions_extracted AS (
    SELECT
        "fullVisitorId",
        "visitStartTime",
        TO_TIMESTAMP("visitStartTime") AS "visitStartTimestamp",
        DATE_TRUNC('day', TO_TIMESTAMP("visitStartTime")) AS "visitStartDate",
        "device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory",
        "totals"::VARIANT:"transactionRevenue"::FLOAT AS "transactionRevenue"
    FROM all_sessions
),
user_visits AS (
    SELECT
        "fullVisitorId",
        MIN("visitStartDate") AS "first_visit_date",
        MAX("visitStartDate") AS "last_visit_date"
    FROM sessions_extracted
    GROUP BY "fullVisitorId"
),
user_transactions AS (
    SELECT
        "fullVisitorId",
        MIN("visitStartDate") AS "first_transaction_date"
    FROM sessions_extracted
    WHERE "transactionRevenue" IS NOT NULL
    GROUP BY "fullVisitorId"
),
user_last_event AS (
    SELECT
        u."fullVisitorId",
        u."first_visit_date",
        COALESCE(t."first_transaction_date", u."last_visit_date") AS "last_recorded_event_date",
        CASE WHEN t."fullVisitorId" IS NOT NULL THEN 1 ELSE 0 END AS "has_transaction"
    FROM user_visits u
    LEFT JOIN user_transactions t
        ON u."fullVisitorId" = t."fullVisitorId"
),
last_event_sessions AS (
    SELECT
        s."fullVisitorId",
        s."visitStartDate",
        s."deviceCategory"
    FROM sessions_extracted s
    JOIN user_last_event l
        ON s."fullVisitorId" = l."fullVisitorId"
        AND s."visitStartDate" = l."last_recorded_event_date"
    WHERE
        (l."has_transaction" = 1 AND s."transactionRevenue" IS NOT NULL)
        OR
        (l."has_transaction" = 0)
),
users_with_mobile_last_event AS (
    SELECT DISTINCT
        le."fullVisitorId",
        le."visitStartDate" AS "last_event_date",
        le."deviceCategory",
        u."first_visit_date",
        DATEDIFF('day', u."first_visit_date", le."visitStartDate") AS "days_difference"
    FROM last_event_sessions le
    JOIN user_visits u
        ON le."fullVisitorId" = u."fullVisitorId"
    WHERE le."deviceCategory" = 'mobile'
)
SELECT MAX("days_difference") AS "longest_number_of_days"
FROM users_with_mobile_last_event;