WITH
variants AS (
    SELECT t.*
    FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1 t
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
),
number_of_variants AS (
    SELECT COUNT(*) AS number_of_variants FROM variants
),
total_number_of_alleles AS (
    SELECT SUM("AN") AS total_number_of_alleles FROM variants
),
total_allele_count AS (
    SELECT SUM(ab.value:"AC"::INT) AS total_allele_count
    FROM variants v
    , LATERAL FLATTEN(INPUT => v."alternate_bases") ab
),
gene_symbols AS (
    SELECT DISTINCT vep.value:"SYMBOL"::STRING AS gene_symbol
    FROM variants v
    , LATERAL FLATTEN(INPUT => v."alternate_bases") ab
    , LATERAL FLATTEN(INPUT => ab.value:"vep") vep
    WHERE vep.value:"SYMBOL" IS NOT NULL
),
aggregated_gene_symbols AS (
    SELECT LISTAGG(gene_symbol, ', ') AS distinct_gene_symbols FROM gene_symbols
),
density_of_mutations AS (
    SELECT ROUND((55064852 - 55039447) / number_of_variants::FLOAT, 4) AS density_of_mutations
    FROM number_of_variants
)
SELECT
    nv.number_of_variants,
    ta.total_allele_count,
    tna.total_number_of_alleles,
    ags.distinct_gene_symbols,
    dm.density_of_mutations
FROM number_of_variants nv
CROSS JOIN total_allele_count ta
CROSS JOIN total_number_of_alleles tna
CROSS JOIN aggregated_gene_symbols ags
CROSS JOIN density_of_mutations dm;