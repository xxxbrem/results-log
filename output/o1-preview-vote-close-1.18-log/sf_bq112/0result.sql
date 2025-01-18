WITH wage_1998 AS (
    SELECT AVG("avg_wkly_wage_10_total_all_industries") AS wage
    FROM (
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q1"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q2"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q3"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q4"
        WHERE "area_fips" = '42003'
    ) AS w
),
wage_2017 AS (
    SELECT AVG("avg_wkly_wage_10_total_all_industries") AS wage
    FROM (
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q1"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q2"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q3"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q4"
        WHERE "area_fips" = '42003'
    ) AS w
),
cpi_1998 AS (
    SELECT AVG("value") AS cpi
    FROM BLS.BLS."CPI_U"
    WHERE "year" = 1998 AND "item_name" = 'All items' AND "area_name" = 'U.S. city average' AND "period" = 'M13'
),
cpi_2017 AS (
    SELECT AVG("value") AS cpi
    FROM BLS.BLS."CPI_U"
    WHERE "year" = 2017 AND "item_name" = 'All items' AND "area_name" = 'U.S. city average' AND "period" = 'M13'
)
SELECT
    ROUND(((wage_2017.wage - wage_1998.wage) / wage_1998.wage) * 100, 4) AS "Wage_growth_rate",
    ROUND(((cpi_2017.cpi - cpi_1998.cpi) / cpi_1998.cpi) * 100, 4) AS "Inflation_rate"
FROM
    wage_1998, wage_2017, cpi_1998, cpi_2017;