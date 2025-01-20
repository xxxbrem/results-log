WITH severity_rank_table AS (
    SELECT 'Nonsense_Mutation' AS "Variant_Classification", 1 AS severity_rank UNION ALL
    SELECT 'Frame_Shift_Del', 2 UNION ALL
    SELECT 'Frame_Shift_Ins', 3 UNION ALL
    SELECT 'Splice_Site', 4 UNION ALL
    SELECT 'In_Frame_Del', 5 UNION ALL
    SELECT 'In_Frame_Ins', 6 UNION ALL
    SELECT 'Missense_Mutation', 7 UNION ALL
    SELECT 'Nonstop_Mutation', 8 UNION ALL
    SELECT 'Translation_Start_Site', 9 UNION ALL
    SELECT 'Silent', 10 UNION ALL
    SELECT 'Intron', 11 UNION ALL
    SELECT '3''UTR', 12 UNION ALL
    SELECT '5''UTR', 13 UNION ALL
    SELECT '3''Flank', 14 UNION ALL
    SELECT '5''Flank',15 UNION ALL
    SELECT 'RNA', 16
),
sample_mutation AS (
    SELECT m."sample_barcode_tumor" AS "sample_barcode",
           srt."Variant_Classification",
           srt.severity_rank
    FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."SOMATIC_MUTATION_MC3" m
    JOIN severity_rank_table srt
       ON m."Variant_Classification" = srt."Variant_Classification"
    WHERE m."project_short_name" = 'TCGA-BRCA' AND m."Hugo_Symbol" = 'TP53'
),
sample_worst_mutation AS (
    SELECT "sample_barcode",
           MIN(severity_rank) AS min_severity_rank
    FROM sample_mutation
    GROUP BY "sample_barcode"
),
sample_variant AS (
    SELECT swm."sample_barcode",
           srt."Variant_Classification"
    FROM sample_worst_mutation swm
    JOIN severity_rank_table srt
       ON swm.min_severity_rank = srt.severity_rank
),
expression_data AS (
    SELECT "sample_barcode",
           "normalized_count"
    FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "HGNC_gene_symbol" = 'TP53'
),
full_data AS (
    SELECT e."sample_barcode",
           e."normalized_count",
           sv."Variant_Classification"
    FROM expression_data e
    LEFT JOIN sample_variant sv
       ON e."sample_barcode" = sv."sample_barcode"
),
full_data_with_type AS (
    SELECT "sample_barcode",
           "normalized_count",
           COALESCE("Variant_Classification", 'Wild_Type') AS "Variant_Classification"
    FROM full_data
),
expression_log AS (
    SELECT "sample_barcode",
           LOG(10, "normalized_count") AS "log_expression",
           "Variant_Classification"
    FROM full_data_with_type
    WHERE "normalized_count" > 0
),
grand_mean_cte AS (
    SELECT AVG("log_expression") AS grand_mean,
           COUNT(*) AS total_samples
    FROM expression_log
),
group_stats AS (
    SELECT "Variant_Classification",
           COUNT(*) AS n_j,
           AVG("log_expression") AS mean_j
    FROM expression_log
    GROUP BY "Variant_Classification"
),
ssw AS (
    SELECT el."Variant_Classification",
           SUM( POWER(el."log_expression" - gs.mean_j, 2) ) AS SSW_j
    FROM expression_log el
    JOIN group_stats gs
       ON el."Variant_Classification" = gs."Variant_Classification"
    GROUP BY el."Variant_Classification"
),
ssb AS (
    SELECT gs."Variant_Classification",
           gs.n_j,
           POWER(gs.mean_j - gm.grand_mean, 2) * gs.n_j AS SSB_j
    FROM group_stats gs
    CROSS JOIN grand_mean_cte gm
),
total_SSB AS (
    SELECT SUM(SSB_j) AS SSB
    FROM ssb
),
total_SSW AS (
    SELECT SUM(SSW_j) AS SSW
    FROM ssw
),
degrees_of_freedom AS (
    SELECT (SELECT COUNT(*) FROM group_stats) AS K,
           gm.total_samples AS N,
           (SELECT COUNT(*) FROM group_stats) - 1 AS df_between,
           gm.total_samples - (SELECT COUNT(*) FROM group_stats) AS df_within
    FROM grand_mean_cte gm
),
mean_squares AS (
    SELECT SSB / df_between AS MSB,
           SSW / df_within AS MSW
    FROM total_SSB, total_SSW, degrees_of_freedom
)
SELECT df.N AS total_samples,
       df.K AS number_of_mutation_types,
       ROUND(ms.MSB,4) AS mean_square_between_groups,
       ROUND(ms.MSW,4) AS mean_square_within_groups,
       ROUND(ms.MSB / ms.MSW,4) AS F_statistic
FROM degrees_of_freedom df
CROSS JOIN mean_squares ms;