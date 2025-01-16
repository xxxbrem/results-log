WITH bank_locations AS (
  SELECT "zip_code", COUNT(*) AS bank_location_count
  FROM "FDA"."FDIC_BANKS"."LOCATIONS"
  WHERE "state" = 'CO'
  GROUP BY "zip_code"
),
zip_codes AS (
  SELECT "zip_code", "zip_code_geom"
  FROM "FDA"."GEO_US_BOUNDARIES"."ZIP_CODES"
  WHERE "state_code" = 'CO'
),
block_groups AS (
  SELECT "geo_id" AS blockgroup_id, "blockgroup_geom", "area_land_meters"
  FROM "FDA"."GEO_CENSUS_BLOCKGROUPS"."US_BLOCKGROUPS_NATIONAL"
  WHERE "state_fips_code" = '08'
),
overlaps AS (
  SELECT
    z."zip_code",
    bg.blockgroup_id,
    bg."area_land_meters",
    ST_AREA(
      ST_INTERSECTION(
        ST_GEOGFROMWKB(z."zip_code_geom"),
        ST_GEOGFROMWKB(bg."blockgroup_geom")
      )
    ) AS overlap_area_meters
  FROM
    zip_codes z
  JOIN
    block_groups bg
  ON
    ST_INTERSECTS(
      ST_GEOGFROMWKB(z."zip_code_geom"),
      ST_GEOGFROMWKB(bg."blockgroup_geom")
    )
),
overlaps_with_ratios AS (
  SELECT
    o."zip_code",
    o.blockgroup_id,
    o.overlap_area_meters,
    o."area_land_meters",
    o.overlap_area_meters / o."area_land_meters" AS overlap_ratio
  FROM overlaps o
  WHERE o.overlap_area_meters > 0
),
bank_locations_with_overlap AS (
  SELECT
    o."zip_code",
    o.blockgroup_id,
    o.overlap_ratio,
    bl.bank_location_count,
    bl.bank_location_count * o.overlap_ratio AS adjusted_bank_locations
  FROM overlaps_with_ratios o
  JOIN bank_locations bl
  ON o."zip_code" = bl."zip_code"
),
zip_code_concentration AS (
  SELECT
    "zip_code",
    SUM(adjusted_bank_locations) AS total_adjusted_bank_locations,
    COUNT(DISTINCT blockgroup_id) AS overlapping_blockgroups_count
  FROM bank_locations_with_overlap
  GROUP BY "zip_code"
),
zip_code_concentration_final AS (
  SELECT
    "zip_code",
    ROUND(total_adjusted_bank_locations / overlapping_blockgroups_count, 4) AS bank_locations_per_block_group
  FROM zip_code_concentration
)
SELECT "zip_code", bank_locations_per_block_group
FROM zip_code_concentration_final
ORDER BY bank_locations_per_block_group DESC NULLS LAST
LIMIT 1;