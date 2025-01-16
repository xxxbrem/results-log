WITH SELECTED_DATA AS (
  SELECT 
    VDCOLOC."coloc_log2_h4_h3", 
    VDCOLOC."right_study"
  FROM OPEN_TARGETS_GENETICS_1.GENETICS.VARIANT_DISEASE_COLOC VDCOLOC
  JOIN OPEN_TARGETS_GENETICS_1.GENETICS.STUDIES STUDIES
    ON VDCOLOC."left_study" = STUDIES."study_id"
  WHERE 
    VDCOLOC."right_gene_id" = 'ENSG00000169174'
    AND VDCOLOC."coloc_h4" > 0.8
    AND VDCOLOC."coloc_h3" < 0.02
    AND VDCOLOC."right_bio_feature" = 'IPSC'
    AND VDCOLOC."left_chrom" = '1'
    AND VDCOLOC."left_pos" = 55029009
    AND VDCOLOC."left_ref" = 'C'
    AND VDCOLOC."left_alt" = 'T'
    AND STUDIES."trait_reported" LIKE '%lesterol levels'
)
SELECT
  ROUND(AVG("coloc_log2_h4_h3"), 4) AS average_log2_h4_h3,
  ROUND(VAR_SAMP("coloc_log2_h4_h3"), 4) AS variance_log2_h4_h3,
  ROUND(MAX("coloc_log2_h4_h3") - MIN("coloc_log2_h4_h3"), 4) AS max_min_difference_log2_h4_h3,
  (SELECT "right_study"
   FROM SELECTED_DATA
   ORDER BY "coloc_log2_h4_h3" DESC NULLS LAST
   LIMIT 1) AS qtl_source_of_max_log2_h4_h3
FROM SELECTED_DATA;