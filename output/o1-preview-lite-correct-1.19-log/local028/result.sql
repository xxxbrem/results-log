WITH months (Month_num, Month) AS (
    SELECT '01', 'Jan' UNION ALL
    SELECT '02', 'Feb' UNION ALL
    SELECT '03', 'Mar' UNION ALL
    SELECT '04', 'Apr' UNION ALL
    SELECT '05', 'May' UNION ALL
    SELECT '06', 'Jun' UNION ALL
    SELECT '07', 'Jul' UNION ALL
    SELECT '08', 'Aug' UNION ALL
    SELECT '09', 'Sep' UNION ALL
    SELECT '10', 'Oct' UNION ALL
    SELECT '11', 'Nov' UNION ALL
    SELECT '12', 'Dec'
),
deliveries AS (
    SELECT
        strftime('%m', "order_delivered_customer_date") as Month_num,
        strftime('%Y', "order_delivered_customer_date") as Year,
        COUNT(*) as Num_orders
    FROM
        "olist_orders"
    WHERE
        "order_status" = 'delivered' AND
        "order_delivered_customer_date" IS NOT NULL
    GROUP BY
        Year,
        Month_num
)
SELECT
    m.Month_num,
    m.Month,
    COALESCE(d2016.Num_orders, 0) as "2016",
    COALESCE(d2017.Num_orders, 0) as "2017",
    COALESCE(d2018.Num_orders, 0) as "2018"
FROM
    months m
LEFT JOIN
    (SELECT Month_num, Num_orders FROM deliveries WHERE Year = '2016') d2016
    ON m.Month_num = d2016.Month_num
LEFT JOIN
    (SELECT Month_num, Num_orders FROM deliveries WHERE Year = '2017') d2017
    ON m.Month_num = d2017.Month_num
LEFT JOIN
    (SELECT Month_num, Num_orders FROM deliveries WHERE Year = '2018') d2018
    ON m.Month_num = d2018.Month_num
ORDER BY
    m.Month_num;