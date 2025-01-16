SELECT 
  EXTRACT(MONTH FROM CASE 
    WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1000000) 
    WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1000) 
    ELSE TO_TIMESTAMP_NTZ("date") 
  END) AS "Month_num",
  TO_VARCHAR(CASE 
    WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1000000) 
    WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1000) 
    ELSE TO_TIMESTAMP_NTZ("date") 
  END, 'Month') AS "Month",
  COUNT(*) AS "Number_of_Motor_Vehicle_Thefts"
FROM CHICAGO.CHICAGO_CRIME.CRIME
WHERE "primary_type" = 'MOTOR VEHICLE THEFT' AND "year" = 2016
GROUP BY "Month_num", "Month"
ORDER BY "Number_of_Motor_Vehicle_Thefts" DESC NULLS LAST
LIMIT 1;