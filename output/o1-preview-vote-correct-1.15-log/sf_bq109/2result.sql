SELECT
  ROUND(AVG(VDC."coloc_log2_h4_h3"), 4) AS average_log2_h4_h3,
  ROUND(VAR_SAMP(VDC."coloc_log2_h4_h3"), 4) AS variance_log2_h4_h3,
  ROUND(MAX(VDC."coloc_log2_h4_h3") - MIN(VDC."coloc_log2_h4_h3"), 4) AS max_min_diff_log2_h4_h3,
  MAX_BY(VDC."right_study", VDC."coloc_log2_h4_h3") AS right_study_of_max_log2_h4_h3
FROM OPEN_TARGETS_GENETICS_1.GENETICS.VARIANT_DISEASE_COLOC AS VDC
JOIN OPEN_TARGETS_GENETICS_1.GENETICS.STUDIES AS ST
  ON VDC."left_study" = ST."study_id"
WHERE
  VDC."right_gene_id" = 'ENSG00000169174'
  AND VDC."coloc_h4" > 0.8
  AND VDC."coloc_h3" < 0.02
  AND VDC."right_bio_feature" = 'IPSC'
  AND VDC."left_chrom" = '1'
  AND VDC."left_pos" = 55029009
  AND VDC."left_ref" = 'C'
  AND VDC."left_alt" = 'T'
  AND ST."trait_reported" LIKE '%lesterol levels%';