SELECT 'Cat' AS "Category", COUNT(DISTINCT "L1"."image_id") AS "Count"
FROM OPEN_IMAGES.OPEN_IMAGES.LABELS AS "L1"
WHERE "L1"."label_name" = '/m/01yrx' AND "L1"."confidence" = 1.0

UNION ALL

SELECT 'Other' AS "Category", COUNT(DISTINCT "I"."image_id") AS "Count"
FROM OPEN_IMAGES.OPEN_IMAGES.IMAGES AS "I"
WHERE "I"."image_id" NOT IN (
    SELECT DISTINCT "L2"."image_id"
    FROM OPEN_IMAGES.OPEN_IMAGES.LABELS AS "L2"
    WHERE "L2"."label_name" = '/m/01yrx'
)
;