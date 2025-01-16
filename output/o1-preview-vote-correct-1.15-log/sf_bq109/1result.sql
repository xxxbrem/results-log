WITH filtered_data AS (
  SELECT
    vc."coloc_log2_h4_h3",
    vc."right_study"
  FROM "OPEN_TARGETS_GENETICS_1"."GENETICS"."VARIANT_DISEASE_COLOC" vc
  JOIN "OPEN_TARGETS_GENETICS_1"."GENETICS"."STUDIES" s
    ON vc."left_study" = s."study_id"
  WHERE
    vc."right_gene_id" = 'ENSG00000169174'
    AND vc."coloc_h4" > 0.8
    AND vc."coloc_h3" < 0.02
    AND s."trait_reported" ILIKE '%cholesterol levels%'
    AND vc."right_bio_feature" = 'IPSC'
    AND vc."left_chrom" = '1'
    AND vc."left_pos" = 55029009
    AND vc."left_ref" = 'C'
    AND vc."left_alt" = 'T'
)
SELECT
  ROUND(AVG("coloc_log2_h4_h3"), 4) AS "average_log2_h4_h3",
  ROUND(VAR_SAMP("coloc_log2_h4_h3"), 4) AS "variance_log2_h4_h3",
  ROUND(MAX("coloc_log2_h4_h3") - MIN("coloc_log2_h4_h3"), 4) AS "max_min_difference_log2_h4_h3",
  (SELECT "right_study" FROM filtered_data ORDER BY "coloc_log2_h4_h3" DESC NULLS LAST LIMIT 1) AS "qtl_source_of_max_log2_h4_h3"
FROM filtered_data;