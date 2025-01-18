SELECT
  "employeeid" AS "EmployeeID",
  SUM(
    CASE
      WHEN TRY_TO_DATE("shippeddate", 'YYYY-MM-DD') > TRY_TO_DATE("requireddate", 'YYYY-MM-DD') THEN 1
      ELSE 0
    END
  ) AS "NumberOfLateOrders",
  ROUND(
    (SUM(
      CASE
        WHEN TRY_TO_DATE("shippeddate", 'YYYY-MM-DD') > TRY_TO_DATE("requireddate", 'YYYY-MM-DD') THEN 1.0
        ELSE 0.0
      END
    ) / COUNT(*)) * 100,
    4
  ) AS "LateOrderPercentage"
FROM
  NORTHWIND.NORTHWIND.ORDERS
WHERE
  TRY_TO_DATE("shippeddate", 'YYYY-MM-DD') IS NOT NULL
  AND TRY_TO_DATE("requireddate", 'YYYY-MM-DD') IS NOT NULL
GROUP BY
  "employeeid"
HAVING
  COUNT(*) > 50
ORDER BY
  "LateOrderPercentage" DESC NULLS LAST
LIMIT 3;