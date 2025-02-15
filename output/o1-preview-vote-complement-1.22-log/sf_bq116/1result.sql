SELECT s."stprba" AS State, ROUND(SUM(n."VALUE") / 1000000000.0, 4) AS Highest_Annual_Revenue_Billions
FROM SEC_QUARTERLY_FINANCIALS.SEC_QUARTERLY_FINANCIALS.NUMBERS n
JOIN SEC_QUARTERLY_FINANCIALS.SEC_QUARTERLY_FINANCIALS.MEASURE_TAG mt
  ON n."MEASURE_TAG" = mt."MEASURE_TAG"
JOIN SEC_QUARTERLY_FINANCIALS.SEC_QUARTERLY_FINANCIALS.SUBMISSION s
  ON n."SUBMISSION_NUMBER" = s."submission_number"
WHERE s."fiscal_year" = 2016
  AND s."countryba" = 'US'
  AND n."NUMBER_OF_QUARTERS" = 4
  AND mt."TAG_LABEL" ILIKE '%Revenue%'
GROUP BY s."stprba"
ORDER BY Highest_Annual_Revenue_Billions DESC NULLS LAST
LIMIT 1;