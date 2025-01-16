SELECT
    c."country_region" AS "Country",
    SUM(c."confirmed") AS "Total_Confirmed_Cases",
    ROUND((SUM(c."confirmed") / p."Population") * 100000, 4) AS "Cases_per_100k_People"
FROM
    COVID19_JHU_WORLD_BANK.COVID19_JHU_CSSE.SUMMARY c
JOIN
    (
        SELECT
            CASE
                WHEN "country_name" = 'United States' THEN 'US'
                WHEN "country_name" = 'Iran, Islamic Rep.' THEN 'Iran'
                ELSE "country_name"
            END AS "country_region",
            MAX("value") AS "Population"
        FROM
            COVID19_JHU_WORLD_BANK.WORLD_BANK_WDI.INDICATORS_DATA
        WHERE
            "indicator_name" = 'Population, total'
            AND "year" = 2020
            AND "country_name" IN ('United States', 'France', 'Germany', 'Italy', 'Spain', 'China', 'Iran, Islamic Rep.')
        GROUP BY
            CASE
                WHEN "country_name" = 'United States' THEN 'US'
                WHEN "country_name" = 'Iran, Islamic Rep.' THEN 'Iran'
                ELSE "country_name"
            END
    ) p ON c."country_region" = p."country_region"
WHERE
    c."date" = '2020-04-20'
    AND c."country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
GROUP BY
    c."country_region", p."Population";