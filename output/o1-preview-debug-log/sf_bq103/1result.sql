WITH
  number_of_variants_cte AS (
    SELECT COUNT(*) AS "number_of_variants"
    FROM GNOMAD.GNOMAD."V3_GENOMES__CHR1" t
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
  ),
  total_number_of_alleles_cte AS (
    SELECT SUM(t."AN") AS "total_number_of_alleles"
    FROM GNOMAD.GNOMAD."V3_GENOMES__CHR1" t
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
  ),
  total_allele_count_cte AS (
    SELECT SUM(ab.value:"AC"::NUMBER) AS "total_allele_count"
    FROM GNOMAD.GNOMAD."V3_GENOMES__CHR1" t,
    LATERAL FLATTEN(input => t."alternate_bases") ab
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
  ),
  distinct_gene_symbols_cte AS (
    SELECT DISTINCT vep_item.value:"SYMBOL"::STRING AS "gene_symbol"
    FROM GNOMAD.GNOMAD."V3_GENOMES__CHR1" t,
    LATERAL FLATTEN(input => t."alternate_bases") ab,
    LATERAL FLATTEN(input => ab.value:"vep") vep_item
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
      AND vep_item.value:"SYMBOL" IS NOT NULL
  )
SELECT
  (SELECT "number_of_variants" FROM number_of_variants_cte) AS "number_of_variants",
  (SELECT "total_allele_count" FROM total_allele_count_cte) AS "total_allele_count",
  (SELECT "total_number_of_alleles" FROM total_number_of_alleles_cte) AS "total_number_of_alleles",
  ARRAY_AGG(DISTINCT "gene_symbol") AS "distinct_gene_symbols",
  ROUND((55064852 - 55039447)::FLOAT / NULLIF((SELECT "number_of_variants" FROM number_of_variants_cte), 0), 4) AS "density_of_mutations"
FROM distinct_gene_symbols_cte;