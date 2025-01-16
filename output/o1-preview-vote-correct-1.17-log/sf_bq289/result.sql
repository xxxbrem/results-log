WITH philly_geom AS (
    SELECT "place_geom"
    FROM GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_US_CENSUS_PLACES."PLACES_PENNSYLVANIA"
    WHERE "place_name" = 'Philadelphia'
    LIMIT 1
),
amenities_in_philly AS (
    SELECT
        t."osm_id",
        TO_GEOGRAPHY(t."geometry") AS "geometry",
        f.value:"key"::STRING AS "key",
        f.value:"value"::STRING AS "value"
    FROM GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_OPENSTREETMAP."PLANET_FEATURES_POINTS" t,
    LATERAL FLATTEN(input => t."all_tags") f,
    philly_geom
    WHERE f.value:"key"::STRING = 'amenity'
      AND f.value:"value"::STRING IN ('library', 'place_of_worship', 'community_centre')
      AND ST_CONTAINS(
          TO_GEOGRAPHY(philly_geom."place_geom"),
          TO_GEOGRAPHY(t."geometry")
      )
)
SELECT ROUND(
    MIN(
        ST_DISTANCE(a1."geometry", a2."geometry")
    ), 4
) AS shortest_distance_meters
FROM amenities_in_philly a1
JOIN amenities_in_philly a2 ON a1."osm_id" <> a2."osm_id";