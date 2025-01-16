WITH expr_data AS (
    SELECT "case_barcode", "normalized_count"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "HGNC_gene_symbol" = 'TP53' AND "normalized_count" > 0
),
mut_data AS (
    SELECT DISTINCT "case_barcode", "Variant_Classification"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "Hugo_Symbol" = 'TP53'
),
expr_mut AS (
    SELECT
        e."case_barcode",
        e."normalized_count",
        COALESCE(m."Variant_Classification", 'No Mutation') AS mutation_type
    FROM expr_data e
    LEFT JOIN mut_data m ON e."case_barcode" = m."case_barcode"
),
expr_mut_grouped AS (
    SELECT
        "case_barcode",
        LOG(10, "normalized_count") AS log_expression,
        mutation_type
    FROM expr_mut
),
grand_mean AS (
    SELECT AVG(log_expression) AS grand_mean
    FROM expr_mut_grouped
),
group_means AS (
    SELECT
        mutation_type,
        AVG(log_expression) AS group_mean,
        COUNT(*) AS n_j
    FROM expr_mut_grouped
    GROUP BY mutation_type
),
SSB_CTE AS (
    SELECT SUM(n_j * POWER(group_mean - gm.grand_mean, 2)) AS SSB
    FROM group_means gm1
    CROSS JOIN grand_mean gm
),
SSW_CTE AS (
    SELECT SUM(POWER(emg.log_expression - gm.group_mean, 2)) AS SSW
    FROM expr_mut_grouped emg
    JOIN group_means gm ON emg.mutation_type = gm.mutation_type
),
counts AS (
    SELECT
        (SELECT COUNT(*) FROM expr_mut_grouped) AS total_samples,
        (SELECT COUNT(*) FROM group_means) AS num_mutation_types
),
degrees_of_freedom AS (
    SELECT
        (num_mutation_types - 1) AS df_between,
        (total_samples - num_mutation_types) AS df_within
    FROM counts
),
mean_squares AS (
    SELECT
        (SELECT SSB FROM SSB_CTE) / df_between AS mean_square_between,
        (SELECT SSW FROM SSW_CTE) / df_within AS mean_square_within
    FROM degrees_of_freedom
),
F_statistic_CTE AS (
    SELECT
        ROUND(mean_square_between, 4) AS mean_square_between,
        ROUND(mean_square_within, 4) AS mean_square_within,
        ROUND(mean_square_between / mean_square_within, 4) AS F_statistic
    FROM mean_squares
),
final_table AS (
    SELECT
        (SELECT total_samples FROM counts) AS total_samples,
        (SELECT num_mutation_types FROM counts) AS num_mutation_types,
        mean_square_between,
        mean_square_within,
        F_statistic
    FROM F_statistic_CTE
)
SELECT
    total_samples,
    num_mutation_types,
    mean_square_between,
    mean_square_within,
    F_statistic
FROM final_table;