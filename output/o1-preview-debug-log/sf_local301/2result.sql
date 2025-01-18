WITH sales_before AS (
    SELECT
        "calendar_year" AS "Year",
        SUM("sales") AS "Sales_Before_June15"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
    WHERE
        "calendar_year" IN (2018, 2019, 2020) AND
        TO_DATE("week_date", 'YYYY-MM-DD') >= CASE
            WHEN "calendar_year" = 2018 THEN '2018-05-21'
            WHEN "calendar_year" = 2019 THEN '2019-05-20'
            WHEN "calendar_year" = 2020 THEN '2020-05-18'
        END AND
        TO_DATE("week_date", 'YYYY-MM-DD') < CASE
            WHEN "calendar_year" = 2018 THEN '2018-06-15'
            WHEN "calendar_year" = 2019 THEN '2019-06-15'
            WHEN "calendar_year" = 2020 THEN '2020-06-15'
        END
    GROUP BY
        "calendar_year"
),
sales_after AS (
    SELECT
        "calendar_year" AS "Year",
        SUM("sales") AS "Sales_After_June15"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
    WHERE
        "calendar_year" IN (2018, 2019, 2020) AND
        TO_DATE("week_date", 'YYYY-MM-DD') >= CASE
            WHEN "calendar_year" = 2018 THEN '2018-06-15'
            WHEN "calendar_year" = 2019 THEN '2019-06-15'
            WHEN "calendar_year" = 2020 THEN '2020-06-15'
        END AND
        TO_DATE("week_date", 'YYYY-MM-DD') < CASE
            WHEN "calendar_year" = 2018 THEN '2018-07-13'
            WHEN "calendar_year" = 2019 THEN '2019-07-13'
            WHEN "calendar_year" = 2020 THEN '2020-07-13'
        END
    GROUP BY
        "calendar_year"
)
SELECT
    before."Year",
    before."Sales_Before_June15",
    after."Sales_After_June15",
    ROUND(
        100.0 * (after."Sales_After_June15" - before."Sales_Before_June15") 
        / NULLIF(before."Sales_Before_June15", 0), 
        4
    ) AS "Percentage_Change"
FROM
    sales_before AS before
    JOIN sales_after AS after ON before."Year" = after."Year"
ORDER BY
    before."Year";