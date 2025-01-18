SELECT
    cgt."groupname" AS "GroupName",
    COUNT(DISTINCT cws."customerid") AS "NumberOfCustomers",
    ROUND(
        (COUNT(DISTINCT cws."customerid") * 100.0) / (
            SELECT COUNT(DISTINCT "customerid") FROM NORTHWIND.NORTHWIND."CUSTOMERS"
        ),
        4
    ) AS "PercentageOfTotalCustomers"
FROM
    (
        SELECT
            c."customerid",
            COALESCE(cts."total_spent", 0) AS "total_spent"
        FROM
            NORTHWIND.NORTHWIND."CUSTOMERS" c
        LEFT JOIN
            (
                SELECT
                    o."customerid",
                    SUM(od."unitprice" * od."quantity" * (1 - od."discount")) AS "total_spent"
                FROM
                    NORTHWIND.NORTHWIND."ORDERS" o
                JOIN
                    NORTHWIND.NORTHWIND."ORDER_DETAILS" od ON o."orderid" = od."orderid"
                WHERE
                    TRY_TO_DATE(o."orderdate", 'YYYY-MM-DD') >= '1998-01-01'
                    AND TRY_TO_DATE(o."orderdate", 'YYYY-MM-DD') <= '1998-12-31'
                GROUP BY
                    o."customerid"
            ) cts ON c."customerid" = cts."customerid"
    ) cws
JOIN
    NORTHWIND.NORTHWIND."CUSTOMERGROUPTHRESHOLD" cgt
ON
    cws."total_spent" >= cgt."rangebottom" AND cws."total_spent" < cgt."rangetop"
GROUP BY
    cgt."groupname"
ORDER BY
    cgt."groupname";