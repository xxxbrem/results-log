SELECT s."case_barcode"
FROM TCGA_MITELMAN.TCGA_VERSIONED."COPY_NUMBER_SEGMENT_MASKED_HG38_GDC_R14" s
WHERE s."project_short_name" = 'TCGA-LAML'
  AND s."chromosome" = '15'
  AND s."end_pos" > 19000000
  AND s."start_pos" < 25500000
GROUP BY s."case_barcode"
ORDER BY
   ROUND(
       SUM(
           (LEAST(s."end_pos", 25500000) - GREATEST(s."start_pos", 19000000)) * s."segment_mean"
       ) / NULLIF(SUM(
           LEAST(s."end_pos", 25500000) - GREATEST(s."start_pos", 19000000)
       ), 0),
       4
   ) DESC NULLS LAST
LIMIT 1;