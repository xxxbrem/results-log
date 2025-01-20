WITH Data AS (
    SELECT
        expr."case_barcode",
        LOG(10, expr."normalized_count") AS "log_expression",
        COALESCE(mut."Variant_Classification", 'Wild_Type') AS "Mutation_Type"
    FROM 
        "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM" expr
    LEFT JOIN 
        "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3" mut
    ON 
        expr."case_barcode" = mut."case_barcode" 
        AND mut."project_short_name" = 'TCGA-BRCA'
        AND mut."Hugo_Symbol" = 'TP53'
    WHERE 
        expr."project_short_name" = 'TCGA-BRCA' 
        AND expr."HGNC_gene_symbol" = 'TP53' 
        AND expr."normalized_count" > 0
    GROUP BY expr."case_barcode", expr."normalized_count", mut."Variant_Classification"
),
Total_Samples AS (
    SELECT COUNT(*) AS N
    FROM Data
),
Number_of_Mutation_Types AS (
    SELECT COUNT(DISTINCT "Mutation_Type") AS k
    FROM Data
),
Grand_Mean AS (
    SELECT AVG("log_expression") AS "Grand_Mean"
    FROM Data
),
Group_Means AS (
    SELECT 
        "Mutation_Type",
        COUNT(*) AS n_j,
        AVG("log_expression") AS "Group_Mean"
    FROM Data
    GROUP BY "Mutation_Type"
),
SSB AS (
    SELECT 
        SUM(gm.n_j * POWER(gm."Group_Mean" - gm1."Grand_Mean", 2)) AS SSB_value
    FROM Group_Means gm
    CROSS JOIN Grand_Mean gm1
),
SSW AS (
    SELECT SUM(POWER(d."log_expression" - gm."Group_Mean", 2)) AS SSW_value
    FROM Data d
    JOIN Group_Means gm ON d."Mutation_Type" = gm."Mutation_Type"
),
Degrees_Of_Freedom AS (
    SELECT
        nt.k - 1 AS df_between,
        ts.N - nt.k AS df_within
    FROM Total_Samples ts, Number_of_Mutation_Types nt
),
Mean_Square_Between AS (
    SELECT
        ssb.SSB_value / dof.df_between AS MSB_value
    FROM SSB ssb, Degrees_Of_Freedom dof
),
Mean_Square_Within AS (
    SELECT
        ssw.SSW_value / dof.df_within AS MSW_value
    FROM SSW ssw, Degrees_Of_Freedom dof
)
SELECT
    ts.N AS Total_samples,
    nt.k AS Number_of_mutation_types,
    ROUND(msb.MSB_value, 4) AS Mean_square_between_groups,
    ROUND(msw.MSW_value, 4) AS Mean_square_within_groups,
    ROUND(msb.MSB_value / msw.MSW_value, 4) AS F_statistic
FROM
    Total_Samples ts,
    Number_of_Mutation_Types nt,
    Mean_Square_Between msb,
    Mean_Square_Within msw;