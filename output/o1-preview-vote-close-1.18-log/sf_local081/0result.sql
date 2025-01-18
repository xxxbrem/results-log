WITH CustomerSpending AS (
  SELECT
    O."customerid",
    SUM(OD."unitprice" * OD."quantity" * (1 - OD."discount")) AS "TotalSpending"
  FROM
    "NORTHWIND"."NORTHWIND"."ORDERS" O
    JOIN "NORTHWIND"."NORTHWIND"."ORDER_DETAILS" OD ON O."orderid" = OD."orderid"
  WHERE
    YEAR(TRY_TO_DATE(O."orderdate", 'YYYY-MM-DD')) = 1998
  GROUP BY
    O."customerid"
),
CustomerGroups AS (
  SELECT
    CS."customerid",
    CGT."groupname"
  FROM
    CustomerSpending CS
    JOIN "NORTHWIND"."NORTHWIND"."CUSTOMERGROUPTHRESHOLD" CGT
      ON CS."TotalSpending" >= CGT."rangebottom" AND CS."TotalSpending" <= CGT."rangetop"
)
SELECT
  CGT."groupname" AS "SpendingGroup",
  COUNT(DISTINCT CG."customerid") AS "NumberOfCustomers",
  ROUND(
    COUNT(DISTINCT CG."customerid") * 100.0 / (
      SELECT COUNT(*) FROM "NORTHWIND"."NORTHWIND"."CUSTOMERS"
    ),
    4
  ) AS "PercentageOfTotalCustomers"
FROM
  "NORTHWIND"."NORTHWIND"."CUSTOMERGROUPTHRESHOLD" CGT
  LEFT JOIN CustomerGroups CG ON CG."groupname" = CGT."groupname"
GROUP BY
  CGT."groupname", CGT."rangebottom"
ORDER BY
  CGT."rangebottom" ASC;