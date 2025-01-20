SELECT
  sample_type,
  ROUND(AVG(correlation), 4) AS average_correlation
FROM (
  SELECT
    r.sample_type_name AS sample_type,
    p.gene_symbol,
    CORR(p.protein_abundance_log2ratio, LOG(r.fpkm_unstranded + 1)) AS correlation
  FROM
    `isb-cgc-bq.CPTAC.quant_proteome_CPTAC_CCRCC_discovery_study_pdc_current` AS p
  INNER JOIN
    `isb-cgc-bq.PDC_metadata.case_metadata_current` AS c
  ON
    p.case_id = c.case_id
  INNER JOIN
    `isb-cgc-bq.CPTAC.RNAseq_hg38_gdc_current` AS r
  ON
    c.case_submitter_id = r.case_barcode
    AND p.gene_symbol = r.gene_name
  WHERE
    p.study_name = 'CPTAC CCRCC Discovery Study - Proteome'
    AND r.primary_site = 'Kidney'
    AND r.sample_type_name IN ('Primary Tumor', 'Solid Tissue Normal')
    AND p.protein_abundance_log2ratio IS NOT NULL
    AND r.fpkm_unstranded IS NOT NULL
  GROUP BY
    sample_type,
    p.gene_symbol
)
WHERE
  ABS(correlation) > 0.5
GROUP BY
  sample_type
ORDER BY
  sample_type;