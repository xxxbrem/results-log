SELECT "employeeid", 
       COUNT(CASE WHEN TRY_TO_DATE("shippeddate", 'YYYY-MM-DD') > TRY_TO_DATE("requireddate", 'YYYY-MM-DD') THEN 1 END) AS "late_orders", 
       COUNT(*) AS "total_orders", 
       ROUND((COUNT(CASE WHEN TRY_TO_DATE("shippeddate", 'YYYY-MM-DD') > TRY_TO_DATE("requireddate", 'YYYY-MM-DD') THEN 1 END) * 100.0 / COUNT(*)), 4) AS "percentage_late"
FROM "NORTHWIND"."NORTHWIND"."ORDERS"
WHERE "shippeddate" IS NOT NULL AND "shippeddate" <> '' AND TRY_TO_DATE("shippeddate", 'YYYY-MM-DD') IS NOT NULL
  AND "requireddate" IS NOT NULL AND "requireddate" <> '' AND TRY_TO_DATE("requireddate", 'YYYY-MM-DD') IS NOT NULL
GROUP BY "employeeid"
HAVING COUNT(*) > 50
ORDER BY "percentage_late" DESC NULLS LAST
LIMIT 3;