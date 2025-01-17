SELECT o."object_id", o."title", TO_VARCHAR(TO_TIMESTAMP_NTZ(o."metadata_date" / 1000000), 'YYYY-MM-DD') AS "metadata_date"
FROM THE_MET.THE_MET.OBJECTS o
JOIN (
  SELECT DISTINCT t."object_id"
  FROM THE_MET.THE_MET.VISION_API_DATA t,
       LATERAL FLATTEN(INPUT => t."cropHintsAnnotation":cropHints) f
  WHERE f.value:"confidence"::FLOAT > 0.5
) v ON o."object_id" = v."object_id"
WHERE o."department" = 'The Libraries' AND o."title" LIKE '%book%';