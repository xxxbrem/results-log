WITH date_ranges AS (
  SELECT
    '2018' AS "year",
    TO_DATE('2018-06-15', 'YYYY-MM-DD') - INTERVAL '28 DAYS' AS "before_start",
    TO_DATE('2018-06-15', 'YYYY-MM-DD') - INTERVAL '1 DAY' AS "before_end",
    TO_DATE('2018-06-15', 'YYYY-MM-DD') AS "after_start",
    TO_DATE('2018-06-15', 'YYYY-MM-DD') + INTERVAL '27 DAYS' AS "after_end"
  UNION ALL
  SELECT
    '2019',
    TO_DATE('2019-06-15', 'YYYY-MM-DD') - INTERVAL '28 DAYS',
    TO_DATE('2019-06-15', 'YYYY-MM-DD') - INTERVAL '1 DAY',
    TO_DATE('2019-06-15', 'YYYY-MM-DD'),
    TO_DATE('2019-06-15', 'YYYY-MM-DD') + INTERVAL '27 DAYS'
  UNION ALL
  SELECT
    '2020',
    TO_DATE('2020-06-15', 'YYYY-MM-DD') - INTERVAL '28 DAYS',
    TO_DATE('2020-06-15', 'YYYY-MM-DD') - INTERVAL '1 DAY',
    TO_DATE('2020-06-15', 'YYYY-MM-DD'),
    TO_DATE('2020-06-15', 'YYYY-MM-DD') + INTERVAL '27 DAYS'
),
sales_data AS (
  SELECT
    TO_DATE("week_date", 'YYYY-MM-DD') AS "week_date_parsed",
    TO_CHAR("calendar_year") AS "year",
    "sales"
  FROM
    BANK_SALES_TRADING.BANK_SALES_TRADING.CLEANED_WEEKLY_SALES
)
SELECT
  dr."year",
  SUM(CASE WHEN sd."week_date_parsed" BETWEEN dr."before_start" AND dr."before_end" THEN sd."sales" END) AS "sales_before",
  SUM(CASE WHEN sd."week_date_parsed" BETWEEN dr."after_start" AND dr."after_end" THEN sd."sales" END) AS "sales_after",
  ROUND(
    (SUM(CASE WHEN sd."week_date_parsed" BETWEEN dr."after_start" AND dr."after_end" THEN sd."sales" END) - 
     SUM(CASE WHEN sd."week_date_parsed" BETWEEN dr."before_start" AND dr."before_end" THEN sd."sales" END)) /
    NULLIF(SUM(CASE WHEN sd."week_date_parsed" BETWEEN dr."before_start" AND dr."before_end" THEN sd."sales" END), 0) * 100, 4
  ) AS "percent_change"
FROM
  date_ranges dr
LEFT JOIN
  sales_data sd ON sd."year" = dr."year"
GROUP BY
  dr."year"
ORDER BY
  dr."year";