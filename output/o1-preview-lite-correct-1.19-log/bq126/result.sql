SELECT o.title, o.artist_display_name AS artist_name, o.medium, i.original_image_url
FROM `bigquery-public-data.the_met.objects` AS o
JOIN `bigquery-public-data.the_met.images` AS i
ON o.object_id = i.object_id
WHERE LOWER(o.object_name) LIKE '%photograph%'
  AND o.department = 'Photographs'
  AND o.artist_display_name != 'Unknown' AND o.artist_display_name IS NOT NULL
  AND o.object_end_date <= 1839;