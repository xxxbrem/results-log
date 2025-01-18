SELECT
    "year",
    SUM(CASE WHEN "period" = 'pre_june15' THEN "sales" ELSE 0 END) AS pre_june15_sales,
    SUM(CASE WHEN "period" = 'post_june15' THEN "sales" ELSE 0 END) AS post_june15_sales,
    ROUND(
        (
            SUM(CASE WHEN "period" = 'post_june15' THEN "sales" ELSE 0 END) - 
            SUM(CASE WHEN "period" = 'pre_june15' THEN "sales" ELSE 0 END)
        ) / NULLIF(SUM(CASE WHEN "period" = 'pre_june15' THEN "sales" ELSE 0 END), 0) * 100, 4
    ) AS percentage_change
FROM (
    SELECT
        (2000 + TO_NUMBER(RIGHT("week_date", 2))) AS "year",
        "sales",
        CASE
            WHEN ("week_date" IN ('14/5/18', '21/5/18', '28/5/18', '4/6/18') AND RIGHT("week_date", 2) = '18')
                THEN 'pre_june15'
            WHEN ("week_date" IN ('13/5/19', '20/5/19', '27/5/19', '3/6/19') AND RIGHT("week_date", 2) = '19')
                THEN 'pre_june15'
            WHEN ("week_date" IN ('11/5/20', '18/5/20', '25/5/20', '1/6/20') AND RIGHT("week_date", 2) = '20')
                THEN 'pre_june15'
            WHEN ("week_date" IN ('18/6/18', '25/6/18', '2/7/18', '9/7/18') AND RIGHT("week_date", 2) = '18')
                THEN 'post_june15'
            WHEN ("week_date" IN ('17/6/19', '24/6/19', '1/7/19', '8/7/19') AND RIGHT("week_date", 2) = '19')
                THEN 'post_june15'
            WHEN ("week_date" IN ('15/6/20', '22/6/20', '29/6/20', '6/7/20') AND RIGHT("week_date", 2) = '20')
                THEN 'post_june15'
            ELSE NULL
        END AS "period"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."WEEKLY_SALES"
    WHERE RIGHT("week_date", 2) IN ('18', '19', '20')
) sub
WHERE "period" IS NOT NULL
GROUP BY "year"
ORDER BY "year";