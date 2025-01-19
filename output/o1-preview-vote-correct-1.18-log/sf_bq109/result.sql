WITH filtered_data AS (
    SELECT
        vdc."coloc_log2_h4_h3",
        vdc."right_study"
    FROM
        "OPEN_TARGETS_GENETICS_1"."GENETICS"."VARIANT_DISEASE_COLOC" vdc
    JOIN
        "OPEN_TARGETS_GENETICS_1"."GENETICS"."STUDIES" s
        ON vdc."left_study" = s."study_id"
    WHERE
        vdc."right_gene_id" = 'ENSG00000169174' AND
        vdc."coloc_h4" > 0.8 AND
        vdc."coloc_h3" < 0.02 AND
        s."trait_reported" ILIKE '%lesterol levels%' AND
        vdc."right_bio_feature" = 'IPSC' AND
        vdc."left_chrom" = '1' AND
        vdc."left_pos" = 55029009 AND
        vdc."left_ref" = 'C' AND
        vdc."left_alt" = 'T'
)
SELECT
    ROUND(AVG("coloc_log2_h4_h3"), 4) AS "Average_log2_h4_h3",
    ROUND(VAR_SAMP("coloc_log2_h4_h3"), 4) AS "Variance_log2_h4_h3",
    ROUND(MAX("coloc_log2_h4_h3") - MIN("coloc_log2_h4_h3"), 4) AS "MaxMinDifference_log2_h4_h3",
    (SELECT "right_study" FROM filtered_data ORDER BY "coloc_log2_h4_h3" DESC NULLS LAST LIMIT 1) AS "QTL_source_of_max_log2_h4_h3"
FROM
    filtered_data;