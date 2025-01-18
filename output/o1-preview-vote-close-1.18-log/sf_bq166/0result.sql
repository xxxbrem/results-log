WITH max_copy_numbers AS (
  SELECT
    c."chromosome",
    c."cytoband_name",
    s."case_barcode",
    MAX(s."copy_number") AS "max_copy_number"
  FROM 
    TCGA_MITELMAN.TCGA_VERSIONED."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23" s
  JOIN
    TCGA_MITELMAN.PROD."CYTOBANDS_HG38" c
  ON
    s."chromosome" = c."chromosome" AND
    s."end_pos" >= c."hg38_start" AND
    s."start_pos" <= c."hg38_stop"
  WHERE
    s."project_short_name" = 'TCGA-KIRC'
  GROUP BY
    c."chromosome",
    c."cytoband_name",
    s."case_barcode"
)
SELECT
  "chromosome" AS "Chromosome",
  "cytoband_name" AS "Cytoband",
  CASE
    WHEN "max_copy_number" > 3 THEN 'Amplification'
    WHEN "max_copy_number" = 3 THEN 'Gain'
    WHEN "max_copy_number" = 2 THEN 'Normal Diploid'
    WHEN "max_copy_number" = 1 THEN 'Heterozygous Deletion'
    WHEN "max_copy_number" = 0 THEN 'Homozygous Deletion'
    ELSE 'Other'
  END AS "Type",
  COUNT(DISTINCT "case_barcode") AS "Frequency"
FROM
  max_copy_numbers
GROUP BY
  "chromosome",
  "cytoband_name",
  "Type"
ORDER BY
  "chromosome",
  "cytoband_name",
  "Type";