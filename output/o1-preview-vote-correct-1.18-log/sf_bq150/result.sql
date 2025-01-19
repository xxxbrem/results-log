WITH expression_data AS (
    SELECT
        "sample_barcode",
        "case_barcode",
        LOG(10, "normalized_count") AS log_expression
    FROM
        "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
    WHERE
        "HGNC_gene_symbol" = 'TP53' AND
        "project_short_name" = 'TCGA-BRCA' AND
        "normalized_count" > 0
),
mutation_data AS (
    SELECT
        DISTINCT
        "sample_barcode_tumor",
        "case_barcode",
        "Variant_Classification"
    FROM
        "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
    WHERE
        "Hugo_Symbol" = 'TP53' AND
        "project_short_name" = 'TCGA-BRCA'
),
merged_data AS (
    SELECT
        ed."sample_barcode",
        ed."case_barcode",
        ed.log_expression,
        COALESCE(md."Variant_Classification", 'No Mutation') AS mutation_type
    FROM
        expression_data ed
        LEFT JOIN
            mutation_data md
        ON
            ed."sample_barcode" = md."sample_barcode_tumor"
),
group_stats AS (
    SELECT
        mutation_type,
        AVG(log_expression) AS group_mean,
        COUNT(*) AS n_j
    FROM
        merged_data
    GROUP BY
        mutation_type
),
grand_stats AS (
    SELECT
        AVG(log_expression) AS grand_mean,
        COUNT(*) AS total_samples,
        COUNT(DISTINCT mutation_type) AS num_mutation_types
    FROM
        merged_data
),
SSB AS (
    SELECT
        SUM(gs.n_j * POWER(gs.group_mean - gs2.grand_mean, 2)) AS ssb
    FROM
        group_stats gs
        CROSS JOIN grand_stats gs2
),
SSW AS (
    SELECT
        SUM(POWER(md.log_expression - gs.group_mean, 2)) AS ssw
    FROM
        merged_data md
        INNER JOIN group_stats gs ON md.mutation_type = gs.mutation_type
),
degrees_of_freedom AS (
    SELECT
        (gs2.num_mutation_types - 1) AS df_between,
        (gs2.total_samples - gs2.num_mutation_types) AS df_within
    FROM
        grand_stats gs2
),
mean_squares AS (
    SELECT
        ssb.ssb / dof.df_between AS ms_between,
        ssw.ssw / dof.df_within AS ms_within
    FROM
        SSB ssb, SSW ssw, degrees_of_freedom dof
)
SELECT
    gs.total_samples::int AS "Total Samples",
    gs.num_mutation_types::int AS "Number of Mutation Types",
    ROUND(ms.ms_between, 4) AS "Mean Square Between Groups",
    ROUND(ms.ms_within, 4) AS "Mean Square Within Groups",
    ROUND(ms.ms_between / ms.ms_within, 4) AS "F-statistic"
FROM
    grand_stats gs,
    mean_squares ms;