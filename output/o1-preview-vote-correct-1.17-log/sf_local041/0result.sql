SELECT ROUND(
    (COUNT(CASE WHEN "health" = 'Good' THEN 1 END) * 100.0) / COUNT(*),
    4
) AS "Percentage"
FROM MODERN_DATA.MODERN_DATA.TREES
WHERE "boroname" = 'Bronx';