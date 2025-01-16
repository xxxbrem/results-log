SELECT
    c."region" AS "region_name",
    ROUND(MEDIAN(d."value"), 4) AS "median_gdp_constant_2015_usd"
FROM
    "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" AS d
JOIN
    "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" AS c
    ON d."country_code" = c."country_code"
WHERE
    d."indicator_name" = 'GDP (constant 2015 US$)'
    AND c."region" IS NOT NULL
    AND c."region" <> ''
GROUP BY
    c."region"
ORDER BY
    "median_gdp_constant_2015_usd" DESC NULLS LAST
LIMIT 1;