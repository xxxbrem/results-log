SELECT
  TO_CHAR("date", 'MM-DD') AS "date",
  ROUND(("cumulative_confirmed" - prev_confirmed) / NULLIF(prev_confirmed, 0), 4) AS "growth_rate"
FROM (
  SELECT
    "date",
    "cumulative_confirmed",
    LAG("cumulative_confirmed") OVER (ORDER BY "date") AS prev_confirmed
  FROM COVID19_OPEN_DATA.COVID19_OPEN_DATA.COVID19_OPEN_DATA
  WHERE "location_key" = 'US'
    AND "date" BETWEEN '2020-03-01' AND '2020-04-30'
    AND "cumulative_confirmed" IS NOT NULL
  ORDER BY "date"
) sub
WHERE prev_confirmed IS NOT NULL
ORDER BY "growth_rate" DESC NULLS LAST
LIMIT 1;