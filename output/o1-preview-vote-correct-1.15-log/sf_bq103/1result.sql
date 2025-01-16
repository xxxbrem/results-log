WITH variants_in_region AS (
  SELECT *
  FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1
  WHERE "reference_name" = 'chr1'
    AND "start_position" BETWEEN 55039447 AND 55064852
),
variant_counts AS (
  SELECT
    COUNT(*) AS num_variants,
    SUM("AN") AS total_number_of_alleles
  FROM variants_in_region
),
alternate_alleles AS (
  SELECT
    t."start_position",
    ab.value::VARIANT AS alt_allele
  FROM variants_in_region t,
       LATERAL FLATTEN(input => t."alternate_bases") ab
),
allele_counts AS (
  SELECT SUM(alt_allele:"AC"::INT) AS total_allele_count
  FROM alternate_alleles
),
vep_annotations AS (
  SELECT DISTINCT ve.value:"SYMBOL"::STRING AS gene_symbol
  FROM alternate_alleles aa,
       LATERAL FLATTEN(input => aa.alt_allele:"vep") ve
  WHERE ve.value:"SYMBOL" IS NOT NULL
)
SELECT
  (SELECT num_variants FROM variant_counts) AS "number_of_variants",
  (SELECT total_allele_count FROM allele_counts) AS "total_allele_count",
  (SELECT total_number_of_alleles FROM variant_counts) AS "total_number_of_alleles",
  ROUND((55064852 - 55039447 + 1)::FLOAT / (SELECT num_variants FROM variant_counts), 4) AS "density_of_mutations",
  ARRAY_AGG(DISTINCT gene_symbol) AS "distinct_gene_symbols"
FROM vep_annotations;