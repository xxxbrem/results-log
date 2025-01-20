SELECT
    c."country_or_region" AS "Country",
    SUM(TRY_TO_NUMBER(c."_4_20_20")) AS "Total_Confirmed_Cases",
    ROUND((SUM(TRY_TO_NUMBER(c."_4_20_20")) / p."Population") * 100000, 4) AS "Cases_per_100000"
FROM
    COVID19_JHU_WORLD_BANK.COVID19_JHU_CSSE.CONFIRMED_CASES c
JOIN
    (
        SELECT
            CASE
                WHEN "country" = 'United States' THEN 'US'
                WHEN "country" = 'Iran, Islamic Rep.' THEN 'Iran'
                ELSE "country"
            END AS "country_or_region",
            COALESCE(
                "year_2019",
                "year_2018",
                "year_2017",
                "year_2016",
                "year_2015",
                "year_2014",
                "year_2013",
                "year_2012",
                "year_2011",
                "year_2010"
            ) AS "Population"
        FROM
            COVID19_JHU_WORLD_BANK.WORLD_BANK_GLOBAL_POPULATION.POPULATION_BY_COUNTRY
        WHERE
            "country" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
    ) p
ON c."country_or_region" = p."country_or_region"
WHERE
    c."country_or_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
GROUP BY
    c."country_or_region", p."Population"
ORDER BY
    c."country_or_region";