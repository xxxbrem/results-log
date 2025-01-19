SELECT
    ROUND(AVG(total_lifetime_sales), 4) AS Average_LTV,
    ROUND(AVG(Percentage_First_7_Days), 4) || '%' AS Avg_Percentage_First_7_Days,
    ROUND(AVG(Percentage_First_30_Days), 4) || '%' AS Avg_Percentage_First_30_Days
FROM
    (
        SELECT
            c.customer_id,
            c.total_lifetime_sales,
            (IFNULL(s7.sales_first_7_days, 0) * 100.0 / c.total_lifetime_sales) AS Percentage_First_7_Days,
            (IFNULL(s30.sales_first_30_days, 0) * 100.0 / c.total_lifetime_sales) AS Percentage_First_30_Days
        FROM
            (
                SELECT
                    customer_id,
                    MIN(payment_date) AS initial_purchase_date,
                    SUM(amount) AS total_lifetime_sales
                FROM
                    payment
                GROUP BY
                    customer_id
                HAVING
                    SUM(amount) > 0
            ) c
        LEFT JOIN
            (
                SELECT
                    p.customer_id,
                    SUM(p.amount) AS sales_first_7_days
                FROM
                    payment p
                JOIN
                    (
                        SELECT
                            customer_id,
                            MIN(payment_date) AS initial_purchase_date
                        FROM
                            payment
                        GROUP BY
                            customer_id
                    ) ip ON p.customer_id = ip.customer_id
                WHERE
                    p.payment_date BETWEEN ip.initial_purchase_date AND DATETIME(ip.initial_purchase_date, '+7 days')
                GROUP BY
                    p.customer_id
            ) s7 ON c.customer_id = s7.customer_id
        LEFT JOIN
            (
                SELECT
                    p.customer_id,
                    SUM(p.amount) AS sales_first_30_days
                FROM
                    payment p
                JOIN
                    (
                        SELECT
                            customer_id,
                            MIN(payment_date) AS initial_purchase_date
                        FROM
                            payment
                        GROUP BY
                            customer_id
                    ) ip ON p.customer_id = ip.customer_id
                WHERE
                    p.payment_date BETWEEN ip.initial_purchase_date AND DATETIME(ip.initial_purchase_date, '+30 days')
                GROUP BY
                    p.customer_id
            ) s30 ON c.customer_id = s30.customer_id
    );