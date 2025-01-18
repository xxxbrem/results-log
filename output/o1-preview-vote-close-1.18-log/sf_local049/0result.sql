SELECT
    ic."industry" AS "Industry",
    ROUND(ic."total_new_unicorns" / 3.0, 4) AS "Average_new_unicorns_per_year"
FROM (
    SELECT 
        ci."industry",
        COUNT(DISTINCT cf."company_id") AS "total_new_unicorns"
    FROM 
        "MODERN_DATA"."MODERN_DATA"."COMPANIES_FUNDING" cf
    INNER JOIN 
        "MODERN_DATA"."MODERN_DATA"."COMPANIES_DATES" cd
        ON cf."company_id" = cd."company_id"
    INNER JOIN 
        "MODERN_DATA"."MODERN_DATA"."COMPANIES_INDUSTRIES" ci
        ON cf."company_id" = ci."company_id"
    WHERE 
        cf."valuation" >= 1000000000
        AND cd."date_joined" BETWEEN '2019-01-01' AND '2021-12-31'
    GROUP BY 
        ci."industry"
    ORDER BY 
        COUNT(DISTINCT cf."company_id") DESC NULLS LAST
    LIMIT 1
) ic;