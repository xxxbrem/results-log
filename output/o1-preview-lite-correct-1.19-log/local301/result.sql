WITH week_periods AS (
    SELECT 2018 AS "calendar_year", '2018-05-14' AS "week_date", 'Before' AS "Period" UNION ALL
    SELECT 2018, '2018-05-21', 'Before' UNION ALL
    SELECT 2018, '2018-05-28', 'Before' UNION ALL
    SELECT 2018, '2018-06-04', 'Before' UNION ALL
    SELECT 2018, '2018-06-11', 'After' UNION ALL
    SELECT 2018, '2018-06-18', 'After' UNION ALL
    SELECT 2018, '2018-06-25', 'After' UNION ALL
    SELECT 2018, '2018-07-02', 'After' UNION ALL
    SELECT 2019, '2019-05-13', 'Before' UNION ALL
    SELECT 2019, '2019-05-20', 'Before' UNION ALL
    SELECT 2019, '2019-05-27', 'Before' UNION ALL
    SELECT 2019, '2019-06-03', 'Before' UNION ALL
    SELECT 2019, '2019-06-10', 'After' UNION ALL
    SELECT 2019, '2019-06-17', 'After' UNION ALL
    SELECT 2019, '2019-06-24', 'After' UNION ALL
    SELECT 2019, '2019-07-01', 'After' UNION ALL
    SELECT 2020, '2020-05-18', 'Before' UNION ALL
    SELECT 2020, '2020-05-25', 'Before' UNION ALL
    SELECT 2020, '2020-06-01', 'Before' UNION ALL
    SELECT 2020, '2020-06-08', 'Before' UNION ALL
    SELECT 2020, '2020-06-15', 'After' UNION ALL
    SELECT 2020, '2020-06-22', 'After' UNION ALL
    SELECT 2020, '2020-06-29', 'After' UNION ALL
    SELECT 2020, '2020-07-06', 'After'
)

SELECT
    s."calendar_year" AS Year,
    SUM(CASE WHEN wp."Period" = 'Before' THEN s."sales" ELSE 0 END) AS Sales_Before,
    SUM(CASE WHEN wp."Period" = 'After' THEN s."sales" ELSE 0 END) AS Sales_After,
    ROUND(
        100.0 * (
            SUM(CASE WHEN wp."Period" = 'After' THEN s."sales" ELSE 0 END) - 
            SUM(CASE WHEN wp."Period" = 'Before' THEN s."sales" ELSE 0 END)
        ) / NULLIF(SUM(CASE WHEN wp."Period" = 'Before' THEN s."sales" ELSE 0 END), 0),
        4
    ) AS Percentage_Change
FROM
    "cleaned_weekly_sales" AS s
INNER JOIN
    week_periods AS wp
ON
    s."calendar_year" = wp."calendar_year" AND s."week_date" = wp."week_date"
GROUP BY
    s."calendar_year"
ORDER BY
    s."calendar_year";