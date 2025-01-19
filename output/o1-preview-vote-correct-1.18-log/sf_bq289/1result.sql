WITH filtered_amenities AS (
  SELECT
    t."osm_id",
    TO_GEOGRAPHY(t."geometry") AS geom
  FROM
    GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_OPENSTREETMAP.PLANET_FEATURES_POINTS t
    INNER JOIN GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_US_CENSUS_PLACES.PLACES_PENNSYLVANIA p
      ON p."place_name" = 'Philadelphia',
    LATERAL FLATTEN(input => t."all_tags") f
  WHERE
    t."geometry" IS NOT NULL
    AND ST_CONTAINS(
      TO_GEOGRAPHY(p."place_geom"),
      TO_GEOGRAPHY(t."geometry")
    )
    AND f.value:"key"::STRING = 'amenity'
    AND f.value:"value"::STRING IN ('library', 'place_of_worship', 'community_centre')
)
SELECT
  ROUND(MIN(ST_DISTANCE(a1.geom, a2.geom)), 4) AS "Shortest_distance_meters"
FROM
  filtered_amenities a1
  JOIN filtered_amenities a2 ON a1."osm_id" < a2."osm_id";