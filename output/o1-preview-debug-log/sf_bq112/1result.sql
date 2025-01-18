WITH
wages_1998 AS (
    SELECT AVG("avg_wkly_wage_10_total_all_industries") AS "avg_wage_1998"
    FROM (
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_1998_Q1"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_1998_Q2"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_1998_Q3"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_1998_Q4"
        WHERE "area_fips" = '42003'
    )
),
wages_2017 AS (
    SELECT AVG("avg_wkly_wage_10_total_all_industries") AS "avg_wage_2017"
    FROM (
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_2017_Q1"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_2017_Q2"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_2017_Q3"
        WHERE "area_fips" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM "BLS"."BLS_QCEW"."_2017_Q4"
        WHERE "area_fips" = '42003'
    )
),
cpi_1998 AS (
    SELECT AVG("value") AS "average_cpi_1998"
    FROM "BLS"."BLS"."CPI_U"
    WHERE "year" = 1998 AND "item_name" = 'All items'
),
cpi_2017 AS (
    SELECT AVG("value") AS "average_cpi_2017"
    FROM "BLS"."BLS"."CPI_U"
    WHERE "year" = 2017 AND "item_name" = 'All items'
),
growth_rates AS (
    SELECT
        ((w2017."avg_wage_2017" - w1998."avg_wage_1998") / w1998."avg_wage_1998") * 100 AS "wage_growth_rate",
        ((c2017."average_cpi_2017" - c1998."average_cpi_1998") / c1998."average_cpi_1998") * 100 AS "cpi_growth_rate"
    FROM
        wages_1998 w1998,
        wages_2017 w2017,
        cpi_1998 c1998,
        cpi_2017 c2017
)
SELECT
    ROUND("wage_growth_rate", 4) AS "Wage Growth Rate (%)",
    ROUND("cpi_growth_rate", 4) AS "CPI Inflation Rate (%)"
FROM
    growth_rates;