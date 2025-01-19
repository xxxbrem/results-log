SELECT
    mp."country_name",
    SUM(mpa."population") AS total_population_under_20,
    mp."midyear_population" AS total_midyear_population,
    ROUND((SUM(mpa."population") / mp."midyear_population") * 100, 4) AS percentage_under_20
FROM
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION_AGESPECIFIC" mpa
JOIN
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION" mp
    ON mpa."country_code" = mp."country_code" AND mpa."year" = mp."year"
WHERE
    mpa."year" = 2020
    AND mpa."age" < 20
GROUP BY
    mp."country_name", mp."midyear_population"
ORDER BY
    percentage_under_20 DESC NULLS LAST
LIMIT 10;