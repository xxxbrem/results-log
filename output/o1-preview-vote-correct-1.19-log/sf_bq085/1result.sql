SELECT 
    c."Country",
    c."Total_Confirmed_Cases",
    ROUND((c."Total_Confirmed_Cases" / p."year_2018") * 100000, 4) AS "Cases_per_100000"
FROM
    (
        SELECT 
            CASE 
                WHEN "country_region" = 'US' THEN 'United States'
                WHEN "country_region" = 'Iran' THEN 'Iran, Islamic Rep.'
                WHEN "country_region" IN ('China', 'Mainland China') THEN 'China'
                ELSE "country_region"
            END AS "Country",
            SUM("confirmed") AS "Total_Confirmed_Cases"
        FROM "COVID19_JHU_WORLD_BANK"."COVID19_JHU_CSSE"."SUMMARY"
        WHERE "date" = '2020-04-20'
          AND "country_region" IN ('US', 'France', 'China', 'Mainland China', 'Italy', 'Spain', 'Germany', 'Iran')
        GROUP BY "Country"
    ) c
JOIN
    (
        SELECT "country", "year_2018"
        FROM "COVID19_JHU_WORLD_BANK"."WORLD_BANK_GLOBAL_POPULATION"."POPULATION_BY_COUNTRY"
        WHERE "country" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
    ) p
ON c."Country" = p."country"
ORDER BY c."Country";