SELECT
    ROUND(AVG(vdc."coloc_log2_h4_h3"), 4) AS average_log2_h4_h3,
    ROUND(VAR_SAMP(vdc."coloc_log2_h4_h3"), 4) AS variance_log2_h4_h3,
    ROUND(MAX(vdc."coloc_log2_h4_h3") - MIN(vdc."coloc_log2_h4_h3"), 4) AS max_min_difference,
    (SELECT vdc_max."right_study"
     FROM OPEN_TARGETS_GENETICS_1.GENETICS.VARIANT_DISEASE_COLOC vdc_max
     JOIN OPEN_TARGETS_GENETICS_1.GENETICS.STUDIES s_max ON vdc_max."left_study" = s_max."study_id"
     WHERE
         vdc_max."right_gene_id" = 'ENSG00000169174'
         AND vdc_max."coloc_h4" > 0.8
         AND vdc_max."coloc_h3" < 0.02
         AND vdc_max."right_bio_feature" = 'IPSC'
         AND vdc_max."left_chrom" = '1'
         AND vdc_max."left_pos" = 55029009
         AND vdc_max."left_ref" = 'C'
         AND vdc_max."left_alt" = 'T'
         AND s_max."trait_reported" ILIKE '%lesterol levels%'
     ORDER BY vdc_max."coloc_log2_h4_h3" DESC NULLS LAST
     LIMIT 1
    ) AS right_study_with_max_log2_h4_h3
FROM OPEN_TARGETS_GENETICS_1.GENETICS.VARIANT_DISEASE_COLOC vdc
JOIN OPEN_TARGETS_GENETICS_1.GENETICS.STUDIES s ON vdc."left_study" = s."study_id"
WHERE
    vdc."right_gene_id" = 'ENSG00000169174'
    AND vdc."coloc_h4" > 0.8
    AND vdc."coloc_h3" < 0.02
    AND vdc."right_bio_feature" = 'IPSC'
    AND vdc."left_chrom" = '1'
    AND vdc."left_pos" = 55029009
    AND vdc."left_ref" = 'C'
    AND vdc."left_alt" = 'T'
    AND s."trait_reported" ILIKE '%lesterol levels%';