WITH country_mapping AS (
    SELECT 'US' AS "country_region", 'United States' AS "country_name"
    UNION ALL SELECT 'France', 'France'
    UNION ALL SELECT 'China', 'China'
    UNION ALL SELECT 'Italy', 'Italy'
    UNION ALL SELECT 'Spain', 'Spain'
    UNION ALL SELECT 'Germany', 'Germany'
    UNION ALL SELECT 'Iran', 'Iran, Islamic Rep.'
),
confirmed_cases AS (
    SELECT
        cm."country_name",
        SUM(s."confirmed") AS "Total_Confirmed_Cases"
    FROM
        COVID19_JHU_WORLD_BANK.COVID19_JHU_CSSE.SUMMARY s
    JOIN
        country_mapping cm ON s."country_region" = cm."country_region"
    WHERE
        s."date" = '2020-04-20'
    GROUP BY
        cm."country_name"
),
population_data AS (
    SELECT
        id."country_name",
        id."value" AS "population"
    FROM
        COVID19_JHU_WORLD_BANK.WORLD_BANK_WDI.INDICATORS_DATA id
    WHERE
        id."indicator_code" = 'SP.POP.TOTL' AND
        id."year" = 2020 AND
        id."country_name" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
)

SELECT
    cc."country_name" AS "Country",
    cc."Total_Confirmed_Cases",
    ROUND((cc."Total_Confirmed_Cases" / pd."population") * 100000, 4) AS "Cases_Per_100k"
FROM
    confirmed_cases cc
JOIN
    population_data pd ON cc."country_name" = pd."country_name"
ORDER BY
    cc."country_name";