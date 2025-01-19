SELECT
  ROUND(AVG(c.coloc_log2_h4_h3), 4) AS Average,
  ROUND(VAR_SAMP(c.coloc_log2_h4_h3), 4) AS Variance,
  ROUND(MAX(c.coloc_log2_h4_h3) - MIN(c.coloc_log2_h4_h3), 4) AS MaxMinusMin,
  ARRAY_AGG(c.right_study ORDER BY c.coloc_log2_h4_h3 DESC LIMIT 1)[SAFE_OFFSET(0)] AS QTL_source_of_Max_log2_h4_h3
FROM
  `open-targets-genetics.genetics.variant_disease_coloc` AS c
JOIN
  `open-targets-genetics.genetics.studies` AS s
ON
  c.left_study = s.study_id
WHERE
  c.right_gene_id = 'ENSG00000169174'
  AND c.coloc_h4 > 0.8
  AND c.coloc_h3 < 0.02
  AND LOWER(s.trait_reported) LIKE '%cholesterol levels%'
  AND c.right_bio_feature = 'IPSC'
  AND c.left_chrom = '1'
  AND c.left_pos = 55029009
  AND c.left_ref = 'C'
  AND c.left_alt = 'T'
  AND c.coloc_log2_h4_h3 IS NOT NULL
  AND c.right_study IS NOT NULL;