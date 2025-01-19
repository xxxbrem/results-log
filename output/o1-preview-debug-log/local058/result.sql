SELECT
    hdp."segment" AS Segment,
    COUNT(DISTINCT CASE WHEN hfs."fiscal_year" = 2020 THEN hfs."product_code" END) AS Product_Count_2020,
    ROUND(
        (
            (COUNT(DISTINCT CASE WHEN hfs."fiscal_year" = 2021 THEN hfs."product_code" END) -
            COUNT(DISTINCT CASE WHEN hfs."fiscal_year" = 2020 THEN hfs."product_code" END)
            ) * 100.0 /
            NULLIF(COUNT(DISTINCT CASE WHEN hfs."fiscal_year" = 2020 THEN hfs."product_code" END), 0)
        ), 4
    ) AS Percentage_Increase
FROM
    "hardware_fact_sales_monthly" AS hfs
JOIN
    "hardware_dim_product" AS hdp ON hfs."product_code" = hdp."product_code"
GROUP BY
    hdp."segment"
ORDER BY
    Percentage_Increase DESC;