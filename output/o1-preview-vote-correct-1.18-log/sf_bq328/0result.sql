WITH latest_year AS (
    SELECT MAX("year") AS "year"
    FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
    WHERE "indicator_name" = 'GDP (constant 2015 US$)'
),
gdp_data AS (
    SELECT d."country_code", c."region", d."value"
    FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" d
    JOIN "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" c
    ON d."country_code" = c."country_code"
    WHERE d."indicator_name" = 'GDP (constant 2015 US$)'
      AND d."year" = (SELECT "year" FROM latest_year)
      AND c."region" IS NOT NULL
      AND c."region" != ''
      AND d."value" IS NOT NULL
),
median_gdp_per_region AS (
    SELECT "region",
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "value") AS "median_gdp"
    FROM gdp_data
    GROUP BY "region"
)
SELECT "region", ROUND("median_gdp", 4) AS "median_gdp"
FROM median_gdp_per_region
ORDER BY "median_gdp" DESC NULLS LAST
LIMIT 1;