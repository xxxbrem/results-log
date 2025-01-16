WITH philadelphia AS (
    SELECT ST_GEOGFROMWKB("place_geom") AS geom
    FROM GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_US_CENSUS_PLACES.PLACES_PENNSYLVANIA
    WHERE "place_name" = 'Philadelphia'
),
amenities AS (
    SELECT
        a."osm_id",
        ST_GEOGFROMWKB(a."geometry") AS geom,
        MAX(CASE WHEN tag.value:"key"::STRING = 'amenity' THEN tag.value:"value"::STRING END) AS amenity_type,
        MAX(CASE WHEN tag.value:"key"::STRING = 'name' THEN tag.value:"value"::STRING END) AS name
    FROM
        GEO_OPENSTREETMAP_CENSUS_PLACES.GEO_OPENSTREETMAP.PLANET_FEATURES_POINTS a,
        LATERAL FLATTEN(input => a."all_tags") AS tag
    WHERE
        a."geometry" IS NOT NULL
    GROUP BY
        a."osm_id",
        a."geometry"
),
amenities_filtered AS (
    SELECT *
    FROM amenities
    WHERE amenity_type IN ('library', 'place_of_worship', 'community_centre')
),
amenities_in_philadelphia AS (
    SELECT a.*
    FROM amenities_filtered a, philadelphia p
    WHERE ST_CONTAINS(p.geom, a.geom)
)
SELECT
    a1.name AS Amenity1,
    a2.name AS Amenity2,
    ROUND(ST_DISTANCE(a1.geom, a2.geom), 4) AS "Shortest_Distance (meters)"
FROM
    amenities_in_philadelphia a1
JOIN
    amenities_in_philadelphia a2
    ON a1."osm_id" < a2."osm_id"
ORDER BY
    "Shortest_Distance (meters)" ASC
LIMIT 1;