WITH growth_data AS (
    SELECT
        "date",
        TO_CHAR("date", 'MM-DD') AS "Date",
        "cumulative_confirmed",
        LAG("cumulative_confirmed") OVER (
            PARTITION BY "country_name", "aggregation_level"
            ORDER BY "date"
        ) AS "prev_cumulative_confirmed"
    FROM
        COVID19_OPEN_DATA.COVID19_OPEN_DATA.COVID19_OPEN_DATA
    WHERE
        "country_name" = 'United States of America'
        AND "aggregation_level" = 0
        AND "date" BETWEEN '2020-03-01' AND '2020-04-30'
)
SELECT
    "Date",
    ROUND(
        (
            ("cumulative_confirmed" - "prev_cumulative_confirmed")
            / NULLIF("prev_cumulative_confirmed", 0)
        ) * 100,
        4
    ) AS "COVID-19 Confirmed Case Growth Rate"
FROM
    growth_data
WHERE
    "prev_cumulative_confirmed" IS NOT NULL
    AND "prev_cumulative_confirmed" > 0
ORDER BY
    "COVID-19 Confirmed Case Growth Rate" DESC NULLS LAST
LIMIT 1;