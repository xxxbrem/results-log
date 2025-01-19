WITH philly AS (
  SELECT ST_GEOMFROMWKB("place_geom") AS "geom"
  FROM GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_US_CENSUS_PLACES.PLACES_PENNSYLVANIA
  WHERE "place_name" = 'Philadelphia'
),
amenities AS (
  SELECT t."osm_id", ST_GEOMFROMWKB(t."geometry") AS "geom"
  FROM GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_OPENSTREETMAP.PLANET_FEATURES_POINTS t,
       LATERAL FLATTEN(input => t."all_tags") AS x
  WHERE x.value:"key"::STRING = 'amenity'
    AND x.value:"value"::STRING IN ('library', 'place_of_worship', 'community_center')
),
amenities_in_philly AS (
  SELECT a."osm_id", a."geom"
  FROM amenities a, philly p
  WHERE ST_CONTAINS(p."geom", a."geom")
)
SELECT ROUND(MIN(ST_DISTANCE(a1."geom", a2."geom")), 4) AS "value"
FROM amenities_in_philly a1
JOIN amenities_in_philly a2
  ON a1."osm_id" < a2."osm_id";