SELECT
  ROUND((COUNT(CASE WHEN "health" = 'Good' THEN 1 END) * 100.0) / COUNT(*), 4) AS "Percentage_of_Good_Health_Trees_in_Bronx"
FROM
  "MODERN_DATA"."MODERN_DATA"."TREES"
WHERE
  "boroname" = 'Bronx';