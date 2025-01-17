WITH birth_rates AS (
  SELECT
    c."region",
    c."short_name" AS "country",
    h."year",
    h."value" AS "birth_rate"
  FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" h
  JOIN "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" c
    ON h."country_code" = c."country_code"
  WHERE h."indicator_code" = 'SP.DYN.CBRT.IN'
    AND c."income_group" = 'High income'
    AND h."year" BETWEEN 1980 AND 1989
    AND h."value" IS NOT NULL
),
average_birth_rates AS (
  SELECT
    "region",
    "country",
    AVG("birth_rate") AS "average_birth_rate"
  FROM birth_rates
  GROUP BY "region", "country"
),
ranked_birth_rates AS (
  SELECT
    "region",
    "country",
    "average_birth_rate",
    ROW_NUMBER() OVER (
      PARTITION BY "region" 
      ORDER BY "average_birth_rate" DESC NULLS LAST
    ) AS "rank_in_region"
  FROM average_birth_rates
)
SELECT
  "region",
  "country",
  ROUND("average_birth_rate", 4) AS "average_birth_rate"
FROM ranked_birth_rates
WHERE "rank_in_region" = 1;