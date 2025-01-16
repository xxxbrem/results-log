WITH cytoband AS (
  SELECT 
    MIN("hg38_start") AS "cytoband_start", 
    MAX("hg38_stop") AS "cytoband_end",
    SUBSTRING("chromosome", 4) AS "chromosome_number"
  FROM "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38"
  WHERE "chromosome" = 'chr15' 
    AND "cytoband_name" LIKE '15q11%'
  GROUP BY SUBSTRING("chromosome", 4)
),
overlaps AS (
  SELECT
    s."case_barcode",
    GREATEST(s."start_pos", cytoband."cytoband_start") AS "overlap_start",
    LEAST(s."end_pos", cytoband."cytoband_end") AS "overlap_end",
    s."segment_mean",
    (LEAST(s."end_pos", cytoband."cytoband_end") - GREATEST(s."start_pos", cytoband."cytoband_start") + 1) AS "overlap_length"
  FROM "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_MASKED_HG38_GDC_2017_02" s
  CROSS JOIN cytoband
  WHERE
    s."project_short_name" = 'TCGA-LAML' 
    AND s."chromosome" = cytoband."chromosome_number"
    AND s."start_pos" <= cytoband."cytoband_end" 
    AND s."end_pos" >= cytoband."cytoband_start"
)
SELECT
  o."case_barcode",
  ROUND(SUM(o."segment_mean" * o."overlap_length") / SUM(o."overlap_length"), 4) AS "weighted_average_copy_number"
FROM overlaps o
GROUP BY o."case_barcode"
ORDER BY "weighted_average_copy_number" DESC NULLS LAST
LIMIT 1;