WITH expr_data AS (
    SELECT "case_barcode", LOG(10, "normalized_count") AS "log_expression"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "HGNC_gene_symbol" = 'TP53' AND "normalized_count" > 0
),
mut_type_per_sample AS (
    SELECT "case_barcode", MIN("Variant_Classification") AS "Variant_Classification"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_DCC"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "Hugo_Symbol" = 'TP53'
    GROUP BY "case_barcode"
),
data AS (
    SELECT expr."case_barcode", expr."log_expression", COALESCE(mut."Variant_Classification", 'Wild_Type') AS "Variant_Classification"
    FROM expr_data expr
    LEFT JOIN mut_type_per_sample mut
    ON expr."case_barcode" = mut."case_barcode"
),
grand_mean AS (
    SELECT AVG("log_expression") AS "grand_mean" FROM data
),
group_stats AS (
    SELECT "Variant_Classification", AVG("log_expression") AS "group_mean", COUNT(*) AS "n_j"
    FROM data
    GROUP BY "Variant_Classification"
),
ssb AS (
    SELECT SUM(gs."n_j" * POWER(gs."group_mean" - gm."grand_mean", 2)) AS "ssb_value"
    FROM group_stats gs CROSS JOIN grand_mean gm
),
data_with_group_means AS (
    SELECT d.*, gs."group_mean"
    FROM data d
    JOIN group_stats gs ON d."Variant_Classification" = gs."Variant_Classification"
),
ssw AS (
    SELECT SUM(POWER(d."log_expression" - d."group_mean", 2)) AS "ssw_value"
    FROM data_with_group_means d
),
final_stats AS (
    SELECT
        (SELECT COUNT(*) FROM data) AS "Total_samples",
        (SELECT COUNT(*) FROM group_stats) AS "Number_of_mutation_types",
        ROUND((SELECT "ssb_value" FROM ssb) / ((SELECT COUNT(*) FROM group_stats) - 1), 4) AS "Mean_square_between_groups",
        ROUND((SELECT "ssw_value" FROM ssw) / ((SELECT COUNT(*) FROM data) - (SELECT COUNT(*) FROM group_stats)), 4) AS "Mean_square_within_groups",
        ROUND(
            (
                ((SELECT "ssb_value" FROM ssb) / ((SELECT COUNT(*) FROM group_stats) - 1))
                /
                ((SELECT "ssw_value" FROM ssw) / ((SELECT COUNT(*) FROM data) - (SELECT COUNT(*) FROM group_stats)))
            ),
            4
        ) AS "F_statistic"
)
SELECT * FROM final_stats;