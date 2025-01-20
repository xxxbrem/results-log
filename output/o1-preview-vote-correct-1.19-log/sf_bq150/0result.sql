WITH expression_data AS (
    SELECT e."sample_barcode", e."normalized_count"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM" e
    WHERE e."project_short_name" = 'TCGA-BRCA' AND e."HGNC_gene_symbol" = 'TP53' AND e."normalized_count" IS NOT NULL AND e."normalized_count" > 0
),
mutation_data AS (
    SELECT m."sample_barcode_tumor", m."Variant_Classification"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3" m
    WHERE m."project_short_name" = 'TCGA-BRCA' AND m."Hugo_Symbol" = 'TP53'
),
mutation_per_sample AS (
    SELECT "sample_barcode_tumor", "Variant_Classification",
           ROW_NUMBER() OVER (PARTITION BY "sample_barcode_tumor" ORDER BY "Variant_Classification") as rn
    FROM mutation_data
),
sample_mutation AS (
    SELECT "sample_barcode_tumor", "Variant_Classification"
    FROM mutation_per_sample
    WHERE rn = 1
),
combined_data AS (
    SELECT e."sample_barcode", e."normalized_count", sm."Variant_Classification"
    FROM expression_data e
    JOIN sample_mutation sm
    ON e."sample_barcode" = sm."sample_barcode_tumor"
),
log_expression_data AS (
    SELECT
        "Variant_Classification",
        "sample_barcode",
        LN("normalized_count") / LN(10) as log_expression
    FROM combined_data
),
grand_mean AS (
    SELECT AVG(log_expression) as grand_mean, COUNT(*) as N
    FROM log_expression_data
),
group_stats AS (
    SELECT "Variant_Classification", AVG(log_expression) as group_mean, COUNT(*) as n_j
    FROM log_expression_data
    GROUP BY "Variant_Classification"
),
ssb AS (
    SELECT SUM(gs.n_j * POWER(gs.group_mean - gm.grand_mean, 2)) as ssb
    FROM group_stats gs
    CROSS JOIN grand_mean gm
),
ssw AS (
    SELECT SUM(POWER(le.log_expression - gs.group_mean, 2)) as ssw
    FROM log_expression_data le
    JOIN group_stats gs ON le."Variant_Classification" = gs."Variant_Classification"
),
df AS (
    SELECT
        (SELECT COUNT(*) FROM group_stats) - 1 as df_between,
        (SELECT N FROM grand_mean) - (SELECT COUNT(*) FROM group_stats) as df_within
),
ms AS (
    SELECT
        (SELECT ssb FROM ssb) / df_between as msb,
        (SELECT ssw FROM ssw) / df_within as msw
    FROM df
)
SELECT
    (SELECT N FROM grand_mean) as total_samples,
    (SELECT COUNT(*) FROM group_stats) as number_of_mutation_types,
    ROUND(ms.msB, 4) as mean_square_between_groups,
    ROUND(ms.msw, 4) as mean_square_within_groups,
    ROUND(ms.msB / ms.msw, 4) as F_statistic
FROM ms
;