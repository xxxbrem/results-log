WITH home_depot_stores AS (
  SELECT i."POI_ID" AS "home_depot_poi_id",
         TO_GEOGRAPHY(ST_POINT(TRY_TO_DOUBLE(a."LONGITUDE"), TRY_TO_DOUBLE(a."LATITUDE"))) AS "home_depot_geog"
  FROM "US_REAL_ESTATE"."CYBERSYN"."POINT_OF_INTEREST_INDEX" i
  JOIN "US_REAL_ESTATE"."CYBERSYN"."POINT_OF_INTEREST_ADDRESSES_RELATIONSHIPS" r
    ON i."POI_ID" = r."POI_ID"
  JOIN "US_REAL_ESTATE"."CYBERSYN"."US_ADDRESSES" a
    ON r."ADDRESS_ID" = a."ADDRESS_ID"
  WHERE i."POI_NAME" = 'The Home Depot'
    AND TRY_TO_DOUBLE(a."LATITUDE") IS NOT NULL
    AND TRY_TO_DOUBLE(a."LONGITUDE") IS NOT NULL
    AND TRY_TO_DOUBLE(a."LATITUDE") BETWEEN -90 AND 90
    AND TRY_TO_DOUBLE(a."LONGITUDE") BETWEEN -180 AND 180
),
lowes_stores AS (
  SELECT i."POI_ID" AS "lowes_poi_id",
         TO_GEOGRAPHY(ST_POINT(TRY_TO_DOUBLE(a."LONGITUDE"), TRY_TO_DOUBLE(a."LATITUDE"))) AS "lowes_geog"
  FROM "US_REAL_ESTATE"."CYBERSYN"."POINT_OF_INTEREST_INDEX" i
  JOIN "US_REAL_ESTATE"."CYBERSYN"."POINT_OF_INTEREST_ADDRESSES_RELATIONSHIPS" r
    ON i."POI_ID" = r."POI_ID"
  JOIN "US_REAL_ESTATE"."CYBERSYN"."US_ADDRESSES" a
    ON r."ADDRESS_ID" = a."ADDRESS_ID"
  WHERE i."POI_NAME" = 'Lowe''s Home Improvement'
    AND TRY_TO_DOUBLE(a."LATITUDE") IS NOT NULL
    AND TRY_TO_DOUBLE(a."LONGITUDE") IS NOT NULL
    AND TRY_TO_DOUBLE(a."LATITUDE") BETWEEN -90 AND 90
    AND TRY_TO_DOUBLE(a."LONGITUDE") BETWEEN -180 AND 180
)
SELECT hds."home_depot_poi_id",
       ROUND(MIN(ST_DISTANCE(hds."home_depot_geog", ls."lowes_geog")) * 0.000621371, 4) AS "distance_miles"
FROM home_depot_stores hds
CROSS JOIN lowes_stores ls
GROUP BY hds."home_depot_poi_id"
ORDER BY hds."home_depot_poi_id";