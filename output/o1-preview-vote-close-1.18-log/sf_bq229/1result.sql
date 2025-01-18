SELECT
    CASE WHEN l."image_id" IS NULL THEN 'Other' ELSE 'Cat' END AS "Category",
    COUNT(*) AS "Count"
FROM
    OPEN_IMAGES.OPEN_IMAGES.IMAGES i
LEFT JOIN
    (
        SELECT DISTINCT "image_id"
        FROM OPEN_IMAGES.OPEN_IMAGES.LABELS
        WHERE "label_name" = '/m/01yrx' AND "confidence" = 1.0
    ) l
    ON i."image_id" = l."image_id"
GROUP BY
    CASE WHEN l."image_id" IS NULL THEN 'Other' ELSE 'Cat' END;