WITH months AS (
    SELECT
        DATE_TRUNC('month', DATEADD(month, seq4(), '2008-01-01')) AS month_start
    FROM TABLE(GENERATOR(ROWCOUNT => 180))
),
iot_publications AS (
    SELECT
        DATE_TRUNC('month', TO_DATE(CAST("filing_date" AS STRING), 'YYYYMMDD')) AS filing_month,
        COUNT(DISTINCT t."publication_number") AS num_publications
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."abstract_localized") f
    WHERE
        t."country_code" = 'US'
        AND t."filing_date" BETWEEN 20080101 AND 20221231
        AND f.value:"text"::STRING ILIKE '%internet of things%'
    GROUP BY
        filing_month
)
SELECT
    EXTRACT(month FROM m.month_start) AS "Month",
    EXTRACT(year FROM m.month_start) AS "Year",
    COALESCE(i.num_publications, 0) AS "Number_of_Publications"
FROM
    months m
    LEFT JOIN iot_publications i
        ON m.month_start = i.filing_month
WHERE
    EXTRACT(year FROM m.month_start) BETWEEN 2008 AND 2022
ORDER BY
    "Year", "Month";