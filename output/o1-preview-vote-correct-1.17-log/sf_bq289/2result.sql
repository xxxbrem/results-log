WITH phila_geom AS (
   SELECT ST_SETSRID(TO_GEOMETRY("place_geom"), 4326) AS phila_geom
   FROM "GEO_OPENSTREETMAP_CENSUS_PLACES"."GEO_US_CENSUS_PLACES"."PLACES_PENNSYLVANIA"
   WHERE "place_name" = 'Philadelphia'
   LIMIT 1
),
points_in_phila AS (
   SELECT
       t."osm_id",
       t."geometry",
       t."all_tags"
   FROM "GEO_OPENSTREETMAP_CENSUS_PLACES"."GEO_OPENSTREETMAP"."PLANET_FEATURES_POINTS" t,
        phila_geom
   WHERE t."geometry" IS NOT NULL
     AND ST_CONTAINS(
          phila_geom.phila_geom,
          ST_SETSRID(TO_GEOMETRY(t."geometry"), 4326)
      )
),
amenities AS (
   SELECT
       p."osm_id",
       MAX(CASE WHEN f.value:"key"::STRING = 'amenity' THEN f.value:"value"::STRING END) AS amenity_type,
       MAX(CASE WHEN f.value:"key"::STRING = 'name' THEN f.value:"value"::STRING END) AS amenity_name
   FROM points_in_phila p,
        LATERAL FLATTEN(input => p."all_tags") f
   GROUP BY p."osm_id"
   HAVING MAX(CASE WHEN f.value:"key"::STRING = 'amenity' AND f.value:"value"::STRING IN ('library', 'place_of_worship', 'community_centre') THEN 1 ELSE 0 END) = 1
),
amenities_with_geom AS (
   SELECT
       a."osm_id",
       a.amenity_type,
       a.amenity_name,
       ST_SETSRID(TO_GEOMETRY(p."geometry"), 4326) AS geom
   FROM amenities a
   JOIN points_in_phila p ON a."osm_id" = p."osm_id"
)
SELECT
   a1."osm_id" AS "amenity1_id",
   a1.amenity_type AS "amenity1_type",
   a1.amenity_name AS "amenity1_name",
   a2."osm_id" AS "amenity2_id",
   a2.amenity_type AS "amenity2_type",
   a2.amenity_name AS "amenity2_name",
   ROUND(ST_DISTANCE(a1.geom, a2.geom), 4) AS "shortest_distance_meters"
FROM amenities_with_geom a1
JOIN amenities_with_geom a2 ON a1."osm_id" < a2."osm_id"
ORDER BY "shortest_distance_meters"
LIMIT 1;