SELECT o.`title`, o.`artist_display_name`, o.`medium`, i.`original_image_url`
FROM `bigquery-public-data.the_met.objects` AS o
JOIN `bigquery-public-data.the_met.images` AS i
ON o.`object_id` = i.`object_id`
WHERE LOWER(o.`object_name`) LIKE '%photograph%'
  AND o.`department` = 'Photographs'
  AND o.`artist_display_name` != 'Unknown'
  AND o.`object_end_date` <= 1839
  AND o.`title` IS NOT NULL AND o.`title` != ''
  AND o.`artist_display_name` IS NOT NULL AND o.`artist_display_name` != ''
  AND o.`medium` IS NOT NULL AND o.`medium` != ''
  AND i.`original_image_url` IS NOT NULL AND i.`original_image_url` != ''