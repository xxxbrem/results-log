SELECT
    TO_VARCHAR(TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD'), 'YYYY') AS "Year"
FROM
    PATENTS.PATENTS.PUBLICATIONS t,
    LATERAL FLATTEN(input => t."assignee_harmonized") f,
    LATERAL FLATTEN(input => t."cpc") c
WHERE
    c.value:"code"::STRING LIKE 'A61%'
    AND f.value:"name"::STRING = 'PROCTER & GAMBLE'
    AND t."filing_date" IS NOT NULL
    AND t."filing_date" != 0
GROUP BY
    "Year"
ORDER BY
    COUNT(*) DESC NULLS LAST
LIMIT 1;