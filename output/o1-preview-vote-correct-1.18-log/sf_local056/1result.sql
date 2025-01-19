WITH monthly_payments AS (
    SELECT
        P."customer_id",
        EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(P."payment_date")) AS "year",
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ(P."payment_date")) AS "month",
        SUM(P."amount") AS "monthly_total"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA."PAYMENT" P
    GROUP BY
        P."customer_id",
        EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(P."payment_date")),
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ(P."payment_date"))
),
monthly_changes AS (
    SELECT
        MP."customer_id",
        MP."year",
        MP."month",
        MP."monthly_total",
        LAG(MP."monthly_total") OVER (
            PARTITION BY MP."customer_id"
            ORDER BY MP."year", MP."month"
        ) AS "prev_month_total",
        ABS(MP."monthly_total" - LAG(MP."monthly_total") OVER (
            PARTITION BY MP."customer_id"
            ORDER BY MP."year", MP."month"
        )) AS "monthly_change"
    FROM
        monthly_payments MP
),
avg_monthly_changes AS (
    SELECT
        MC."customer_id",
        ROUND(AVG(MC."monthly_change"), 4) AS "avg_monthly_change"
    FROM
        monthly_changes MC
    WHERE
        MC."prev_month_total" IS NOT NULL
    GROUP BY
        MC."customer_id"
),
max_avg_customer AS (
    SELECT
        AMC."customer_id"
    FROM
        avg_monthly_changes AMC
    ORDER BY
        AMC."avg_monthly_change" DESC NULLS LAST
    LIMIT
        1
)
SELECT
    CONCAT(C."first_name", ' ', C."last_name") AS "Full_Name"
FROM
    max_avg_customer MAC
    JOIN SQLITE_SAKILA.SQLITE_SAKILA."CUSTOMER" C
        ON MAC."customer_id" = C."customer_id";