WITH sample_data AS (
  SELECT expr."sample_barcode", 
         LOG(10, expr."normalized_count") AS "log_expression", 
         COALESCE(mut."Variant_Classification", 'Wildtype') AS "mutation_type"
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM" AS expr
  LEFT JOIN (
    SELECT DISTINCT "sample_barcode_tumor", "Variant_Classification"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "Hugo_Symbol" = 'TP53'
  ) AS mut
  ON expr."sample_barcode" = mut."sample_barcode_tumor"
  WHERE expr."project_short_name" = 'TCGA-BRCA' 
    AND expr."HGNC_gene_symbol" = 'TP53' 
    AND expr."normalized_count" > 0
),
grand_stats AS (
  SELECT COUNT(*) AS N, AVG("log_expression") AS grand_mean
  FROM sample_data
),
group_stats AS (
  SELECT "mutation_type", COUNT(*) AS n_j, AVG("log_expression") AS mean_j
  FROM sample_data
  GROUP BY "mutation_type"
),
ssb_calc AS (
  SELECT SUM(gs.n_j * POWER(gs.mean_j - g.grand_mean, 2)) AS SSB
  FROM group_stats gs
  CROSS JOIN grand_stats g
),
ssw_calc AS (
  SELECT SUM(POWER(sd."log_expression" - gs.mean_j, 2)) AS SSW
  FROM sample_data sd
  JOIN group_stats gs ON sd."mutation_type" = gs."mutation_type"
),
degrees_of_freedom AS (
  SELECT (SELECT COUNT(*) FROM group_stats) - 1 AS df_between, 
         (SELECT N FROM grand_stats) - (SELECT COUNT(*) FROM group_stats) AS df_within
),
ms_calc AS (
  SELECT ssb.SSB / df.df_between AS MSB, ssw.SSW / df.df_within AS MSW
  FROM ssb_calc ssb, ssw_calc ssw, degrees_of_freedom df
),
f_stat_calc AS (
  SELECT ms.MSB, ms.MSW, ms.MSB / ms.MSW AS F_statistic
  FROM ms_calc ms
),
group_counts AS (
  SELECT COUNT(*) AS num_mutation_types
  FROM group_stats
)
SELECT CAST(g.N AS INT) AS total_samples,
       CAST(gc.num_mutation_types AS INT) AS number_mutation_types,
       ROUND(f.MSB, 4) AS mean_square_between_groups,
       ROUND(f.MSW, 4) AS mean_square_within_groups,
       ROUND(f.F_statistic, 4) AS F_statistic
FROM grand_stats g
CROSS JOIN f_stat_calc f
CROSS JOIN group_counts gc;