WITH ways_in_california AS (
  SELECT w."id", w."geometry", w."nodes", w."all_tags"
  FROM "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_OPENSTREETMAP"."PLANET_WAYS" w
  INNER JOIN "GEO_OPENSTREETMAP_BOUNDARIES"."GEO_US_BOUNDARIES"."STATES" s
    ON s."state_name" = 'California'
  WHERE ST_INTERSECTS(
          ST_GEOGFROMWKB(w."geometry"),
          ST_GEOGFROMWKB(s."state_geom")
        )
),
ways_with_tags AS (
  SELECT
    w."id",
    w."geometry",
    w."nodes",
    MAX(CASE WHEN t.value:"key"::STRING = 'highway' THEN t.value:"value"::STRING END) AS "highway_value",
    MAX(CASE WHEN t.value:"key"::STRING = 'bridge' THEN t.value:"value"::STRING END) AS "bridge_value"
  FROM ways_in_california w,
       LATERAL FLATTEN(input => w."all_tags") t
  GROUP BY w."id", w."geometry", w."nodes"
),
filtered_ways AS (
  SELECT w."id", w."geometry", w."nodes"
  FROM ways_with_tags w
  WHERE w."highway_value" IN ('motorway', 'trunk', 'primary', 'secondary', 'residential')
    AND w."bridge_value" IS NULL
),
overlapping_ways AS (
  SELECT w1."id" AS "way_id_1", w2."id" AS "way_id_2"
  FROM filtered_ways w1
  JOIN filtered_ways w2
    ON w1."id" < w2."id"
    AND ST_INTERSECTS(
          ST_GEOGFROMWKB(w1."geometry"),
          ST_GEOGFROMWKB(w2."geometry")
        )
),
way_node_pairs AS (
  SELECT
    w."id" AS "way_id",
    CASE
      WHEN TYPEOF(n.VALUE) = 'NUMBER' THEN n.VALUE::NUMBER
      WHEN TYPEOF(n.VALUE) = 'OBJECT' AND n.VALUE:"id" IS NOT NULL THEN n.VALUE:"id"::NUMBER
      ELSE NULL
    END AS "node_id"
  FROM filtered_ways w,
       LATERAL FLATTEN(input => w."nodes") n
  WHERE n.VALUE IS NOT NULL
),
ways_share_nodes AS (
  SELECT DISTINCT wn1."way_id" AS "way_id_1", wn2."way_id" AS "way_id_2"
  FROM way_node_pairs wn1
  INNER JOIN way_node_pairs wn2
    ON wn1."node_id" = wn2."node_id"
    AND wn1."way_id" < wn2."way_id"
  WHERE wn1."node_id" IS NOT NULL
),
non_overlapping_ways AS (
  SELECT ow."way_id_1", ow."way_id_2"
  FROM overlapping_ways ow
  LEFT JOIN ways_share_nodes ws
    ON ow."way_id_1" = ws."way_id_1" AND ow."way_id_2" = ws."way_id_2"
  WHERE ws."way_id_1" IS NULL
)
SELECT COUNT(*) AS "number_of_road_pairs"
FROM non_overlapping_ways
;