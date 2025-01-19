WITH variants_in_region AS (
    SELECT *
    FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1" t
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
),
number_of_variants AS (
    SELECT COUNT(*) AS "variant_count"
    FROM variants_in_region
),
total_number_of_alleles AS (
    SELECT SUM(t."AN") AS "total_number_of_alleles"
    FROM variants_in_region t
),
total_allele_count AS (
    SELECT SUM(alt.value:"AC"::INT) AS "total_allele_count"
    FROM variants_in_region t,
         LATERAL FLATTEN(input => t."alternate_bases") alt
),
density_of_mutations AS (
    SELECT 
        "variant_count"::FLOAT / (55064852 - 55039447) AS "density_of_mutations"
    FROM number_of_variants
),
distinct_gene_symbols AS (
    SELECT DISTINCT gene.value:"SYMBOL"::STRING AS "gene_symbol"
    FROM variants_in_region t,
         LATERAL FLATTEN(input => t."alternate_bases") alt,
         LATERAL FLATTEN(input => alt.value:"vep") gene
    WHERE gene.value:"SYMBOL" IS NOT NULL AND gene.value:"SYMBOL"::STRING <> ''
)
SELECT 'Statistic', 'Value'
UNION ALL
SELECT 'Number_of_variants', CAST("variant_count" AS STRING)
FROM number_of_variants
UNION ALL
SELECT 'Total_allele_count', CAST("total_allele_count" AS STRING)
FROM total_allele_count
UNION ALL
SELECT 'Total_number_of_alleles', CAST("total_number_of_alleles" AS STRING)
FROM total_number_of_alleles
UNION ALL
SELECT 'Density_of_mutations', TO_VARCHAR("density_of_mutations", '9999999999.0000')
FROM density_of_mutations
UNION ALL
SELECT 'Distinct_gene_symbols', LISTAGG("gene_symbol", '; ') AS "Value"
FROM distinct_gene_symbols;