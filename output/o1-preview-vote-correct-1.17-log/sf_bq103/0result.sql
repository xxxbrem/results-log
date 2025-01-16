SELECT
  var_counts."number_of_variants",
  allele_counts."total_allele_count",
  an_total."total_number_of_alleles",
  gene_list."distinct_gene_symbols",
  ROUND((55064852 - 55039447 + 1) / var_counts."number_of_variants", 4) AS "density_of_mutations"
FROM
  (
    SELECT COUNT(*) AS "number_of_variants"
    FROM
      (
        SELECT t."start_position", f.value:"alt"::STRING AS "alternate_allele"
        FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1" t,
        LATERAL FLATTEN(input => t."alternate_bases") f
        WHERE t."start_position" BETWEEN 55039447 AND 55064852
      ) variants
  ) var_counts
CROSS JOIN
  (
    SELECT SUM(f.value:"AC"::INT) AS "total_allele_count"
    FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1" t,
    LATERAL FLATTEN(input => t."alternate_bases") f
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
  ) allele_counts
CROSS JOIN
  (
    SELECT SUM("AN") AS "total_number_of_alleles"
    FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1"
    WHERE "start_position" BETWEEN 55039447 AND 55064852
  ) an_total
CROSS JOIN
  (
    SELECT LISTAGG(DISTINCT v.value:"SYMBOL"::STRING, ', ') AS "distinct_gene_symbols"
    FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1" t,
    LATERAL FLATTEN(input => t."alternate_bases") f,
    LATERAL FLATTEN(input => f.value:"vep") v
    WHERE t."start_position" BETWEEN 55039447 AND 55064852
      AND v.value:"SYMBOL" IS NOT NULL
  ) gene_list;