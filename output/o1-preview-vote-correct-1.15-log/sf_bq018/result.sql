WITH daily_totals AS (
    SELECT
        "date",
        SUM("cumulative_confirmed") AS "cumulative_confirmed"
    FROM COVID19_OPEN_DATA.COVID19_OPEN_DATA.COVID19_OPEN_DATA
    WHERE
        "country_code" = 'US'
        AND "date" BETWEEN '2020-03-01' AND '2020-04-30'
        AND "cumulative_confirmed" IS NOT NULL
    GROUP BY "date"
)
SELECT TO_CHAR("date", 'MM-DD') AS "Date"
FROM (
    SELECT
        "date",
        ROUND((
            "cumulative_confirmed" - LAG("cumulative_confirmed") OVER (ORDER BY "date")
        ) / NULLIF(LAG("cumulative_confirmed") OVER (ORDER BY "date"), 0), 4) AS "growth_rate"
    FROM daily_totals
    ORDER BY "date"
) sub
WHERE "growth_rate" IS NOT NULL
ORDER BY "growth_rate" DESC NULLS LAST
LIMIT 1;