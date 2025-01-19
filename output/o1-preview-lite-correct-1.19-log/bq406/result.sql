WITH data_2014 AS (
  SELECT
    race_asian AS race_asian_2014,
    race_black AS race_black_2014,
    race_hispanic_latinx AS race_hispanic_latinx_2014,
    race_native_american AS race_native_american_2014,
    race_white AS race_white_2014,
    gender_us_women AS gender_us_women_2014,
    gender_us_men AS gender_us_men_2014,
    gender_global_women AS gender_global_women_2014,
    gender_global_men AS gender_global_men_2014
  FROM
    `bigquery-public-data.google_dei.dar_non_intersectional_representation`
  WHERE
    LOWER(TRIM(workforce)) = 'overall' AND report_year = 2014
),
data_2022 AS (
  SELECT
    race_asian AS race_asian_2022,
    race_black AS race_black_2022,
    race_hispanic_latinx AS race_hispanic_latinx_2022,
    race_native_american AS race_native_american_2022,
    race_white AS race_white_2022,
    gender_us_women AS gender_us_women_2022,
    gender_us_men AS gender_us_men_2022,
    gender_global_women AS gender_global_women_2022,
    gender_global_men AS gender_global_men_2022
  FROM
    `bigquery-public-data.google_dei.dar_non_intersectional_representation`
  WHERE
    LOWER(TRIM(workforce)) = 'overall' AND report_year = 2022
)
SELECT 'Asians' AS `Group`,
  ROUND(((data_2022.race_asian_2022 - data_2014.race_asian_2014)/data_2014.race_asian_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'Black people' AS `Group`,
  ROUND(((data_2022.race_black_2022 - data_2014.race_black_2014)/data_2014.race_black_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'Latinx people' AS `Group`,
  ROUND(((data_2022.race_hispanic_latinx_2022 - data_2014.race_hispanic_latinx_2014)/data_2014.race_hispanic_latinx_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'Native Americans' AS `Group`,
  ROUND(((data_2022.race_native_american_2022 - data_2014.race_native_american_2014)/data_2014.race_native_american_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'White people' AS `Group`,
  ROUND(((data_2022.race_white_2022 - data_2014.race_white_2014)/data_2014.race_white_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'US women' AS `Group`,
  ROUND(((data_2022.gender_us_women_2022 - data_2014.gender_us_women_2014)/data_2014.gender_us_women_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'US men' AS `Group`,
  ROUND(((data_2022.gender_us_men_2022 - data_2014.gender_us_men_2014)/data_2014.gender_us_men_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'Global women' AS `Group`,
  ROUND(((data_2022.gender_global_women_2022 - data_2014.gender_global_women_2014)/data_2014.gender_global_women_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022
UNION ALL
SELECT 'Global men' AS `Group`,
  ROUND(((data_2022.gender_global_men_2022 - data_2014.gender_global_men_2014)/data_2014.gender_global_men_2014)*100, 4) AS Growth_Rate
FROM data_2014, data_2022;