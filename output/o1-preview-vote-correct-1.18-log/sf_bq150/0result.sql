WITH expr AS (
    SELECT 
        "sample_barcode",
        "normalized_count",
        LOG("normalized_count", 10) AS log_expression
    FROM 
        "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
    WHERE 
        "project_short_name" = 'TCGA-BRCA' AND
        "HGNC_gene_symbol" = 'TP53' AND
        "normalized_count" > 0
),
mutation AS (
    SELECT DISTINCT 
        "sample_barcode_tumor" AS "sample_barcode",
        "Variant_Classification"
    FROM 
        "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
    WHERE 
        "project_short_name" = 'TCGA-BRCA' AND
        "Hugo_Symbol" = 'TP53'
),
combined_data AS (
    SELECT
        expr."sample_barcode",
        expr.log_expression,
        COALESCE(mutation."Variant_Classification", 'Wildtype') AS "Mutation_Type"
    FROM
        expr
    LEFT JOIN
        mutation
    ON
        expr."sample_barcode" = mutation."sample_barcode"
),
grand_mean_cte AS (
    SELECT AVG(log_expression) AS grand_mean FROM combined_data
),
group_stats AS (
    SELECT
        "Mutation_Type",
        COUNT(*) AS n_j,
        AVG(log_expression) AS group_mean
    FROM
        combined_data
    GROUP BY
        "Mutation_Type"
),
SSB_CTE AS (
    SELECT SUM(n_j * POWER(group_mean - gm.grand_mean, 2)) AS SSB
    FROM
        group_stats gs
    CROSS JOIN
        grand_mean_cte gm
),
sample_devs AS (
    SELECT
        data."sample_barcode",
        data.log_expression,
        data."Mutation_Type",
        stats.group_mean,
        POWER(data.log_expression - stats.group_mean, 2) AS squared_deviation
    FROM
        combined_data data
    JOIN
        group_stats stats
    ON
        data."Mutation_Type" = stats."Mutation_Type"
),
SSW_CTE AS (
    SELECT SUM(squared_deviation) AS SSW
    FROM sample_devs
),
degrees_of_freedom AS (
    SELECT
        (SELECT COUNT(*) FROM group_stats) - 1 AS df_between,
        (SELECT COUNT(*) FROM combined_data) - (SELECT COUNT(*) FROM group_stats) AS df_within
),
mean_squares AS (
    SELECT
        ssb.SSB / df.df_between AS MSB,
        ssw.SSW / df.df_within AS MSW
    FROM
        SSB_CTE ssb,
        SSW_CTE ssw,
        degrees_of_freedom df
),
F_statistic_CTE AS (
    SELECT
        MSB / MSW AS F_statistic
    FROM
        mean_squares
),
final_result AS (
    SELECT
        (SELECT COUNT(*) FROM combined_data) AS Total_Number_of_Samples,
        (SELECT COUNT(*) FROM group_stats) AS Number_of_Mutation_Types,
        mean_squares.MSB,
        mean_squares.MSW,
        F_statistic_CTE.F_statistic
    FROM
        mean_squares
    CROSS JOIN
        F_statistic_CTE
)
SELECT
    Total_Number_of_Samples,
    Number_of_Mutation_Types,
    ROUND(MSB, 4) AS Mean_Square_Between_Groups,
    ROUND(MSW, 4) AS Mean_Square_Within_Groups,
    ROUND(F_statistic, 4) AS F_statistic
FROM
    final_result;