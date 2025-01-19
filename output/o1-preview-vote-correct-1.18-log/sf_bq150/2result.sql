WITH
    "SEVERITY_MAP" AS (
        SELECT 'Nonsense_Mutation' AS "Variant_Classification", 1 AS "Severity_Level"
        UNION ALL SELECT 'Frame_Shift_Del', 2
        UNION ALL SELECT 'Frame_Shift_Ins', 2
        UNION ALL SELECT 'Splice_Site', 3
        UNION ALL SELECT 'In_Frame_Del', 4
        UNION ALL SELECT 'In_Frame_Ins', 4
        UNION ALL SELECT 'Missense_Mutation', 5
        UNION ALL SELECT 'Silent', 6
    ),
    "Mutation_Data" AS (
        SELECT 
            mut."case_barcode",
            mut."sample_barcode_tumor" AS "sample_barcode",
            COALESCE(map."Variant_Classification", 'Other') AS "Variant_Classification",
            COALESCE(map."Severity_Level", 7) AS "Severity_Level"
        FROM 
            "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3" mut
        LEFT JOIN "SEVERITY_MAP" map
            ON mut."Variant_Classification" = map."Variant_Classification"
        WHERE 
            mut."project_short_name" = 'TCGA-BRCA'
            AND mut."Hugo_Symbol" = 'TP53'
    ),
    "Mutation_Type_Per_Sample" AS (
        SELECT
            mut."case_barcode",
            mut."sample_barcode",
            FIRST_VALUE(mut."Variant_Classification") OVER (
                PARTITION BY mut."sample_barcode" 
                ORDER BY mut."Severity_Level" ASC
            ) AS "Variant_Classification"
        FROM
            "Mutation_Data" mut
        QUALIFY ROW_NUMBER() OVER (
            PARTITION BY mut."sample_barcode"
            ORDER BY mut."Severity_Level" ASC
        ) = 1
    ),
    "Expression_Data" AS (
        SELECT 
            expr."case_barcode",
            expr."sample_barcode",
            LOG(10, expr."normalized_count") AS "log_expression"
        FROM 
            "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM" expr
        WHERE 
            expr."project_short_name" = 'TCGA-BRCA'
            AND expr."HGNC_gene_symbol" = 'TP53'
            AND expr."normalized_count" > 0
            AND SUBSTRING(expr."sample_barcode", 14, 2) = '01'
    ),
    "Combined_Data" AS (
        SELECT 
            expr."case_barcode",
            expr."sample_barcode",
            expr."log_expression",
            COALESCE(mut."Variant_Classification", 'Wildtype') AS "Variant_Classification"
        FROM
            "Expression_Data" expr
        LEFT JOIN
            "Mutation_Type_Per_Sample" mut
        ON
            expr."sample_barcode" = mut."sample_barcode"
    ),
    "Overall_Mean" AS (
        SELECT AVG("log_expression") AS "Grand_Mean" FROM "Combined_Data"
    ),
    "Group_Means" AS (
        SELECT
            "Variant_Classification",
            AVG("log_expression") AS "Group_Mean",
            COUNT(*) AS "n_j"
        FROM
            "Combined_Data"
        GROUP BY
            "Variant_Classification"
    ),
    "SSB" AS (
        SELECT SUM(gm."n_j" * 
            POWER(gm."Group_Mean" - om."Grand_Mean", 2)
        ) AS "SSB"
        FROM "Group_Means" gm, "Overall_Mean" om
    ),
    "SSW" AS (
        SELECT SUM(
            POWER(cd."log_expression" - gm."Group_Mean", 2)
        ) AS "SSW"
        FROM
            "Combined_Data" cd
        JOIN
            "Group_Means" gm
        ON
            cd."Variant_Classification" = gm."Variant_Classification"
    ),
    "Total_Samples" AS (
        SELECT COUNT(*) AS "N" FROM "Combined_Data"
    ),
    "Number_of_Groups" AS (
        SELECT COUNT(*) AS "g" FROM (SELECT DISTINCT "Variant_Classification" FROM "Combined_Data")
    ),
    "Degrees_of_Freedom" AS (
        SELECT
            ("g" - 1) AS "df_between",
            ("N" - "g") AS "df_within"
        FROM
            "Total_Samples", "Number_of_Groups"
    ),
    "Mean_Squares" AS (
        SELECT
            ("SSB"."SSB" / "Degrees_of_Freedom"."df_between") AS "MSB",
            ("SSW"."SSW" / "Degrees_of_Freedom"."df_within") AS "MSW"
        FROM
            "SSB", "SSW", "Degrees_of_Freedom"
    ),
    "F_statistic" AS (
        SELECT
            ("Mean_Squares"."MSB" / "Mean_Squares"."MSW") AS "F_statistic"
        FROM
            "Mean_Squares"
    ),
    "Final_Result" AS (
        SELECT
            "Total_Samples"."N" AS "total_samples",
            "Number_of_Groups"."g" AS "mutation_types",
            "Mean_Squares"."MSB" AS "mean_square_between",
            "Mean_Squares"."MSW" AS "mean_square_within",
            "F_statistic"."F_statistic"
        FROM
            "Total_Samples",
            "Number_of_Groups",
            "Mean_Squares",
            "F_statistic"
    )
SELECT
    'Total number of samples,Number of mutation types,Mean square between groups,Mean square within groups,F-statistic'
UNION ALL
SELECT
    CONCAT(
        CAST("total_samples" AS VARCHAR), ',',
        CAST("mutation_types" AS VARCHAR), ',',
        CAST(ROUND("mean_square_between", 4) AS VARCHAR), ',',
        CAST(ROUND("mean_square_within", 4) AS VARCHAR), ',',
        CAST(ROUND("F_statistic", 4) AS VARCHAR)
    ) AS "Result"
FROM
    "Final_Result";