WITH philly_geom AS (
    SELECT
        ST_GEOGFROMWKB("place_geom") AS "geom"
    FROM
        "GEO_OPENSTREETMAP_CENSUS_PLACES"."GEO_US_CENSUS_PLACES"."PLACES_PENNSYLVANIA"
    WHERE
        "place_name" = 'Philadelphia'
),
amenities AS (
    SELECT
        t."osm_id",
        ST_GEOGFROMWKB(t."geometry") AS "geom",
        f.value:"value"::STRING AS "amenity"
    FROM
        "GEO_OPENSTREETMAP_CENSUS_PLACES"."GEO_OPENSTREETMAP"."PLANET_FEATURES_POINTS" t,
        LATERAL FLATTEN(input => t."all_tags") f
    WHERE
        f.value:"key"::STRING = 'amenity'
        AND f.value:"value"::STRING IN ('library', 'place_of_worship', 'community_centre', 'community_center')
),
philly_amenities AS (
    SELECT
        a.*
    FROM
        amenities a,
        philly_geom p
    WHERE
        ST_CONTAINS(p."geom", a."geom")
)
SELECT
    ROUND(MIN(ST_DISTANCE(a1."geom", a2."geom")), 4) AS "distance_in_meters"
FROM
    philly_amenities a1
    JOIN philly_amenities a2 ON a1."osm_id" < a2."osm_id";