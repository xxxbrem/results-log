WITH USData AS (
  SELECT
    "date",
    "new_confirmed",
    "cumulative_confirmed",
    LAG("cumulative_confirmed") OVER (ORDER BY "date") AS "prev_cumulative_confirmed"
  FROM
    COVID19_OPEN_DATA.COVID19_OPEN_DATA.COVID19_OPEN_DATA
  WHERE
    "country_code" = 'US' AND
    "aggregation_level" = 0 AND
    "date" BETWEEN '2020-03-01' AND '2020-04-30'
),
GrowthRates AS (
  SELECT
    "date",
    "new_confirmed",
    "prev_cumulative_confirmed",
    ("new_confirmed" / NULLIF("prev_cumulative_confirmed", 0)) AS "growth_rate"
  FROM
    USData
)
SELECT
  TO_VARCHAR("date", 'MM-DD') AS "Date"
FROM
  GrowthRates
ORDER BY
  "growth_rate" DESC NULLS LAST
LIMIT 1;