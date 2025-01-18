SELECT
    ROUND(((w17."avg_wage" - w98."avg_wage") / w98."avg_wage") * 100, 4) AS "Wage_growth_rate",
    ROUND(((cpi17."cpi_value" - cpi98."cpi_value") / cpi98."cpi_value") * 100, 4) AS "Inflation_rate"
FROM
    (SELECT AVG("avg_wkly_wage_10_total_all_industries") AS "avg_wage"
     FROM (
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q1" WHERE "area_fips" = '42003'
         UNION ALL
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q2" WHERE "area_fips" = '42003'
         UNION ALL
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q3" WHERE "area_fips" = '42003'
         UNION ALL
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_1998_Q4" WHERE "area_fips" = '42003'
     )) w98,
    (SELECT AVG("avg_wkly_wage_10_total_all_industries") AS "avg_wage"
     FROM (
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q1" WHERE "area_fips" = '42003'
         UNION ALL
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q2" WHERE "area_fips" = '42003'
         UNION ALL
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q3" WHERE "area_fips" = '42003'
         UNION ALL
         SELECT "avg_wkly_wage_10_total_all_industries" FROM BLS.BLS_QCEW."_2017_Q4" WHERE "area_fips" = '42003'
     )) w17,
    (SELECT "value" AS "cpi_value"
     FROM BLS.BLS."CPI_U"
     WHERE "item_name" = 'All items'
       AND "area_name" = 'U.S. city average'
       AND "year" = 1998
       AND "period" = 'M13') cpi98,
    (SELECT "value" AS "cpi_value"
     FROM BLS.BLS."CPI_U"
     WHERE "item_name" = 'All items'
       AND "area_name" = 'U.S. city average'
       AND "year" = 2017
       AND "period" = 'M13') cpi17;