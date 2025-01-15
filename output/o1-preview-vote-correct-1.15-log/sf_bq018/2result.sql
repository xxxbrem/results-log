SELECT
  TO_CHAR("date", 'MM-DD') AS "Date",
  ROUND(("new_confirmed" / NULLIF(LAG("cumulative_confirmed") OVER (ORDER BY "date"), 0)), 4) AS "Growth_rate"
FROM "COVID19_OPEN_DATA"."COVID19_OPEN_DATA"."COVID19_OPEN_DATA"
WHERE
  "country_name" = 'United States of America'
  AND "aggregation_level" = 0
  AND "date" BETWEEN '2020-03-01' AND '2020-04-30'
  AND "new_confirmed" IS NOT NULL
  AND "cumulative_confirmed" IS NOT NULL
ORDER BY "Growth_rate" DESC NULLS LAST
LIMIT 1;