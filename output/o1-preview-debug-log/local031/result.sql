WITH annual_volumes AS (
    SELECT
        strftime('%Y', "order_delivered_customer_date") AS "Year",
        COUNT(*) AS "Total_Orders"
    FROM "olist_orders"
    WHERE
        "order_status" = 'delivered' 
        AND "order_delivered_customer_date" IS NOT NULL
        AND strftime('%Y', "order_delivered_customer_date") IN ('2016', '2017', '2018')
    GROUP BY "Year"
),
lowest_year AS (
    SELECT "Year"
    FROM annual_volumes
    ORDER BY "Total_Orders" ASC
    LIMIT 1
),
monthly_volumes AS (
    SELECT
        strftime('%Y', "order_delivered_customer_date") AS "Year",
        strftime('%m', "order_delivered_customer_date") AS "Month_num",
        CASE strftime('%m', "order_delivered_customer_date")
            WHEN '01' THEN 'January'
            WHEN '02' THEN 'February'
            WHEN '03' THEN 'March'
            WHEN '04' THEN 'April'
            WHEN '05' THEN 'May'
            WHEN '06' THEN 'June'
            WHEN '07' THEN 'July'
            WHEN '08' THEN 'August'
            WHEN '09' THEN 'September'
            WHEN '10' THEN 'October'
            WHEN '11' THEN 'November'
            WHEN '12' THEN 'December'
        END AS "Month",
        COUNT(*) AS "Monthly_Total_Orders"
    FROM "olist_orders"
    WHERE
        "order_status" = 'delivered' 
        AND "order_delivered_customer_date" IS NOT NULL
        AND strftime('%Y', "order_delivered_customer_date") = (SELECT "Year" FROM lowest_year)
    GROUP BY "Month_num"
)
SELECT
    m."Year",
    CAST(m."Month_num" AS INTEGER) AS "Month_num",
    m."Month",
    m."Monthly_Total_Orders" AS "Highest_Monthly_Delivered_Orders_Volume"
FROM monthly_volumes m
ORDER BY m."Monthly_Total_Orders" DESC, m."Month_num" DESC
LIMIT 1;