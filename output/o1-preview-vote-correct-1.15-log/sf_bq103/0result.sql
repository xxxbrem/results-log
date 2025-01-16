WITH region_variants AS (
  SELECT *
  FROM GNOMAD.GNOMAD.V3_GENOMES__CHR1
  WHERE "start_position" BETWEEN 55039447 AND 55064852
)

SELECT
  (SELECT COUNT(*) FROM region_variants) AS "number_of_variants",
  (SELECT SUM(CAST(alt.value:"AC" AS INT))
     FROM region_variants rv1,
     LATERAL FLATTEN(input => rv1."alternate_bases") alt) AS "total_allele_count",
  (SELECT SUM(rv2."AN") FROM region_variants rv2) AS "total_number_of_alleles",
  ROUND((55064852 - 55039447 + 1)::FLOAT / (SELECT COUNT(*) FROM region_variants), 4) AS "density_of_mutations",
  (SELECT LISTAGG(DISTINCT vep.value:"SYMBOL"::STRING, '; ') FROM
     region_variants rv3,
     LATERAL FLATTEN(input => rv3."alternate_bases") alt,
     LATERAL FLATTEN(input => alt.value:"vep") vep
   WHERE vep.value:"SYMBOL" IS NOT NULL AND vep.value:"SYMBOL"::STRING != '') AS "distinct_gene_symbols"
;