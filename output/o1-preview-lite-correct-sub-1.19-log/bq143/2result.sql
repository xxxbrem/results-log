WITH RNAseq_data AS (
  SELECT
    r.case_barcode,
    r.gene_name,
    LOG(r.fpkm_unstranded + 1) AS expr_log,
    r.sample_type_name AS sample_type
  FROM
    `isb-cgc-bq.CPTAC.RNAseq_hg38_gdc_current` r
  WHERE
    r.sample_type_name IN ('Primary Tumor', 'Solid Tissue Normal')
    AND r.case_barcode IS NOT NULL
    AND r.gene_name IS NOT NULL
    AND r.fpkm_unstranded IS NOT NULL
    AND r.fpkm_unstranded >= 0
),
Proteomics_data AS (
  SELECT
    sm.case_submitter_id AS case_barcode,
    p.gene_symbol AS gene_name,
    p.protein_abundance_log2ratio,
    sm.sample_type
  FROM
    `isb-cgc-bq.CPTAC.quant_proteome_CPTAC_CCRCC_discovery_study_pdc_current` p
  JOIN
    `isb-cgc-bq.PDC_metadata.aliquot_to_case_mapping_current` sm
    ON p.aliquot_submitter_id = sm.aliquot_submitter_id
  WHERE
    p.gene_symbol IS NOT NULL
    AND p.protein_abundance_log2ratio IS NOT NULL
    AND sm.case_submitter_id IS NOT NULL
    AND sm.sample_type IN ('Primary Tumor', 'Solid Tissue Normal')
),
Combined_data AS (
  SELECT
    r.case_barcode,
    r.gene_name,
    r.expr_log,
    r.sample_type,
    p.protein_abundance_log2ratio
  FROM
    RNAseq_data r
  JOIN
    Proteomics_data p
  ON
    r.case_barcode = p.case_barcode
    AND r.gene_name = p.gene_name
    AND r.sample_type = p.sample_type
),
Correlation_per_gene_sample_type AS (
  SELECT
    gene_name,
    sample_type,
    CORR(expr_log, protein_abundance_log2ratio) AS correlation
  FROM
    Combined_data
  GROUP BY
    gene_name,
    sample_type
),
Filtered_correlations AS (
  SELECT
    *
  FROM
    Correlation_per_gene_sample_type
  WHERE
    ABS(correlation) > 0.5
),
Average_correlation_per_sample_type AS (
  SELECT
    sample_type,
    AVG(correlation) AS average_correlation
  FROM
    Filtered_correlations
  GROUP BY
    sample_type
)
SELECT
  sample_type,
  ROUND(average_correlation, 4) AS average_correlation
FROM
  Average_correlation_per_sample_type