WITH new_unicorns AS (
  SELECT 
    ci."industry",
    EXTRACT(YEAR FROM TO_DATE(SPLIT_PART(cd."date_joined", 'T', 1), 'YYYY-MM-DD')) AS "year_joined",
    cd."company_id"
  FROM 
    "MODERN_DATA"."MODERN_DATA"."COMPANIES_DATES" AS cd
    INNER JOIN "MODERN_DATA"."MODERN_DATA"."COMPANIES_FUNDING" AS cf ON cd."company_id" = cf."company_id"
    INNER JOIN "MODERN_DATA"."MODERN_DATA"."COMPANIES_INDUSTRIES" AS ci ON cd."company_id" = ci."company_id"
  WHERE 
    cf."valuation" >= 1000000000
    AND cd."date_joined" >= '2019-01-01'
    AND cd."date_joined" <= '2021-12-31'
),
top_industry AS (
  SELECT
    "industry",
    COUNT(DISTINCT "company_id") AS total_unicorns
  FROM
    new_unicorns
  GROUP BY
    "industry"
  ORDER BY
    total_unicorns DESC NULLS LAST
  LIMIT 1
),
yearly_counts AS (
  SELECT
    nu."industry",
    nu."year_joined",
    COUNT(DISTINCT nu."company_id") AS unicorns_per_year
  FROM
    new_unicorns AS nu
    INNER JOIN top_industry AS ti ON nu."industry" = ti."industry"
  GROUP BY
    nu."industry", nu."year_joined"
)
SELECT
  ROUND(AVG(unicorns_per_year), 4) AS "Average_number_of_new_unicorn_companies_per_year",
  yc."industry" AS "Top_industry"
FROM
  yearly_counts AS yc
GROUP BY
  yc."industry";