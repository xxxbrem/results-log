WITH variants AS (
    SELECT *
    FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1
    WHERE "start_position" BETWEEN 55039447 AND 55064852
)
SELECT
    COUNT(*) AS "number_of_variants",
    (
        SELECT SUM(TO_NUMBER(ab.value:"AC"::STRING))
        FROM variants,
        LATERAL FLATTEN(input => variants."alternate_bases") ab
    ) AS "total_allele_count",
    SUM("AN") AS "total_number_of_alleles",
    ROUND(25405.0 / COUNT(*), 4) AS "density_of_mutations",
    (
        SELECT ARRAY_AGG(DISTINCT vep_entry.value:"SYMBOL"::STRING)
        FROM variants,
        LATERAL FLATTEN(input => variants."alternate_bases") ab,
        LATERAL FLATTEN(input => ab.value:"vep") vep_entry
        WHERE vep_entry.value:"SYMBOL" IS NOT NULL
    ) AS "distinct_gene_symbols"
FROM variants;