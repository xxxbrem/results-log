SELECT
    COUNT(DISTINCT CONCAT(t."start_position", '_', ab.value:"alt"::STRING)) AS "number_of_variants",
    SUM(ab.value:"AC"::INT) AS "total_allele_count",
    MAX(t."AN") AS "total_number_of_alleles",
    LISTAGG(DISTINCT vep.value:"SYMBOL"::STRING, ', ') AS "distinct_gene_symbols",
    ROUND(25406.0 / COUNT(DISTINCT CONCAT(t."start_position", '_', ab.value:"alt"::STRING)), 4) AS "density_of_mutations"
FROM
    GNOMAD.GNOMAD.V3_GENOMES__CHR1 t,
    LATERAL FLATTEN(input => t."alternate_bases") ab,
    LATERAL FLATTEN(input => ab.value:"vep") vep
WHERE
    t."start_position" BETWEEN 55039447 AND 55064852;