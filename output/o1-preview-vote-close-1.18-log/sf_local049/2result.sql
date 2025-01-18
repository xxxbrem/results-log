WITH TopIndustry AS (
    SELECT i."industry"
    FROM "MODERN_DATA"."MODERN_DATA"."COMPANIES_INDUSTRIES" i
    JOIN "MODERN_DATA"."MODERN_DATA"."COMPANIES_DATES" d
        ON i."company_id" = d."company_id"
    JOIN "MODERN_DATA"."MODERN_DATA"."COMPANIES_FUNDING" f
        ON i."company_id" = f."company_id"
    WHERE f."valuation" >= 1000000000
        AND TRY_TO_DATE(SUBSTRING(d."date_joined", 1, 10), 'YYYY-MM-DD') BETWEEN '2019-01-01' AND '2021-12-31'
    GROUP BY i."industry"
    ORDER BY COUNT(*) DESC NULLS LAST
    LIMIT 1
)
SELECT ROUND(AVG("unicorns"), 4) AS "average_number_of_new_unicorn_companies_per_year"
FROM (
    SELECT EXTRACT(YEAR FROM TRY_TO_DATE(SUBSTRING(d."date_joined", 1, 10), 'YYYY-MM-DD')) AS "year",
           COUNT(*) AS "unicorns"
    FROM "MODERN_DATA"."MODERN_DATA"."COMPANIES_DATES" d
    JOIN "MODERN_DATA"."MODERN_DATA"."COMPANIES_INDUSTRIES" i
        ON d."company_id" = i."company_id"
    JOIN "MODERN_DATA"."MODERN_DATA"."COMPANIES_FUNDING" f
        ON d."company_id" = f."company_id"
    JOIN TopIndustry t
        ON i."industry" = t."industry"
    WHERE f."valuation" >= 1000000000
        AND TRY_TO_DATE(SUBSTRING(d."date_joined", 1, 10), 'YYYY-MM-DD') BETWEEN '2019-01-01' AND '2021-12-31'
    GROUP BY EXTRACT(YEAR FROM TRY_TO_DATE(SUBSTRING(d."date_joined", 1, 10), 'YYYY-MM-DD'))
) sub;