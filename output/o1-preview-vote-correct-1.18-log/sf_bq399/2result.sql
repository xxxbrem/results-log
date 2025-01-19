WITH avg_birth_rates AS (
    SELECT
        cs."region",
        cs."short_name" AS "country",
        ROUND(AVG(id."value"), 4) AS "AverageCrudeBirthRate"
    FROM
        WORLD_BANK.WORLD_BANK_WDI.COUNTRY_SUMMARY cs
    JOIN
        WORLD_BANK.WORLD_BANK_WDI.INDICATORS_DATA id
    ON
        cs."country_code" = id."country_code"
    WHERE
        cs."income_group" = 'High income' AND
        id."indicator_name" = 'Birth rate, crude (per 1,000 people)' AND
        id."year" BETWEEN 1980 AND 1989 AND
        id."value" IS NOT NULL
    GROUP BY
        cs."region",
        cs."short_name"
)
SELECT
    "region",
    "country",
    "AverageCrudeBirthRate"
FROM (
    SELECT
        "region",
        "country",
        "AverageCrudeBirthRate",
        ROW_NUMBER() OVER (
            PARTITION BY "region"
            ORDER BY "AverageCrudeBirthRate" DESC NULLS LAST
        ) AS "rn"
    FROM
        avg_birth_rates
)
WHERE
    "rn" = 1
ORDER BY
    "region";