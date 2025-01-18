WITH pop_increase AS (
    SELECT
        t1."geo_id",
        (t2."total_pop" - t1."total_pop") AS "pop_increase"
    FROM
        CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS.CENSUSTRACT_2011_5YR t1
    JOIN
        CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS.CENSUSTRACT_2018_5YR t2
    ON
        t1."geo_id" = t2."geo_id"
    WHERE
        t1."geo_id" LIKE '36047%' AND
        t1."total_pop" > 1000 AND
        t2."total_pop" > 1000
),
pop_top20 AS (
    SELECT
        p."geo_id",
        p."pop_increase",
        ROW_NUMBER() OVER (ORDER BY p."pop_increase" DESC NULLS LAST) AS "pop_rank"
    FROM pop_increase p
),
pop_top20_filtered AS (
    SELECT
        p."geo_id"
    FROM
        pop_top20 p
    WHERE
        "pop_rank" <= 20
),
income_increase AS (
    SELECT
        t1."geo_id",
        (t2."median_income" - t1."median_income") AS "income_increase"
    FROM
        CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS.CENSUSTRACT_2011_5YR t1
    JOIN
        CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS.CENSUSTRACT_2018_5YR t2
    ON
        t1."geo_id" = t2."geo_id"
    WHERE
        t1."geo_id" LIKE '36047%' AND
        t1."total_pop" > 1000 AND
        t2."total_pop" > 1000
),
income_top20 AS (
    SELECT
        i."geo_id",
        i."income_increase",
        ROW_NUMBER() OVER (ORDER BY i."income_increase" DESC NULLS LAST) AS "income_rank"
    FROM income_increase i
),
income_top20_filtered AS (
    SELECT
        i."geo_id"
    FROM
        income_top20 i
    WHERE
        "income_rank" <= 20
),
both_top20 AS (
    SELECT
        p."geo_id"
    FROM
        pop_top20_filtered p
    JOIN
        income_top20_filtered i
    ON
        p."geo_id" = i."geo_id"
)
SELECT
    b."geo_id",
    ct."tract_ce"
FROM
    both_top20 b
JOIN
    CENSUS_BUREAU_ACS_1.GEO_CENSUS_TRACTS.CENSUS_TRACTS_NEW_YORK ct
ON
    b."geo_id" = ct."geo_id"
ORDER BY
    b."geo_id";