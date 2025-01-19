SELECT 
    ROUND(100.0 * SUM(CASE WHEN "health" = 'Good' THEN 1 ELSE 0 END) / COUNT(*), 4) AS "Percentage_of_Good_Trees_in_Bronx"
FROM "trees"
WHERE "boroname" = 'Bronx';