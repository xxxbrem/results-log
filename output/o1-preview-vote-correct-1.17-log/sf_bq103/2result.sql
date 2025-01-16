WITH
  variants AS (
    SELECT *
    FROM GNOMAD.GNOMAD."V3_GENOMES__CHR1"
    WHERE "start_position" BETWEEN 55039447 AND 55064852
  ),
  num_variants AS (
    SELECT COUNT(*) AS num_variants
    FROM variants
  ),
  total_number_of_alleles AS (
    SELECT SUM("AN") AS total_AN
    FROM variants
  ),
  total_allele_count AS (
    SELECT SUM(alt.value:"AC"::NUMBER) AS total_AC
    FROM variants v,
    LATERAL FLATTEN(input => v."alternate_bases") alt
  ),
  distinct_gene_symbols AS (
    SELECT DISTINCT vep_entry.VALUE:"SYMBOL"::STRING AS gene_symbol
    FROM variants v,
    LATERAL FLATTEN(input => v."alternate_bases") alt,
    LATERAL FLATTEN(input => alt.value:"vep") vep_entry
    WHERE vep_entry.VALUE:"SYMBOL" IS NOT NULL
  )
SELECT
  (SELECT num_variants FROM num_variants) AS "number_variants",
  (SELECT total_AC FROM total_allele_count) AS "total_allele_count",
  (SELECT total_AN FROM total_number_of_alleles) AS "total_number_of_alleles",
  (SELECT LISTAGG(gene_symbol, ',') FROM distinct_gene_symbols) AS "distinct_gene_symbols",
  ROUND((55064852 - 55039447 + 1)::FLOAT / (SELECT num_variants FROM num_variants), 4) AS "density_mutations";