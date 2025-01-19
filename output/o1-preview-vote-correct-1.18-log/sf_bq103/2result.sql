SELECT
    COUNT(*) AS number_of_variants,
    SUM(TRY_CAST(ab.value:"AC"::STRING AS NUMBER)) AS total_allele_count,
    SUM(t."AN") AS total_number_of_alleles,
    LISTAGG(DISTINCT vep.value:"SYMBOL"::STRING, ', ') AS gene_symbols,
    ROUND((55064852 - 55039447 + 1) / COUNT(*), 4) AS density_of_mutations
FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1 t,
     LATERAL FLATTEN(input => t."alternate_bases") ab,
     LATERAL FLATTEN(input => ab.value:"vep") vep
WHERE t."start_position" BETWEEN 55039447 AND 55064852;