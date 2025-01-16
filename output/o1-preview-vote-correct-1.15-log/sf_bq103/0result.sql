WITH filtered_variants AS (
    SELECT *
    FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1
    WHERE "start_position" >= 55039447 AND "end_position" <= 55064852
),
number_of_variants AS (
    SELECT COUNT(DISTINCT "start_position", "reference_bases", ab.value) AS num_variants
    FROM filtered_variants
    , LATERAL FLATTEN(input => "alternate_bases") ab
),
allele_counts AS (
    SELECT
        "AN",
        TRY_TO_NUMBER(ab.value:"AC"::STRING) AS AC,
        vep_entry.value:"SYMBOL"::STRING AS gene_symbol
    FROM filtered_variants
    , LATERAL FLATTEN(input => "alternate_bases") ab
    , LATERAL FLATTEN(input => ab.value:"vep") vep_entry
)
SELECT
    (SELECT num_variants FROM number_of_variants) AS "Number_of_variants",
    SUM(allele_counts.AC) AS "Total_allele_count",
    SUM(allele_counts."AN") AS "Total_number_of_alleles",
    ROUND(((55064852 - 55039447 + 1)::FLOAT) / (SELECT num_variants FROM number_of_variants), 4) AS "Density_of_mutations",
    ARRAY_AGG(DISTINCT allele_counts.gene_symbol) AS "Distinct_gene_symbols"
FROM allele_counts;