WITH variants AS (
  SELECT *
  FROM GNOMAD.GNOMAD."V3_GENOMES__CHR1"
  WHERE "start_position" BETWEEN 55039447 AND 55064852
),
number_variants AS (
  SELECT COUNT(*) AS "number_variants"
  FROM variants
),
total_number_alleles AS (
  SELECT SUM("AN") AS "total_number_alleles"
  FROM variants
),
total_allele_count AS (
  SELECT SUM(alt.value:"AC"::NUMBER) AS "total_allele_count"
  FROM variants,
       LATERAL FLATTEN(input => "alternate_bases") alt
),
mutation_density AS (
  SELECT ROUND((55064852 - 55039447) / NULLIF("number_variants", 0), 4) AS "mutation_density"
  FROM number_variants
)
SELECT
  number_variants."number_variants",
  total_allele_count."total_allele_count",
  total_number_alleles."total_number_alleles",
  (
    SELECT ARRAY_AGG(DISTINCT vep.value:"SYMBOL"::STRING)
    FROM variants,
         LATERAL FLATTEN(input => "alternate_bases") alt,
         LATERAL FLATTEN(input => alt.value:"vep") vep
    WHERE vep.value:"SYMBOL"::STRING IS NOT NULL
  ) AS "distinct_gene_symbols",
  mutation_density."mutation_density"
FROM
  number_variants,
  total_allele_count,
  total_number_alleles,
  mutation_density;