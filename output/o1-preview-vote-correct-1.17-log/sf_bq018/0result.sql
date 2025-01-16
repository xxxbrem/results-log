WITH us_data AS (
  SELECT
    "date",
    "cumulative_confirmed",
    LAG("cumulative_confirmed") OVER (ORDER BY "date") AS "prev_cumulative_confirmed"
  FROM "COVID19_OPEN_DATA"."COVID19_OPEN_DATA"."COVID19_OPEN_DATA"
  WHERE "location_key" = 'US'
    AND "date" BETWEEN '2020-03-01' AND '2020-04-30'
    AND "cumulative_confirmed" IS NOT NULL
)
SELECT
  TO_CHAR("date", 'MM-DD') AS "Date"
FROM us_data
WHERE "prev_cumulative_confirmed" IS NOT NULL
ORDER BY ( ("cumulative_confirmed" - "prev_cumulative_confirmed") / NULLIF("prev_cumulative_confirmed", 0) ) DESC NULLS LAST
LIMIT 1;