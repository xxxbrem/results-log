SELECT
  ROUND(AVG(vdc.`coloc_log2_h4_h3`), 4) AS average_log2h4h3,
  ROUND(VAR_SAMP(vdc.`coloc_log2_h4_h3`), 4) AS variance_log2h4h3,
  ROUND(MAX(vdc.`coloc_log2_h4_h3`) - MIN(vdc.`coloc_log2_h4_h3`), 4) AS max_min_difference_log2h4h3,
  (SELECT vdc2.`right_study`
   FROM `open-targets-genetics.genetics.variant_disease_coloc` AS vdc2
   JOIN `open-targets-genetics.genetics.studies` AS s2
     ON vdc2.`left_study` = s2.`study_id`
   WHERE vdc2.`right_gene_id` = 'ENSG00000169174'
     AND vdc2.`coloc_h4` > 0.8
     AND vdc2.`coloc_h3` < 0.02
     AND LOWER(s2.`trait_reported`) LIKE '%lesterol levels%'
     AND vdc2.`right_bio_feature` = 'IPSC'
     AND vdc2.`left_chrom` = '1'
     AND vdc2.`left_pos` = 55029009
     AND vdc2.`left_ref` = 'C'
     AND vdc2.`left_alt` = 'T'
     AND vdc2.`right_type` IN ('eqtl', 'sqtl')
   ORDER BY vdc2.`coloc_log2_h4_h3` DESC
   LIMIT 1) AS right_study_of_max_log2h4h3
FROM `open-targets-genetics.genetics.variant_disease_coloc` AS vdc
JOIN `open-targets-genetics.genetics.studies` AS s
  ON vdc.`left_study` = s.`study_id`
WHERE
  vdc.`right_gene_id` = 'ENSG00000169174'
  AND vdc.`coloc_h4` > 0.8
  AND vdc.`coloc_h3` < 0.02
  AND LOWER(s.`trait_reported`) LIKE '%lesterol levels%'
  AND vdc.`right_bio_feature` = 'IPSC'
  AND vdc.`left_chrom` = '1'
  AND vdc.`left_pos` = 55029009
  AND vdc.`left_ref` = 'C'
  AND vdc.`left_alt` = 'T'
  AND vdc.`right_type` IN ('eqtl', 'sqtl');