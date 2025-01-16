WITH variant_data AS (
    SELECT 
        t."start_position", 
        t."AN", 
        t."alternate_bases"
    FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1 t
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
),
number_of_variants AS (
    SELECT COUNT(*) AS number_of_variants
    FROM variant_data
),
total_number_of_alleles AS (
    SELECT SUM(t."AN") AS total_number_of_alleles
    FROM variant_data t
),
allele_counts AS (
    SELECT 
        ab.value:"AC"::INT AS AC
    FROM variant_data vd
    , LATERAL FLATTEN(input => vd."alternate_bases") ab
),
total_allele_count AS (
    SELECT SUM(AC) AS total_allele_count
    FROM allele_counts
),
distinct_gene_symbols AS (
    SELECT DISTINCT f.value:"SYMBOL"::STRING AS gene_symbol
    FROM variant_data vd
    , LATERAL FLATTEN(input => vd."alternate_bases") ab
    , LATERAL FLATTEN(input => ab.value:"vep") f
    WHERE f.value:"SYMBOL"::STRING IS NOT NULL AND f.value:"SYMBOL"::STRING != ''
)
SELECT
    (SELECT number_of_variants FROM number_of_variants) AS "number_of_variants",
    (SELECT total_allele_count FROM total_allele_count) AS "total_allele_count",
    (SELECT total_number_of_alleles FROM total_number_of_alleles) AS "total_number_of_alleles",
    LISTAGG(DISTINCT gene_symbol, ', ') AS "distinct_gene_symbols",
    (55064852 - 55039447 + 1) AS "length_of_region",
    ROUND((55064852 - 55039447 + 1)::FLOAT / (SELECT number_of_variants FROM number_of_variants), 4) AS "mutation_density"
FROM distinct_gene_symbols;