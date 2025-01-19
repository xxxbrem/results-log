WITH california_geom AS (
  SELECT ST_GEOGFROMWKB(s."state_geom") AS geom
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_US_BOUNDARIES"."STATES" s
  WHERE s."state_name" = 'California'
),
ways_in_california AS (
  SELECT 
    t."id" AS way_id,
    ST_GEOGFROMWKB(t."geometry") AS geom,
    t."nodes",
    t."all_tags"
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_OPENSTREETMAP"."PLANET_WAYS" t,
       california_geom c
  WHERE ST_INTERSECTS(
          ST_GEOGFROMWKB(t."geometry"),
          c.geom
        )
),
tags_extracted AS (
  SELECT
    w.way_id,
    ANY_VALUE(w.geom) AS geom,
    ANY_VALUE(w."nodes") AS nodes,
    MAX(CASE WHEN f.value:"key"::STRING = 'highway' THEN f.value:"value"::STRING END) AS highway_value,
    MAX(CASE WHEN f.value:"key"::STRING = 'bridge' THEN f.value:"value"::STRING END) AS bridge_value
  FROM ways_in_california w,
       LATERAL FLATTEN(input => w."all_tags") f
  GROUP BY w.way_id
),
filtered_ways AS (
  SELECT w.*
  FROM tags_extracted w
  WHERE w.highway_value IN ('motorway', 'trunk', 'primary', 'secondary', 'residential')
    AND w.bridge_value IS NULL
),
ways_with_node_ids AS (
  SELECT 
    w.way_id,
    ANY_VALUE(w.geom) AS geom,
    ARRAY_AGG(n.value:"id"::NUMBER) AS node_ids
  FROM filtered_ways w,
       LATERAL FLATTEN(input => w.nodes) n
  GROUP BY w.way_id
),
road_pairs AS (
  SELECT
    w1.way_id AS way1_id,
    w2.way_id AS way2_id
  FROM ways_with_node_ids w1
  JOIN ways_with_node_ids w2
    ON w1.way_id < w2.way_id
   AND ST_INTERSECTS(w1.geom, w2.geom)
   AND ARRAY_SIZE(ARRAY_INTERSECTION(w1.node_ids, w2.node_ids)) = 0
)
SELECT COUNT(*) AS "Number_of_Pairs"
FROM road_pairs;