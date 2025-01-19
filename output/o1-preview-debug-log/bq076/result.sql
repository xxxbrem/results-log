SELECT 
  EXTRACT(MONTH FROM `date`) AS Month_num,
  FORMAT_DATE('%B', DATE_TRUNC(CAST(`date` AS DATE), MONTH)) AS Month_name,
  COUNT(*) AS MV_Thefts
FROM `bigquery-public-data.chicago_crime.crime`
WHERE `year` = 2016 AND LOWER(`primary_type`) = 'motor vehicle theft'
GROUP BY Month_num, Month_name
ORDER BY MV_Thefts DESC
LIMIT 1;