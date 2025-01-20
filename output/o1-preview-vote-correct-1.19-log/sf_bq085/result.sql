WITH country_population AS (
    SELECT
        CASE
            WHEN "country_name" = 'United States' THEN 'US'
            WHEN "country_name" = 'Iran, Islamic Rep.' THEN 'Iran'
            ELSE "country_name"
        END AS "Country",
        "value" AS "Population"
    FROM
        "COVID19_JHU_WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
    WHERE
        "indicator_code" = 'SP.POP.TOTL'
        AND "year" = 2019
        AND "country_name" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
)
SELECT
    s."country_region" AS "Country",
    SUM(s."confirmed") AS "Total_Confirmed_Cases",
    ROUND((SUM(s."confirmed") / cp."Population") * 100000, 4) AS "Cases_per_100000"
FROM
    "COVID19_JHU_WORLD_BANK"."COVID19_JHU_CSSE"."SUMMARY" s
JOIN
    country_population cp ON s."country_region" = cp."Country"
WHERE
    s."date" = '2020-04-20'
    AND s."country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
GROUP BY
    s."country_region",
    cp."Population"
ORDER BY
    s."country_region";