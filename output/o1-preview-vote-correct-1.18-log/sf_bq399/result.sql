WITH avg_birth_rate AS (
    SELECT
        cs."region",
        cs."country_code",
        cs."short_name" AS "country",
        AVG(id."value") AS "average_crude_birth_rate"
    FROM
        "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" id
    JOIN
        "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" cs
            ON id."country_code" = cs."country_code"
    WHERE
        cs."income_group" = 'High income'
        AND id."indicator_code" = 'SP.DYN.CBRT.IN'
        AND id."year" BETWEEN 1980 AND 1989
    GROUP BY
        cs."region",
        cs."country_code",
        cs."short_name"
),
ranked_birth_rate AS (
    SELECT
        ab.*,
        ROW_NUMBER() OVER (
            PARTITION BY ab."region"
            ORDER BY ab."average_crude_birth_rate" DESC NULLS LAST, ab."country" ASC
        ) AS rn
    FROM
        avg_birth_rate ab
)
SELECT
    ab."region" AS "Region",
    ab."country" AS "Country",
    ROUND(ab."average_crude_birth_rate", 4) AS "Average Crude Birth Rate"
FROM
    ranked_birth_rate ab
WHERE
    ab.rn = 1
ORDER BY
    ab."region";