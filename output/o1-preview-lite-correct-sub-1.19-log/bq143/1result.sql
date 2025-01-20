WITH proteomics AS (
  SELECT
    p.sample_id,
    m.sample_submitter_id,
    m.sample_type,
    p.gene_symbol,
    p.protein_abundance_log2ratio
  FROM
    `isb-cgc-bq.CPTAC.quant_proteome_CPTAC_CCRCC_discovery_study_pdc_current` p
  JOIN
    `isb-cgc-bq.PDC_metadata.aliquot_to_case_mapping_current` m
  ON
    p.sample_id = m.sample_id
  WHERE
    m.sample_type IN ('Primary Tumor', 'Solid Tissue Normal')
),
rna_seq AS (
  SELECT
    r.sample_barcode,
    r.sample_type_name,
    r.gene_name,
    LOG(r.fpkm_unstranded + 1) / LOG(2) AS log_fpkm
  FROM
    `isb-cgc-bq.CPTAC.RNAseq_hg38_gdc_current` r
  WHERE
    r.sample_type_name IN ('Primary Tumor', 'Solid Tissue Normal')
    AND r.primary_site = 'Kidney'
    AND r.project_short_name = 'CPTAC-3'
    AND r.fpkm_unstranded IS NOT NULL
    AND r.fpkm_unstranded > 0
),
joined_data AS (
  SELECT
    p.sample_type,
    p.gene_symbol,
    p.protein_abundance_log2ratio,
    r.log_fpkm
  FROM
    proteomics p
  JOIN
    rna_seq r
  ON
    LOWER(p.sample_submitter_id) = LOWER(r.sample_barcode)
    AND p.gene_symbol = r.gene_name
)
SELECT
  sample_type,
  ROUND(AVG(correlation), 4) AS average_correlation
FROM (
  SELECT
    sample_type,
    gene_symbol,
    CORR(protein_abundance_log2ratio, log_fpkm) AS correlation
  FROM
    joined_data
  GROUP BY
    sample_type,
    gene_symbol
  HAVING
    ABS(CORR(protein_abundance_log2ratio, log_fpkm)) > 0.5
)
GROUP BY
  sample_type;