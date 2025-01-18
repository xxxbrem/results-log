WITH "top_states" AS (
    SELECT "state"
    FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA
    GROUP BY "state"
    ORDER BY COUNT("id") DESC NULLS LAST
    LIMIT 10
)
SELECT COUNT(*) AS "number_of_states"
FROM (
    SELECT ad."state"
    FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA ad
    JOIN CITY_LEGISLATION.CITY_LEGISLATION.ALIENS_DETAILS adt ON ad."id" = adt."detail_id"
    WHERE ad."state" IN (SELECT "state" FROM "top_states")
    GROUP BY ad."state"
    HAVING AVG(ad."age") > 200
       AND SUM(CASE WHEN adt."aggressive" = 0 THEN 1 ELSE 0 END) > SUM(CASE WHEN adt."aggressive" = 1 THEN 1 ELSE 0 END)
) AS sub;