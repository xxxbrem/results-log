WITH gene_symbols AS (
    SELECT DISTINCT v.value:"SYMBOL"::STRING AS "gene_symbol"
    FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1 t,
         LATERAL FLATTEN(input => t."alternate_bases") f,
         LATERAL FLATTEN(input => f.value:"vep") v
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
)

SELECT
    COUNT(*) AS "Number_of_variants",
    SUM("AN") AS "Total_allele_count",
    (
        SELECT SUM(f.value:"AC"::INT)
        FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1 t2,
             LATERAL FLATTEN(input => t2."alternate_bases") f
        WHERE t2."start_position" BETWEEN 55039447 AND 55064852
    ) AS "Total_number_of_alleles",
    (
        SELECT ARRAY_AGG(DISTINCT g."gene_symbol")
        FROM gene_symbols g
    ) AS "Distinct_gene_symbols",
    ROUND((55064852 - 55039447 + 1)::FLOAT / COUNT(*), 4) AS "Density_of_mutations"
FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1 t
WHERE t."start_position" BETWEEN 55039447 AND 55064852;