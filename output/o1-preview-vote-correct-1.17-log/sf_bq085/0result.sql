WITH covid_data AS (
    SELECT 
        CASE 
            WHEN "country_region" = 'US' THEN 'United States'
            ELSE "country_region"
        END AS "Country",
        SUM("confirmed") AS "Total Confirmed Cases"
    FROM "COVID19_JHU_WORLD_BANK"."COVID19_JHU_CSSE"."SUMMARY"
    WHERE "date" = '2020-04-20'
      AND "country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
    GROUP BY "country_region"
), population_data AS (
    SELECT 
        CASE 
            WHEN "country_name" = 'Iran, Islamic Rep.' THEN 'Iran'
            WHEN "country_name" = 'United States' THEN 'United States'
            ELSE "country_name"
        END AS "Country",
        "value" AS "Population"
    FROM "COVID19_JHU_WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
    WHERE "indicator_name" = 'Population, total'
      AND "year" = 2020
      AND "country_name" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
)
SELECT 
    c."Country",
    c."Total Confirmed Cases",
    ROUND( (c."Total Confirmed Cases" / p."Population") * 100000, 4) AS "Cases per 100,000 people"
FROM covid_data c
JOIN population_data p
ON c."Country" = p."Country"
ORDER BY c."Country";