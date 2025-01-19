SELECT
    CASE c."country_region"
        WHEN 'US' THEN 'United States'
        ELSE c."country_region"
    END AS "Country",
    SUM(c."confirmed") AS "Total_confirmed_cases",
    ROUND((SUM(c."confirmed") / p."Population") * 100000, 4) AS "Cases_per_100000"
FROM
    "COVID19_JHU_WORLD_BANK"."COVID19_JHU_CSSE"."SUMMARY" c
JOIN
    (
        SELECT
            CASE "country_name"
                WHEN 'United States' THEN 'US'
                WHEN 'Iran, Islamic Rep.' THEN 'Iran'
                ELSE "country_name"
            END AS "Country",
            MAX("value") AS "Population"
        FROM
            "COVID19_JHU_WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
        WHERE
            "indicator_code" = 'SP.POP.TOTL' AND "year" = 2019
        GROUP BY
            "country_name"
    ) p
ON c."country_region" = p."Country"
WHERE
    c."date" = '2020-04-20'
    AND c."country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
GROUP BY
    c."country_region", p."Population"
ORDER BY
    CASE c."country_region"
        WHEN 'US' THEN 1
        WHEN 'France' THEN 2
        WHEN 'China' THEN 3
        WHEN 'Italy' THEN 4
        WHEN 'Spain' THEN 5
        WHEN 'Germany' THEN 6
        WHEN 'Iran' THEN 7
        ELSE 8
    END;