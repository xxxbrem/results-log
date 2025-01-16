SELECT COUNT(*) AS "number_of_patents"
FROM (
    SELECT t."publication_number"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."claims_localized") f
    WHERE
        t."country_code" = 'US' AND
        t."kind_code" = 'B2' AND
        TRY_TO_DATE(t."grant_date"::VARCHAR, 'YYYYMMDD') BETWEEN '2008-01-01' AND '2018-12-31'
    GROUP BY t."publication_number"
    HAVING MAX(CASE WHEN f.value:"text"::STRING ILIKE '%claim%' THEN 1 ELSE 0 END) = 0
) AS sub;