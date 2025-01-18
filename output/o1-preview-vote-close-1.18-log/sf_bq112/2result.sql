WITH wage_1998 AS (
    SELECT AVG("avg_wkly_wage_10_total_all_industries") AS avg_wage_1998
    FROM (
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q1"
        WHERE "geoid" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q2"
        WHERE "geoid" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q3"
        WHERE "geoid" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_1998_Q4"
        WHERE "geoid" = '42003'
    ) AS wages_1998
),
wage_2017 AS (
    SELECT AVG("avg_wkly_wage_10_total_all_industries") AS avg_wage_2017
    FROM (
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q1"
        WHERE "geoid" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q2"
        WHERE "geoid" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q3"
        WHERE "geoid" = '42003'
        UNION ALL
        SELECT "avg_wkly_wage_10_total_all_industries"
        FROM BLS.BLS_QCEW."_2017_Q4"
        WHERE "geoid" = '42003'
    ) AS wages_2017
),
cpi_1998 AS (
    SELECT AVG("value") AS avg_cpi_1998
    FROM BLS.BLS."CPI_U"
    WHERE "item_name" = 'All items'
      AND "area_name" = 'Pittsburgh, PA'
      AND "year" = 1998
),
cpi_2017 AS (
    SELECT AVG("value") AS avg_cpi_2017
    FROM BLS.BLS."CPI_U"
    WHERE "item_name" = 'All items'
      AND "area_name" = 'Pittsburgh, PA'
      AND "year" = 2017
)
SELECT
    ROUND(100 * (w17.avg_wage_2017 - w98.avg_wage_1998) / w98.avg_wage_1998, 4) AS Wage_growth_rate,
    ROUND(100 * (c17.avg_cpi_2017 - c98.avg_cpi_1998) / c98.avg_cpi_1998, 4) AS Inflation_rate
FROM wage_1998 w98
CROSS JOIN wage_2017 w17
CROSS JOIN cpi_1998 c98
CROSS JOIN cpi_2017 c17;