SELECT
    "calendar_year" AS "Year",
    SUM(
        CASE 
            WHEN TO_DATE("week_date", 'YYYY-MM-DD') >= DATEADD(day, -28, DATE_FROM_PARTS("calendar_year", 6, 15))
             AND TO_DATE("week_date", 'YYYY-MM-DD') < DATE_FROM_PARTS("calendar_year", 6, 15)
            THEN "sales" ELSE 0 
        END
    ) AS "Sales_Before",
    SUM(
        CASE 
            WHEN TO_DATE("week_date", 'YYYY-MM-DD') >= DATE_FROM_PARTS("calendar_year", 6, 15)
             AND TO_DATE("week_date", 'YYYY-MM-DD') < DATEADD(day, 28, DATE_FROM_PARTS("calendar_year", 6, 15))
            THEN "sales" ELSE 0 
        END
    ) AS "Sales_After",
    ROUND(
        (
            SUM(
                CASE 
                    WHEN TO_DATE("week_date", 'YYYY-MM-DD') >= DATE_FROM_PARTS("calendar_year", 6, 15)
                     AND TO_DATE("week_date", 'YYYY-MM-DD') < DATEADD(day, 28, DATE_FROM_PARTS("calendar_year", 6, 15))
                    THEN "sales" ELSE 0 
                END
            ) -
            SUM(
                CASE 
                    WHEN TO_DATE("week_date", 'YYYY-MM-DD') >= DATEADD(day, -28, DATE_FROM_PARTS("calendar_year", 6, 15))
                     AND TO_DATE("week_date", 'YYYY-MM-DD') < DATE_FROM_PARTS("calendar_year", 6, 15)
                    THEN "sales" ELSE 0 
                END
            )
        ) / NULLIF(
            SUM(
                CASE 
                    WHEN TO_DATE("week_date", 'YYYY-MM-DD') >= DATEADD(day, -28, DATE_FROM_PARTS("calendar_year", 6, 15))
                     AND TO_DATE("week_date", 'YYYY-MM-DD') < DATE_FROM_PARTS("calendar_year", 6, 15)
                    THEN "sales" ELSE 0 
                END
            ), 0
        ) * 100,
        4
    ) AS "Percentage_Change"
FROM
    "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
WHERE
    TO_DATE("week_date", 'YYYY-MM-DD') >= DATEADD(day, -28, DATE_FROM_PARTS("calendar_year", 6, 15))
    AND TO_DATE("week_date", 'YYYY-MM-DD') < DATEADD(day, 28, DATE_FROM_PARTS("calendar_year", 6, 15))
    AND "calendar_year" IN (2018, 2019, 2020)
GROUP BY
    "calendar_year"
ORDER BY
    "calendar_year";