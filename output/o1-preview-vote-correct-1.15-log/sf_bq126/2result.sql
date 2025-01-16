SELECT O."title", O."artist_display_name" AS "artist_name", O."medium", I."original_image_url"
FROM "THE_MET"."THE_MET"."OBJECTS" AS O
JOIN "THE_MET"."THE_MET"."IMAGES" AS I ON O."object_id" = I."object_id"
WHERE O."object_name" = 'Photograph'
  AND O."department" = 'Photographs'
  AND O."artist_display_name" != 'Unknown'
  AND O."object_end_date" >= 0
  AND O."object_end_date" <= 1839;