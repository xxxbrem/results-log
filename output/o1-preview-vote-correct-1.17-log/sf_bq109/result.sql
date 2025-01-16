SELECT
  ROUND(AVG(VD."coloc_log2_h4_h3"), 4) AS "average_log2_h4_h3",
  ROUND(VAR_SAMP(VD."coloc_log2_h4_h3"), 4) AS "variance_log2_h4_h3",
  ROUND(MAX(VD."coloc_log2_h4_h3") - MIN(VD."coloc_log2_h4_h3"), 4) AS "max_min_difference_log2_h4_h3",
  (
    SELECT VD2."right_study"
    FROM "OPEN_TARGETS_GENETICS_1"."GENETICS"."VARIANT_DISEASE_COLOC" VD2
    JOIN "OPEN_TARGETS_GENETICS_1"."GENETICS"."STUDIES" S2 ON VD2."left_study" = S2."study_id"
    WHERE
      VD2."right_gene_id" = 'ENSG00000169174' AND
      VD2."coloc_h4" > 0.8 AND
      VD2."coloc_h3" < 0.02 AND
      S2."trait_reported" ILIKE '%lesterol levels%' AND
      VD2."right_bio_feature" = 'IPSC' AND
      VD2."left_chrom" = '1' AND
      VD2."left_pos" = 55029009 AND
      VD2."left_ref" = 'C' AND
      VD2."left_alt" = 'T'
    ORDER BY VD2."coloc_log2_h4_h3" DESC NULLS LAST
    LIMIT 1
  ) AS "qtl_source_of_max_log2_h4_h3"
FROM
  "OPEN_TARGETS_GENETICS_1"."GENETICS"."VARIANT_DISEASE_COLOC" VD
JOIN
  "OPEN_TARGETS_GENETICS_1"."GENETICS"."STUDIES" S ON VD."left_study" = S."study_id"
WHERE
  VD."right_gene_id" = 'ENSG00000169174' AND
  VD."coloc_h4" > 0.8 AND
  VD."coloc_h3" < 0.02 AND
  S."trait_reported" ILIKE '%lesterol levels%' AND
  VD."right_bio_feature" = 'IPSC' AND
  VD."left_chrom" = '1' AND
  VD."left_pos" = 55029009 AND
  VD."left_ref" = 'C' AND
  VD."left_alt" = 'T';