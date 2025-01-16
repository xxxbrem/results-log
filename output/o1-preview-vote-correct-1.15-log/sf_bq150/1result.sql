WITH expression_data AS (
    SELECT
        "sample_barcode",
        "case_barcode",
        LOG(10, "normalized_count") AS log_expression
    FROM
        TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0.RNASEQ_GENE_EXPRESSION_UNC_RSEM
    WHERE
        "project_short_name" = 'TCGA-BRCA'
        AND "HGNC_gene_symbol" = 'TP53'
        AND "normalized_count" IS NOT NULL
        AND "normalized_count" > 0
),
mutation_data AS (
    SELECT
        "sample_barcode_tumor",
        "case_barcode",
        "Variant_Classification",
        CASE "Variant_Classification"
            WHEN 'Nonsense_Mutation' THEN 1
            WHEN 'Frame_Shift_Del' THEN 2
            WHEN 'Frame_Shift_Ins' THEN 3
            WHEN 'Splice_Site' THEN 4
            WHEN 'Translation_Start_Site' THEN 5
            WHEN 'Nonstop_Mutation' THEN 6
            WHEN 'In_Frame_Del' THEN 7
            WHEN 'In_Frame_Ins' THEN 8
            WHEN 'Missense_Mutation' THEN 9
            WHEN '5''UTR' THEN 10
            WHEN 'Silent' THEN 11
            ELSE 12
        END AS severity_rank
    FROM
        TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0.SOMATIC_MUTATION_MC3
    WHERE
        "project_short_name" = 'TCGA-BRCA'
        AND "Hugo_Symbol" = 'TP53'
),
mutation_severity AS (
    SELECT
        "sample_barcode_tumor",
        "case_barcode",
        MIN(severity_rank) AS min_severity_rank
    FROM
        mutation_data
    GROUP BY
        "sample_barcode_tumor",
        "case_barcode"
),
mutation_assignments AS (
    SELECT DISTINCT
        md."sample_barcode_tumor",
        md."case_barcode",
        md."Variant_Classification",
        md.severity_rank
    FROM
        mutation_data md
        INNER JOIN mutation_severity ms
            ON md."sample_barcode_tumor" = ms."sample_barcode_tumor"
            AND md.severity_rank = ms.min_severity_rank
),
joined_data AS (
    SELECT
        e."sample_barcode",
        e."case_barcode",
        e.log_expression,
        COALESCE(ma."Variant_Classification", 'No Mutation') AS Variant_Classification
    FROM
        expression_data e
        LEFT JOIN mutation_assignments ma
            ON e."sample_barcode" = ma."sample_barcode_tumor"
),
grand_mean AS (
    SELECT AVG(log_expression) AS grand_mean FROM joined_data
),
group_stats AS (
    SELECT
        Variant_Classification,
        COUNT(*) AS n_j,
        AVG(log_expression) AS group_mean
    FROM
        joined_data
    GROUP BY
        Variant_Classification
),
ssb AS (
    SELECT
        SUM(gs.n_j * POWER(gs.group_mean - gm.grand_mean, 2)) AS SSB
    FROM
        group_stats gs, grand_mean gm
),
ssw AS (
    SELECT
        SUM(POWER(jd.log_expression - gs.group_mean, 2)) AS SSW
    FROM
        joined_data jd
        INNER JOIN group_stats gs
            ON jd.Variant_Classification = gs.Variant_Classification
),
dfs AS (
    SELECT
        (SELECT COUNT(DISTINCT Variant_Classification) FROM joined_data) - 1 AS df_between,
        (SELECT COUNT(*) FROM joined_data) - (SELECT COUNT(DISTINCT Variant_Classification) FROM joined_data) AS df_within
),
ms AS (
    SELECT
        ssb.SSB / NULLIF(dfs.df_between, 0) AS MSB,
        ssw.SSW / NULLIF(dfs.df_within, 0) AS MSW
    FROM
        ssb, ssw, dfs
)
SELECT
    CAST((SELECT COUNT(*) FROM joined_data) AS INT) AS total_number_of_samples,
    CAST((SELECT COUNT(DISTINCT Variant_Classification) FROM joined_data) AS INT) AS number_of_mutation_types,
    ROUND(ms.MSB, 4) AS mean_square_between_groups,
    ROUND(ms.MSW, 4) AS mean_square_within_groups,
    ROUND(ms.MSB / ms.MSW, 4) AS F_statistic
FROM
    ms;