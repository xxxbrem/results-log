SELECT
    t."region",
    t."country",
    t."average_crude_birth_rate"
FROM (
    SELECT
        cs."region",
        cs."short_name" AS "country",
        ROUND(AVG(id."value"), 4) AS "average_crude_birth_rate",
        RANK() OVER (PARTITION BY cs."region" ORDER BY AVG(id."value") DESC NULLS LAST) AS "region_rank"
    FROM
        "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" AS cs
    JOIN
        "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" AS id
    ON
        cs."country_code" = id."country_code"
    WHERE
        cs."income_group" = 'High income'
        AND id."indicator_name" = 'Birth rate, crude (per 1,000 people)'
        AND id."year" BETWEEN 1980 AND 1989
        AND id."value" IS NOT NULL
    GROUP BY
        cs."region",
        cs."short_name"
) t
WHERE
    t."region_rank" = 1;