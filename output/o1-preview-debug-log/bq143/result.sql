SELECT
  sample_type_name AS Sample_Type,
  ROUND(AVG(correlation), 4) AS Average_Correlation
FROM (
  SELECT
    r.sample_type_name,
    p.gene_symbol,
    CORR(p.protein_abundance_log2ratio, LOG(r.fpkm_unstranded + 1)) AS correlation
  FROM
    `isb-cgc-bq.CPTAC.quant_proteome_CPTAC_CCRCC_discovery_study_pdc_current` p
  JOIN
    `isb-cgc-bq.PDC_metadata.case_metadata_current` c
  ON
    p.case_id = c.case_id
  JOIN
    `isb-cgc-bq.CPTAC.RNAseq_hg38_gdc_current` r
  ON
    c.case_submitter_id = r.case_barcode
    AND p.gene_symbol = r.gene_name
  WHERE
    r.primary_site = 'Kidney'
    AND r.sample_type_name IN ('Primary Tumor', 'Solid Tissue Normal')
  GROUP BY
    r.sample_type_name,
    p.gene_symbol
  HAVING
    COUNT(*) >= 2
    AND ABS(correlation) > 0.5
)
GROUP BY
  sample_type_name
ORDER BY
  sample_type_name;