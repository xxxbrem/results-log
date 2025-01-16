WITH region_variants AS (
  SELECT *
  FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1"
  WHERE "start_position" BETWEEN 55039447 AND 55064852
),
allele_counts AS (
  SELECT
    SUM(TO_NUMBER(ab.value:"AC"::STRING)) AS total_allele_count
  FROM region_variants rv,
  LATERAL FLATTEN(input => rv."alternate_bases") AS ab
),
gene_symbols AS (
  SELECT DISTINCT vep.value:"SYMBOL"::STRING AS gene_symbol
  FROM region_variants rv,
  LATERAL FLATTEN(input => rv."alternate_bases") AS ab,
  LATERAL FLATTEN(input => ab.value:"vep") AS vep
  WHERE vep.value:"SYMBOL" IS NOT NULL
)
SELECT
  COUNT(*) AS "Number_of_variants",
  (SELECT total_allele_count FROM allele_counts) AS "Total_allele_count",
  SUM("AN") AS "Total_number_of_alleles",
  (
    SELECT LISTAGG(gene_symbol, ', ') WITHIN GROUP (ORDER BY gene_symbol)
    FROM gene_symbols
  ) AS "Distinct_gene_symbols",
  ROUND(25405.0 / COUNT(*), 4) AS "Density_of_mutations"
FROM region_variants;