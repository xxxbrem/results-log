SELECT
    ROUND(
        (COUNT(CASE WHEN "health" = 'Good' THEN 1 END)::FLOAT / COUNT(*) * 100),
        4) AS "Percentage_of_trees_in_Bronx_with_good_health"
FROM MODERN_DATA.MODERN_DATA.TREES
WHERE "boroname" = 'Bronx' AND "health" IN ('Good', 'Fair', 'Poor');