WITH wage_data AS (
  SELECT "year", AVG("annual_wage") AS "annual_wage"
  FROM (
    SELECT 1998 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_1998_Q1"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 1998 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_1998_Q2"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 1998 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_1998_Q3"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 1998 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_1998_Q4"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 2017 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_2017_Q1"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 2017 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_2017_Q2"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 2017 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_2017_Q3"
    WHERE "area_fips" = '42003'
    UNION ALL
    SELECT 2017 AS "year", "avg_wkly_wage_10_total_all_industries" * 52 AS "annual_wage"
    FROM BLS.BLS_QCEW."_2017_Q4"
    WHERE "area_fips" = '42003'
  ) AS annual_wages
  GROUP BY "year"
),
cpi_data AS (
  SELECT "year", AVG("value") AS "average_cpi"
  FROM BLS.BLS."CPI_U"
  WHERE "item_name" = 'All items'
    AND "area_name" = 'U.S. city average'
    AND "year" IN (1998, 2017)
    AND "value" IS NOT NULL
  GROUP BY "year"
)
SELECT 
  ROUND(((w17."annual_wage" - w98."annual_wage") / w98."annual_wage") * 100, 2) AS "Wage_growth_rate",
  ROUND(((c17."average_cpi" - c98."average_cpi") / c98."average_cpi") * 100, 2) AS "Inflation_rate"
FROM 
  (SELECT * FROM wage_data WHERE "year" = 1998) w98
  CROSS JOIN (SELECT * FROM wage_data WHERE "year" = 2017) w17
  CROSS JOIN (SELECT * FROM cpi_data WHERE "year" = 1998) c98
  CROSS JOIN (SELECT * FROM cpi_data WHERE "year" = 2017) c17;