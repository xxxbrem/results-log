WITH filtered_data AS (
    SELECT vd.*, s."trait_reported"
    FROM OPEN_TARGETS_GENETICS_1.GENETICS.VARIANT_DISEASE_COLOC vd
    JOIN OPEN_TARGETS_GENETICS_1.GENETICS.STUDIES s
        ON vd."left_study" = s."study_id"
    WHERE vd."right_gene_id" = 'ENSG00000169174'
      AND vd."coloc_h4" > 0.8
      AND vd."coloc_h3" < 0.02
      AND vd."left_chrom" = '1'
      AND vd."left_pos" = 55029009
      AND vd."left_ref" = 'C'
      AND vd."left_alt" = 'T'
      AND vd."right_bio_feature" = 'IPSC'
      AND s."trait_reported" ILIKE '%lesterol levels%'
)
SELECT
    ROUND(AVG("coloc_log2_h4_h3"), 4) AS "Average",
    ROUND(VAR_SAMP("coloc_log2_h4_h3"), 4) AS "Variance",
    ROUND(MAX("coloc_log2_h4_h3") - MIN("coloc_log2_h4_h3"), 4) AS "Max_Min_Difference",
    (SELECT "right_study" FROM filtered_data ORDER BY "coloc_log2_h4_h3" DESC NULLS LAST LIMIT 1) AS "QTL_Source"
FROM filtered_data;