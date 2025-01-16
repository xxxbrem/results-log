WITH expression_data AS (
    SELECT e."case_barcode", e."normalized_count",
           LOG(e."normalized_count", 10) AS "log_expression"
    FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0.RNASEQ_GENE_EXPRESSION_UNC_RSEM e
    WHERE e."project_short_name" = 'TCGA-BRCA'
      AND e."HGNC_gene_symbol" = 'TP53'
      AND e."normalized_count" > 0
),
mutation_data AS (
    SELECT m."case_barcode", m."Variant_Classification"
    FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0.SOMATIC_MUTATION_MC3 m
    WHERE m."project_short_name" = 'TCGA-BRCA'
      AND m."Hugo_Symbol" = 'TP53'
),
sample_mutation AS (
    SELECT
        md."case_barcode",
        md."Variant_Classification"
    FROM mutation_data md
    QUALIFY ROW_NUMBER() OVER (PARTITION BY md."case_barcode" ORDER BY md."Variant_Classification") = 1
),
combined_data AS (
    SELECT
        ed."case_barcode",
        ed."normalized_count",
        ed."log_expression",
        COALESCE(sm."Variant_Classification", 'No_Mutation') AS "Variant_Classification"
    FROM expression_data ed
    LEFT JOIN sample_mutation sm
        ON ed."case_barcode" = sm."case_barcode"
),
stats AS (
    SELECT
        COUNT(*) AS total_samples,
        COUNT(DISTINCT "Variant_Classification") AS num_mutation_types,
        AVG("log_expression") AS grand_mean
    FROM combined_data
),
group_stats AS (
    SELECT
        "Variant_Classification",
        COUNT(*) AS n_j,
        AVG("log_expression") AS mean_j
    FROM combined_data
    GROUP BY "Variant_Classification"
),
ssb AS (
    SELECT
        SUM(gs.n_j * POWER(gs.mean_j - s.grand_mean, 2)) AS ss_between
    FROM group_stats gs, stats s
),
ssw AS (
    SELECT
        SUM(POWER(cd."log_expression" - gs.mean_j, 2)) AS ss_within
    FROM combined_data cd
    JOIN group_stats gs
        ON cd."Variant_Classification" = gs."Variant_Classification"
),
degrees AS (
    SELECT
        (s.num_mutation_types - 1) AS df_between,
        (s.total_samples - s.num_mutation_types) AS df_within
    FROM stats s
),
ms AS (
    SELECT
        (b.ss_between / d.df_between) AS ms_between,
        (w.ss_within / d.df_within) AS ms_within
    FROM ssb b, ssw w, degrees d
),
f_statistic AS (
    SELECT
        (m.ms_between / m.ms_within) AS F_statistic
    FROM ms m
)
SELECT
    s.total_samples,
    s.num_mutation_types,
    ROUND(m.ms_between, 7) AS mean_square_between_groups,
    ROUND(m.ms_within, 7) AS mean_square_within_groups,
    ROUND(f.F_statistic, 7) AS F_statistic
FROM stats s
CROSS JOIN ms m
CROSS JOIN f_statistic f;