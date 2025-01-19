SELECT
  o.object_id,
  o.title,
  FORMAT_DATE('%Y-%m-%d', DATE(o.metadata_date)) AS formatted_metadata_date
FROM
  `bigquery-public-data.the_met.objects` AS o
JOIN
  `bigquery-public-data.the_met.vision_api_data` AS v
    ON o.object_id = v.object_id,
  UNNEST(v.cropHintsAnnotation.cropHints) AS cropHint
WHERE
  o.department = 'The Libraries'
  AND o.title LIKE '%book%'
  AND cropHint.confidence > 0.5;