SELECT
  ROUND(
    (COUNT(CASE WHEN "health" = 'Good' THEN 1 END)::FLOAT /
     COUNT(*)::FLOAT) * 100, 4
  ) AS "Percentage"
FROM MODERN_DATA.MODERN_DATA.TREES
WHERE "boroname" = 'Bronx'
  AND "status" = 'Alive'
  AND "health" IS NOT NULL
  AND "health" != '';