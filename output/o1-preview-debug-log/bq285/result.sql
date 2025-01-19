SELECT zip_code, COUNT(DISTINCT fdic_certificate_number) AS Number_of_Institutions
FROM `bigquery-public-data.fdic_banks.locations`
WHERE state_name = 'Florida'
GROUP BY zip_code
ORDER BY Number_of_Institutions DESC
LIMIT 1;