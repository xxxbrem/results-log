WITH cytoband AS (
  SELECT "chromosome", "hg38_start", "hg38_stop"
  FROM TCGA_MITELMAN.PROD.CYTOBANDS_HG38
  WHERE "chromosome" = 'chr15' AND "cytoband_name" = '15q11'
),
overlaps AS (
  SELECT t."case_barcode",
    GREATEST(t."start_pos", c."hg38_start") AS overlap_start,
    LEAST(t."end_pos", c."hg38_stop") AS overlap_end,
    LEAST(t."end_pos", c."hg38_stop") - GREATEST(t."start_pos", c."hg38_start") + 1 AS overlap_length,
    t."segment_mean"
  FROM TCGA_MITELMAN.TCGA_VERSIONED.COPY_NUMBER_SEGMENT_MASKED_HG38_GDC_2017_02 t
  JOIN cytoband c ON t."chromosome" = SUBSTR(c."chromosome", 4)
  WHERE t."project_short_name" = 'TCGA-LAML'
    AND t."chromosome" = '15'
    AND t."end_pos" >= c."hg38_start"
    AND t."start_pos" <= c."hg38_stop"
)
SELECT "case_barcode",
  ROUND(SUM(overlap_length * "segment_mean") / SUM(overlap_length), 4) AS weighted_average_copy_number
FROM overlaps
GROUP BY "case_barcode"
ORDER BY weighted_average_copy_number DESC NULLS LAST
LIMIT 1;