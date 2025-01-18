SELECT
  CASE WHEN L."image_id" IS NULL THEN 'Other' ELSE 'Cat' END AS "Category",
  COUNT(DISTINCT I."image_id") AS "Count"
FROM "OPEN_IMAGES"."OPEN_IMAGES"."IMAGES" AS I
LEFT JOIN (
  SELECT DISTINCT "image_id"
  FROM "OPEN_IMAGES"."OPEN_IMAGES"."LABELS"
  WHERE "label_name" = '/m/01yrx' AND "confidence" = 1.0
) AS L ON I."image_id" = L."image_id"
GROUP BY
  CASE WHEN L."image_id" IS NULL THEN 'Other' ELSE 'Cat' END;