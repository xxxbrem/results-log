SELECT sub."title", sub."artist_display_name", sub."medium", sub."original_image_url"
FROM (
    SELECT o."object_id", o."title", o."artist_display_name", o."medium", i."original_image_url",
           ROW_NUMBER() OVER (PARTITION BY o."object_id" ORDER BY i."original_image_url") AS rn
    FROM THE_MET.THE_MET.OBJECTS o
    JOIN THE_MET.THE_MET.IMAGES i ON o."object_id" = i."object_id"
    WHERE o."object_name" ILIKE '%Photograph%'
      AND o."department" = 'Photographs'
      AND o."artist_display_name" != 'Unknown'
      AND o."object_end_date" <= 1839
) sub
WHERE sub.rn = 1;