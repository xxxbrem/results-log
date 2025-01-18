WITH wage_data AS (
  SELECT
    (
      SELECT AVG("avg_wkly_wage_10_total_all_industries")
      FROM (
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q1" WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q2" WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q3" WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q4" WHERE "area_fips" = '42003'
      )
    ) AS wage_1998,
    (
      SELECT AVG("avg_wkly_wage_10_total_all_industries")
      FROM (
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q1" WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q2" WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q3" WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q4" WHERE "area_fips" = '42003'
      )
    ) AS wage_2017
),
cpi_data AS (
  SELECT 
    (SELECT AVG("value") 
     FROM BLS.BLS.CPI_U
     WHERE "item_name" = 'All items'
       AND "area_name" = 'U.S. city average'
       AND "year" = 1998) AS CPI_1998,
    (SELECT AVG("value") 
     FROM BLS.BLS.CPI_U
     WHERE "item_name" = 'All items'
       AND "area_name" = 'U.S. city average'
       AND "year" = 2017) AS CPI_2017
)
SELECT 
  ROUND((wage_2017 - wage_1998) / wage_1998 * 100, 4) AS "Wage_growth_rate",
  ROUND((CPI_2017 - CPI_1998) / CPI_1998 * 100, 4) AS "Inflation_rate"
FROM wage_data, cpi_data;