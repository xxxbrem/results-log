WITH data AS (
  SELECT
    '2016' AS year,
    bwp.county_fips,
    bwp.pct_no_morbidity,
    pd.poverty_rate
  FROM
    (
      SELECT
        bd.county_fips,
        bd.total_births,
        nmd.births_no_morbidity,
        (nmd.births_no_morbidity / bd.total_births) * 100 AS pct_no_morbidity
      FROM
        (
          SELECT
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0') AS county_fips,
            SUM("Births") AS total_births
          FROM
            SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
          WHERE
            "Year" = '2016-01-01'
          GROUP BY
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0')
        ) bd
        JOIN (
          SELECT
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0') AS county_fips,
            SUM("Births") AS births_no_morbidity
          FROM
            SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
          WHERE
            "Year" = '2016-01-01' AND "Maternal_Morbidity_YN" = 0
          GROUP BY
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0')
        ) nmd ON bd.county_fips = nmd.county_fips
    ) bwp
    JOIN (
      SELECT
        LPAD(CAST("geo_id" AS VARCHAR),5,'0') AS county_fips,
        ("poverty" / NULLIF("total_pop",0)) * 100 AS poverty_rate
      FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR
      WHERE
        "total_pop" > 0
    ) pd ON bwp.county_fips = pd.county_fips
  WHERE
    bwp.total_births > 0
  UNION ALL
  SELECT
    '2017' AS year,
    bwp.county_fips,
    bwp.pct_no_morbidity,
    pd.poverty_rate
  FROM
    (
      SELECT
        bd.county_fips,
        bd.total_births,
        nmd.births_no_morbidity,
        (nmd.births_no_morbidity / bd.total_births) * 100 AS pct_no_morbidity
      FROM
        (
          SELECT
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0') AS county_fips,
            SUM("Births") AS total_births
          FROM
            SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
          WHERE
            "Year" = '2017-01-01'
          GROUP BY
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0')
        ) bd
        JOIN (
          SELECT
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0') AS county_fips,
            SUM("Births") AS births_no_morbidity
          FROM
            SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
          WHERE
            "Year" = '2017-01-01' AND "Maternal_Morbidity_YN" = 0
          GROUP BY
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0')
        ) nmd ON bd.county_fips = nmd.county_fips
    ) bwp
    JOIN (
      SELECT
        LPAD(CAST("geo_id" AS VARCHAR),5,'0') AS county_fips,
        ("poverty" / NULLIF("total_pop",0)) * 100 AS poverty_rate
      FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR
      WHERE
        "total_pop" > 0
    ) pd ON bwp.county_fips = pd.county_fips
  WHERE
    bwp.total_births > 0
  UNION ALL
  SELECT
    '2018' AS year,
    bwp.county_fips,
    bwp.pct_no_morbidity,
    pd.poverty_rate
  FROM
    (
      SELECT
        bd.county_fips,
        bd.total_births,
        nmd.births_no_morbidity,
        (nmd.births_no_morbidity / bd.total_births) * 100 AS pct_no_morbidity
      FROM
        (
          SELECT
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0') AS county_fips,
            SUM("Births") AS total_births
          FROM
            SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
          WHERE
            "Year" = '2018-01-01'
          GROUP BY
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0')
        ) bd
        JOIN (
          SELECT
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0') AS county_fips,
            SUM("Births") AS births_no_morbidity
          FROM
            SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
          WHERE
            "Year" = '2018-01-01' AND "Maternal_Morbidity_YN" = 0
          GROUP BY
            LPAD(TRIM("County_of_Residence_FIPS"),5,'0')
        ) nmd ON bd.county_fips = nmd.county_fips
    ) bwp
    JOIN (
      SELECT
        LPAD(CAST("geo_id" AS VARCHAR),5,'0') AS county_fips,
        ("poverty" / NULLIF("total_pop",0)) * 100 AS poverty_rate
      FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR
      WHERE
        "total_pop" > 0
    ) pd ON bwp.county_fips = pd.county_fips
  WHERE
    bwp.total_births > 0
)

SELECT
  year,
  ROUND(CORR(poverty_rate, pct_no_morbidity), 4) AS correlation_coefficient
FROM
  data
GROUP BY
  year
ORDER BY
  year;