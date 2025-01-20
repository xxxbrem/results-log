SELECT
    c.county_name,
    ROUND(
        ((e2018.month3_emplvl_23_construction - e2000.month3_emplvl_23_construction) / e2000.month3_emplvl_23_construction) * 100,
        4
    ) AS percentage_increase
FROM
    `bigquery-public-data.geo_us_boundaries.counties` c
JOIN
    `bigquery-public-data.bls_qcew.2000_q1` e2000
    ON e2000.area_fips = c.county_fips_code
JOIN
    `bigquery-public-data.bls_qcew.2018_q1` e2018
    ON e2018.area_fips = c.county_fips_code
WHERE
    c.state_fips_code = '49'
    AND e2000.month3_emplvl_23_construction IS NOT NULL
    AND e2000.month3_emplvl_23_construction > 0
    AND e2018.month3_emplvl_23_construction IS NOT NULL
ORDER BY
    percentage_increase DESC
LIMIT 1;