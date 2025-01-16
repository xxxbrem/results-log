WITH bank_locations AS (
    SELECT "zip_code", COUNT(*) AS bank_location_count
    FROM FDA.FDIC_BANKS.LOCATIONS
    WHERE "state" = 'CO'
    GROUP BY "zip_code"
),
zip_codes AS (
    SELECT "zip_code", ST_GEOGFROMWKB("zip_code_geom") AS zip_code_geom
    FROM FDA.GEO_US_BOUNDARIES.ZIP_CODES
    WHERE "state_code" = 'CO'
),
block_groups AS (
    SELECT "blockgroup_ce", ST_GEOGFROMWKB("blockgroup_geom") AS blockgroup_geom, "area_land_meters"
    FROM FDA.GEO_CENSUS_BLOCKGROUPS.BLOCKGROUPS_08
),
overlaps AS (
    SELECT 
        z."zip_code",
        bg."blockgroup_ce",
        bg."area_land_meters",
        ST_AREA(ST_INTERSECTION(z.zip_code_geom, bg.blockgroup_geom)) AS overlap_area
    FROM zip_codes z
    JOIN block_groups bg
    ON ST_INTERSECTS(z.zip_code_geom, bg.blockgroup_geom)
),
overlaps_with_ratio AS (
    SELECT 
        "zip_code", "blockgroup_ce", overlap_area, "area_land_meters",
        overlap_area / "area_land_meters" AS overlap_ratio
    FROM overlaps
    WHERE overlap_area IS NOT NULL AND "area_land_meters" > 0
),
zip_code_total_overlap_ratio AS (
    SELECT
        "zip_code",
        SUM(overlap_ratio) AS total_overlap_ratio
    FROM overlaps_with_ratio
    GROUP BY "zip_code"
),
zip_code_concentration AS (
    SELECT
        bl."zip_code",
        bl.bank_location_count,
        ztotr.total_overlap_ratio,
        bl.bank_location_count / NULLIF(ztotr.total_overlap_ratio, 0) AS concentration
    FROM bank_locations bl
    JOIN zip_code_total_overlap_ratio ztotr
    ON bl."zip_code" = ztotr."zip_code"
)
SELECT
    "zip_code",
    ROUND(concentration, 4) AS bank_locations_per_block_group
FROM zip_code_concentration
ORDER BY bank_locations_per_block_group DESC NULLS LAST
LIMIT 1;