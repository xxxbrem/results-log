SELECT "region", "country_name", "average_crude_birth_rate"
FROM (
    SELECT cs."region" AS "region",
           cs."short_name" AS "country_name",
           ROUND(AVG(hnp."value"), 4) AS "average_crude_birth_rate",
           ROW_NUMBER() OVER (
               PARTITION BY cs."region"
               ORDER BY AVG(hnp."value") DESC NULLS LAST
           ) AS rn
    FROM WORLD_BANK.WORLD_BANK_HEALTH_POPULATION."HEALTH_NUTRITION_POPULATION" hnp
    JOIN WORLD_BANK.WORLD_BANK_HEALTH_POPULATION."COUNTRY_SUMMARY" cs
      ON hnp."country_code" = cs."country_code"
    WHERE hnp."indicator_name" = 'Birth rate, crude (per 1,000 people)'
      AND hnp."year" BETWEEN 1980 AND 1989
      AND cs."income_group" = 'High income'
    GROUP BY cs."region", cs."short_name"
) sub
WHERE rn = 1;