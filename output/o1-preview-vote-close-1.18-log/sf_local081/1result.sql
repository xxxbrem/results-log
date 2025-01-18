WITH all_customers AS (
    SELECT "customerid"
    FROM NORTHWIND.NORTHWIND.CUSTOMERS
),
customer_spending AS (
    SELECT o."customerid", SUM(od."unitprice" * od."quantity" * (1 - od."discount")) AS total_spent
    FROM NORTHWIND.NORTHWIND.ORDERS o
    JOIN NORTHWIND.NORTHWIND.ORDER_DETAILS od ON o."orderid" = od."orderid"
    WHERE EXTRACT(YEAR FROM TRY_TO_DATE(o."orderdate", 'YYYY-MM-DD')) = 1998
    GROUP BY o."customerid"
),
customer_totals AS (
    SELECT ac."customerid", COALESCE(cs.total_spent, 0) AS total_spent
    FROM all_customers ac
    LEFT JOIN customer_spending cs ON ac."customerid" = cs."customerid"
),
customer_groups AS (
    SELECT ct."customerid", ct.total_spent, cgt."groupname"
    FROM customer_totals ct
    JOIN NORTHWIND.NORTHWIND.CUSTOMERGROUPTHRESHOLD cgt
        ON ct.total_spent >= cgt."rangebottom" AND ct.total_spent < cgt."rangetop"
)
SELECT
    cg."groupname" AS "SpendingGroup",
    COUNT(DISTINCT cg."customerid") AS "CustomerCount",
    ROUND(COUNT(DISTINCT cg."customerid") * 100.0 / (SELECT COUNT(*) FROM all_customers), 4) AS "PercentageOfTotalCustomers"
FROM customer_groups cg
GROUP BY cg."groupname"
ORDER BY cg."groupname";