WITH amplifications AS (
  SELECT c."cytoband_name"
  FROM "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38" AS c
  JOIN "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23" AS s
    ON c."chromosome" = s."chromosome"
    AND c."hg38_start" <= s."end_pos"
    AND c."hg38_stop" >= s."start_pos"
  WHERE s."project_short_name" = 'TCGA-KIRC'
    AND s."chromosome" = 'chr1'
    AND s."copy_number" > 3  -- Amplifications
  GROUP BY c."cytoband_name"
  ORDER BY COUNT(*) DESC NULLS LAST
  LIMIT 11
),
gains AS (
  SELECT c."cytoband_name"
  FROM "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38" AS c
  JOIN "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23" AS s
    ON c."chromosome" = s."chromosome"
    AND c."hg38_start" <= s."end_pos"
    AND c."hg38_stop" >= s."start_pos"
  WHERE s."project_short_name" = 'TCGA-KIRC'
    AND s."chromosome" = 'chr1'
    AND s."copy_number" = 3  -- Gains
  GROUP BY c."cytoband_name"
  ORDER BY COUNT(*) DESC NULLS LAST
  LIMIT 11
),
heterozygous_deletions AS (
  SELECT c."cytoband_name"
  FROM "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38" AS c
  JOIN "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23" AS s
    ON c."chromosome" = s."chromosome"
    AND c."hg38_start" <= s."end_pos"
    AND c."hg38_stop" >= s."start_pos"
  WHERE s."project_short_name" = 'TCGA-KIRC'
    AND s."chromosome" = 'chr1'
    AND s."copy_number" = 1  -- Heterozygous deletions
  GROUP BY c."cytoband_name"
  ORDER BY COUNT(*) DESC NULLS LAST
  LIMIT 11
)
SELECT a."cytoband_name"
FROM amplifications a
JOIN gains g ON a."cytoband_name" = g."cytoband_name"
JOIN heterozygous_deletions h ON a."cytoband_name" = h."cytoband_name";