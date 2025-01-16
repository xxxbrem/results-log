WITH bank_locations_per_zip AS (
    SELECT "zip_code", COUNT(*) AS "num_bank_locations"
    FROM FDA.FDIC_BANKS.LOCATIONS
    WHERE "state" = 'CO'
    GROUP BY "zip_code"
),
zip_codes_co AS (
    SELECT "zip_code", "zip_code_geom"
    FROM FDA.GEO_US_BOUNDARIES.ZIP_CODES
    WHERE "state_code" = 'CO' AND "zip_code_geom" IS NOT NULL
),
block_groups_co AS (
    SELECT "geo_id", "blockgroup_geom"
    FROM FDA.GEO_CENSUS_BLOCKGROUPS.US_BLOCKGROUPS_NATIONAL
    WHERE "state_fips_code" = '08' AND "blockgroup_geom" IS NOT NULL
),
overlap_areas AS (
    SELECT
        z."zip_code",
        b."geo_id",
        ST_AREA(ST_INTERSECTION(ST_GEOGFROMWKB(z."zip_code_geom"), ST_GEOGFROMWKB(b."blockgroup_geom"))) AS "overlap_area",
        ST_AREA(ST_GEOGFROMWKB(b."blockgroup_geom")) AS "blockgroup_area"
    FROM
        zip_codes_co z
    JOIN
        block_groups_co b ON ST_INTERSECTS(ST_GEOGFROMWKB(z."zip_code_geom"), ST_GEOGFROMWKB(b."blockgroup_geom"))
),
overlap_ratios AS (
    SELECT
        "zip_code",
        "geo_id",
        "overlap_area" / NULLIF("blockgroup_area", 0) AS "overlap_ratio"
    FROM
        overlap_areas
    WHERE "overlap_area" > 0
),
adjusted_bank_locations AS (
    SELECT
        o."zip_code",
        o."geo_id",
        o."overlap_ratio",
        COALESCE(b."num_bank_locations", 0) AS "num_bank_locations",
        o."overlap_ratio" * COALESCE(b."num_bank_locations", 0) AS "adjusted_bank_locations"
    FROM
        overlap_ratios o
    LEFT JOIN
        bank_locations_per_zip b ON o."zip_code" = b."zip_code"
),
zip_code_concentrations AS (
    SELECT
        "zip_code",
        SUM("adjusted_bank_locations") AS "total_adjusted_bank_locations",
        COUNT(DISTINCT "geo_id") AS "num_block_groups"
    FROM
        adjusted_bank_locations
    GROUP BY "zip_code"
),
zip_code_concentration_rates AS (
    SELECT
        "zip_code",
        "total_adjusted_bank_locations",
        "num_block_groups",
        "total_adjusted_bank_locations" / NULLIF("num_block_groups", 0) AS "bank_locations_per_block_group"
    FROM
        zip_code_concentrations
)
SELECT
    "zip_code",
    ROUND("bank_locations_per_block_group", 4) AS "bank_locations_per_block_group"
FROM
    zip_code_concentration_rates
ORDER BY
    "bank_locations_per_block_group" DESC NULLS LAST
LIMIT 1;