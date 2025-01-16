SELECT
    cd."country_region" AS "Country",
    cd.total_confirmed_cases AS "Total Confirmed Cases",
    pd."population" AS "Population",
    ROUND((cd.total_confirmed_cases / pd."population") * 100000, 4) AS "Cases per 100,000 People"
FROM
    (
        SELECT
            "country_region",
            SUM("confirmed") AS total_confirmed_cases
        FROM
            COVID19_JHU_WORLD_BANK.COVID19_JHU_CSSE.SUMMARY
        WHERE
            "date" = '2020-04-20'
            AND "country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
        GROUP BY
            "country_region"
    ) AS cd
JOIN
    (
        SELECT
            CASE
                WHEN "country" = 'United States' THEN 'US'
                WHEN "country" = 'Iran, Islamic Rep.' THEN 'Iran'
                ELSE "country"
            END AS "country_region",
            COALESCE(
                "year_2019",
                "year_2018",
                "year_2017",
                "year_2016",
                "year_2015"
            ) AS "population"
        FROM
            COVID19_JHU_WORLD_BANK.WORLD_BANK_GLOBAL_POPULATION.POPULATION_BY_COUNTRY
        WHERE
            "country" IN (
                'United States',
                'France',
                'China',
                'Italy',
                'Spain',
                'Germany',
                'Iran, Islamic Rep.'
            )
    ) AS pd
ON cd."country_region" = pd."country_region";