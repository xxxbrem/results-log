WITH
segments AS (
  SELECT
    s."case_barcode",
    s."chromosome",
    s."start_pos",
    s."end_pos",
    CASE
      WHEN s."copy_number" > 3 THEN 'Amplification'
      WHEN s."copy_number" = 3 THEN 'Gain'
      WHEN s."copy_number" = 1 THEN 'Heterozygous Deletion'
      ELSE NULL
    END AS "alteration_type"
  FROM
    "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23" s
  WHERE
    s."project_short_name" = 'TCGA-KIRC'
    AND s."chromosome" = 'chr1'
    AND s."copy_number" IS NOT NULL
),
filtered_segments AS (
  SELECT *
  FROM segments
  WHERE "alteration_type" IS NOT NULL
),
cytobands AS (
  SELECT
    c."chromosome",
    c."cytoband_name",
    c."hg38_start",
    c."hg38_stop"
  FROM
    "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38" c
  WHERE
    c."chromosome" = 'chr1'
),
segment_cytoband_overlap AS (
  SELECT
    f."case_barcode",
    f."alteration_type",
    cb."cytoband_name"
  FROM
    filtered_segments f
    JOIN cytobands cb
      ON f."chromosome" = cb."chromosome"
      AND f."start_pos" <= cb."hg38_stop"
      AND f."end_pos" >= cb."hg38_start"
),
cytoband_alteration_counts AS (
  SELECT
    sc."cytoband_name",
    sc."alteration_type",
    COUNT(DISTINCT sc."case_barcode") AS "case_count"
  FROM
    segment_cytoband_overlap sc
  GROUP BY
    sc."cytoband_name",
    sc."alteration_type"
),
total_cases AS (
  SELECT COUNT(DISTINCT "case_barcode") AS "total_cases"
  FROM
    "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23"
  WHERE
    "project_short_name" = 'TCGA-KIRC'
),
cytoband_alteration_freq AS (
  SELECT
    cac."cytoband_name",
    cac."alteration_type",
    cac."case_count",
    ROUND(cac."case_count" * 100.0 / tc."total_cases", 4) AS "frequency"
  FROM
    cytoband_alteration_counts cac
    CROSS JOIN total_cases tc
),
cytoband_ranking AS (
  SELECT
    caf."cytoband_name",
    caf."alteration_type",
    caf."frequency",
    RANK() OVER (
      PARTITION BY caf."alteration_type" 
      ORDER BY caf."frequency" DESC NULLS LAST
    ) AS "rank"
  FROM
    cytoband_alteration_freq caf
)
SELECT
  cr."cytoband_name"
FROM
  cytoband_ranking cr
WHERE
  cr."rank" <= 11
GROUP BY
  cr."cytoband_name"
HAVING
  COUNT(DISTINCT cr."alteration_type") = 3
ORDER BY
  cr."cytoband_name" ASC;