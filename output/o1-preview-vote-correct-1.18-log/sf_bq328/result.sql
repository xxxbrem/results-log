SELECT t."region" AS "Region"
FROM (
    SELECT c."region", MEDIAN(i."value") AS "median_gdp"
    FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" i
    JOIN "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" c
        ON i."country_code" = c."country_code"
    WHERE i."indicator_code" = 'NY.GDP.MKTP.KD'
        AND i."year" = 2020
        AND c."region" IS NOT NULL
        AND c."region" != ''
    GROUP BY c."region"
) t
ORDER BY t."median_gdp" DESC NULLS LAST
LIMIT 1;