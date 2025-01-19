WITH
california_geom AS (
  SELECT ST_GEOMFROMWKB("state_geom") AS "state_geom"
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_US_BOUNDARIES"."STATES"
  WHERE "state_name" = 'California'
),
tags_flattened AS (
  SELECT
    t."id",
    f.value:"key"::STRING AS "key",
    f.value:"value"::STRING AS "value"
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_OPENSTREETMAP"."PLANET_WAYS" t,
    TABLE(FLATTEN(input => t."all_tags", outer => TRUE)) f
),
ways_with_tags AS (
  SELECT
    "id",
    MAX(CASE WHEN "key" = 'highway' THEN "value" END) AS "highway_value",
    MAX(CASE WHEN "key" = 'bridge' THEN "value" END) AS "bridge_value"
  FROM tags_flattened
  GROUP BY "id"
),
nodes_flattened AS (
  SELECT
    t."id",
    n.value:"id"::NUMBER AS "node_id"
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_OPENSTREETMAP"."PLANET_WAYS" t,
       TABLE(FLATTEN(input => t."nodes", outer => TRUE)) n
),
ways_with_nodes AS (
  SELECT
    "id",
    ARRAY_AGG(DISTINCT "node_id") AS "node_ids"
  FROM nodes_flattened
  GROUP BY "id"
),
ways_tags AS (
  SELECT
    w."id",
    w."highway_value",
    w."bridge_value",
    COALESCE(n."node_ids", ARRAY_CONSTRUCT()) AS "node_ids"
  FROM ways_with_tags w
  LEFT JOIN ways_with_nodes n ON w."id" = n."id"
),
ways_with_geometry AS (
  SELECT
    t."id",
    ST_GEOMFROMWKB(t."geometry") AS "geometry"
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_OPENSTREETMAP"."PLANET_WAYS" t
),
roads_in_california AS (
  SELECT DISTINCT w."id", g."geometry", w."node_ids"
  FROM ways_tags w
  JOIN ways_with_geometry g ON w."id" = g."id"
  CROSS JOIN california_geom c
  WHERE w."highway_value" IN ('motorway', 'trunk', 'primary', 'secondary', 'residential')
    AND w."bridge_value" IS NULL
    AND ST_INTERSECTS(g."geometry", c."state_geom")
)
SELECT COUNT(*) AS "Number_of_overlapping_road_pairs"
FROM roads_in_california r1
JOIN roads_in_california r2
  ON r1."id" < r2."id"
  AND ST_INTERSECTS(r1."geometry", r2."geometry")
  AND ARRAY_SIZE(ARRAY_INTERSECTION(r1."node_ids", r2."node_ids")) = 0;