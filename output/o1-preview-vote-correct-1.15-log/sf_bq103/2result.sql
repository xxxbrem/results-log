WITH variants AS (
    SELECT *
    FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1
    WHERE "start_position" BETWEEN 55039447 AND 55064852
),
number_of_variants AS (
    SELECT COUNT(*) AS num_variants
    FROM variants
),
total_allele_count AS (
    SELECT SUM(ab.value:AC::INT) AS total_allele_count
    FROM variants,
         LATERAL FLATTEN(input => "alternate_bases") ab
),
total_number_of_alleles AS (
    SELECT SUM("AN") AS total_number_of_alleles
    FROM variants
),
gene_symbols AS (
    SELECT DISTINCT vep.value:SYMBOL::STRING AS gene_symbol
    FROM variants,
         LATERAL FLATTEN(input => "alternate_bases") ab,
         LATERAL FLATTEN(input => ab.value:vep) vep
    WHERE vep.value:SYMBOL IS NOT NULL AND vep.value:SYMBOL::STRING != ''
)
SELECT
    (SELECT num_variants FROM number_of_variants) AS number_of_variants,
    (SELECT total_allele_count FROM total_allele_count) AS total_allele_count,
    (SELECT total_number_of_alleles FROM total_number_of_alleles) AS total_number_of_alleles,
    (SELECT LISTAGG(gene_symbol, ',') FROM gene_symbols) AS distinct_gene_symbols,
    ROUND(25406 / (SELECT num_variants FROM number_of_variants)::FLOAT, 4) AS density_of_mutations;