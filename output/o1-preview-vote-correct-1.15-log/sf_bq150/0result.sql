WITH
-- Expression data
expr_data AS (
  SELECT 
    "sample_barcode",
    LOG(10, "normalized_count") AS log_expression
  FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
  WHERE "HGNC_gene_symbol" = 'TP53'
    AND "project_short_name" = 'TCGA-BRCA'
    AND "normalized_count" > 0
),

-- Mutation severity mapping
mutation_severity AS (
  SELECT * FROM ( VALUES 
    ('Frame_Shift_Ins', 5),
    ('Nonsense_Mutation', 4),
    ('Splice_Site', 4),
    ('In_Frame_Del', 3),
    ('Missense_Mutation', 2)
  ) AS t("Variant_Classification", severity)
),

-- Mutation data
mut_data AS (
  SELECT 
    "sample_barcode_tumor" AS "sample_barcode",
    "Variant_Classification"
  FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."SOMATIC_MUTATION_MC3"
  WHERE "Hugo_Symbol" = 'TP53'
    AND "project_short_name" = 'TCGA-BRCA'
),

-- Join mutation data with severity
mut_data_with_severity AS (
  SELECT 
    m."sample_barcode",
    m."Variant_Classification",
    s.severity
  FROM mut_data m
  LEFT JOIN mutation_severity s
    ON m."Variant_Classification" = s."Variant_Classification"
),

-- Get the highest severity mutation per sample
max_severity_per_sample AS (
  SELECT 
    "sample_barcode",
    "Variant_Classification",
    severity,
    ROW_NUMBER() OVER (PARTITION BY "sample_barcode" ORDER BY severity DESC) AS rn
  FROM mut_data_with_severity
),

-- Keep only the highest severity mutation per sample
sample_mut_type AS (
  SELECT 
    "sample_barcode",
    "Variant_Classification",
    severity
  FROM max_severity_per_sample
  WHERE rn = 1
),

-- Join expression data with mutation data using LEFT JOIN
data_with_mutation AS (
  SELECT 
    e."sample_barcode",
    e.log_expression,
    COALESCE(s."Variant_Classification", 'No Mutation') AS "Variant_Classification"
  FROM expr_data e
  LEFT JOIN sample_mut_type s
    ON e."sample_barcode" = s."sample_barcode"
),

-- Compute grand mean
grand_mean_cte AS (
  SELECT AVG(log_expression) AS grand_mean FROM data_with_mutation
),

-- Compute group stats
group_stats AS (
  SELECT 
    "Variant_Classification",
    COUNT(*) AS n_j,
    AVG(log_expression) AS mean_j
  FROM data_with_mutation
  GROUP BY "Variant_Classification"
),

-- Compute SSB
ssb_cte AS (
  SELECT 
    SUM(n_j * POWER(mean_j - gm.grand_mean, 2)) AS SSB
  FROM group_stats gs, grand_mean_cte gm
),

-- Compute sample deviations
sample_deviations AS (
  SELECT
    d."sample_barcode",
    d.log_expression,
    d."Variant_Classification",
    g.mean_j,
    POWER(d.log_expression - g.mean_j, 2) AS squared_diff
  FROM data_with_mutation d
  INNER JOIN group_stats g
    ON d."Variant_Classification" = g."Variant_Classification"
),

-- Compute SSW
ssw_cte AS (
  SELECT SUM(squared_diff) AS SSW FROM sample_deviations
),

-- Compute degrees of freedom
degrees_of_freedom AS (
  SELECT
    (SELECT COUNT(*) FROM data_with_mutation) AS total_samples,
    (SELECT COUNT(*) FROM group_stats) AS number_of_mutation_types,
    ((SELECT COUNT(*) FROM group_stats) - 1) AS df_between,
    ((SELECT COUNT(*) FROM data_with_mutation) - (SELECT COUNT(*) FROM group_stats)) AS df_within
),

-- Compute Mean Squares and F-statistic, limit decimals to four decimal places
anova_results AS (
  SELECT
    df.total_samples,
    df.number_of_mutation_types,
    ROUND(ssb.SSB / df.df_between, 4) AS mean_square_between_groups,
    ROUND(ssw.SSW / df.df_within, 4) AS mean_square_within_groups,
    ROUND((ssb.SSB / df.df_between) / (ssw.SSW / df.df_within), 4) AS f_statistic
  FROM ssb_cte ssb, ssw_cte ssw, degrees_of_freedom df
)

-- Finally, select the needed output
SELECT
  total_samples,
  number_of_mutation_types,
  mean_square_between_groups,
  mean_square_within_groups,
  f_statistic
FROM anova_results;