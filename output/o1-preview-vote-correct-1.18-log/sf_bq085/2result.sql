SELECT
    s."country_region" AS "Country",
    SUM(s."confirmed") AS "Total Confirmed Cases",
    ROUND((SUM(s."confirmed") / p."value") * 100000, 4) AS "Cases per 100,000 People"
FROM
    COVID19_JHU_WORLD_BANK.COVID19_JHU_CSSE.SUMMARY s
JOIN
    COVID19_JHU_WORLD_BANK.WORLD_BANK_WDI.INDICATORS_DATA p
    ON (
        (s."country_region" = p."country_name") OR
        (s."country_region" = 'US' AND p."country_name" = 'United States') OR
        (s."country_region" = 'Iran' AND p."country_name" = 'Iran, Islamic Rep.')
    )
WHERE
    s."date" = '2020-04-20'
    AND s."country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
    AND p."indicator_code" = 'SP.POP.TOTL'
    AND p."year" = 2019
GROUP BY
    s."country_region", p."value"
ORDER BY
    s."country_region";