WITH data AS (
  SELECT
    r."sample_type_name",
    p."gene_symbol",
    p."protein_abundance_log2ratio",
    LN(r."fpkm_unstranded" + 1) AS log_fpkm
  FROM
    "CPTAC_PDC"."CPTAC"."QUANT_PROTEOME_CPTAC_CCRCC_DISCOVERY_STUDY_PDC_CURRENT" p
  JOIN "CPTAC_PDC"."PDC_METADATA"."ALIQUOT_TO_CASE_MAPPING_CURRENT" m
    ON p."sample_id" = m."sample_id"
  JOIN "CPTAC_PDC"."CPTAC"."RNASEQ_HG38_GDC_CURRENT" r
    ON m."sample_submitter_id" = r."sample_barcode"
    AND p."gene_symbol" = r."gene_name"
  WHERE r."primary_site" = 'Kidney'
    AND r."sample_type_name" IN ('Primary Tumor', 'Solid Tissue Normal')
),
correlations AS (
  SELECT
    "sample_type_name",
    "gene_symbol",
    CORR("protein_abundance_log2ratio", log_fpkm) AS corr
  FROM data
  GROUP BY "sample_type_name", "gene_symbol"
),
filtered_correlations AS (
  SELECT
    "sample_type_name",
    "gene_symbol",
    corr
  FROM correlations
  WHERE ABS(corr) <= 0.5
)
SELECT
  "sample_type_name" AS "Sample_Type",
  ROUND(AVG(corr), 4) AS "Average_Correlation"
FROM filtered_correlations
GROUP BY "sample_type_name"
ORDER BY "sample_type_name";