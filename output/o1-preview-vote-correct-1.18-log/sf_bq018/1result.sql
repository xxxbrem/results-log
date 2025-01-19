WITH daily_growth AS (
    SELECT
        "date",
        "new_confirmed",
        "cumulative_confirmed",
        LAG("cumulative_confirmed") OVER (PARTITION BY "location_key" ORDER BY "date") AS "previous_cumulative_confirmed",
        ROUND(
            ("new_confirmed" / NULLIF(LAG("cumulative_confirmed") OVER (PARTITION BY "location_key" ORDER BY "date"), 0)) * 100,
            4
        ) AS "growth_rate"
    FROM
        COVID19_OPEN_DATA.COVID19_OPEN_DATA.COVID19_OPEN_DATA
    WHERE
        "location_key" = 'US' AND
        "date" BETWEEN '2020-03-01' AND '2020-04-30'
)
SELECT
    TO_CHAR("date", 'MM-DD') AS "Date"
FROM
    daily_growth
ORDER BY
    "growth_rate" DESC NULLS LAST
LIMIT 1;