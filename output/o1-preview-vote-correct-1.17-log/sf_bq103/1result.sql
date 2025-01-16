WITH variants_in_region AS (
    SELECT
        t."AN",
        t."alternate_bases",
        t."start_position",
        t."end_position",
        t."reference_bases"
    FROM
        GNOMAD.GNOMAD.V3_GENOMES__CHR1 t
    WHERE
        t."start_position" >= 55039447 AND t."end_position" <= 55064852
),
allele_counts AS (
    SELECT
        v."AN",
        f.value:"AC"::INT AS "AC",
        v."start_position",
        v."reference_bases",
        f.value:"alt"::STRING AS "alternate_base",
        f.value:"vep" AS "vep_annotations"
    FROM
        variants_in_region v,
        LATERAL FLATTEN(input => v."alternate_bases") f
),
unique_variants AS (
    SELECT
        "start_position",
        "reference_bases",
        "alternate_base",
        "AC",
        "AN",
        "vep_annotations",
        "start_position" || '_' || "reference_bases" || '_' || "alternate_base" AS v_id
    FROM
        allele_counts
),
total_counts AS (
    SELECT
        COUNT(DISTINCT v_id) AS "number_of_variants",
        SUM("AC") AS "total_allele_count",
        SUM("AN") AS "total_number_of_alleles"
    FROM
        unique_variants
),
gene_symbols AS (
    SELECT DISTINCT
        vep.value:"SYMBOL"::STRING AS "gene_symbol"
    FROM
        allele_counts,
        LATERAL FLATTEN(input => allele_counts."vep_annotations") AS vep
    WHERE
        vep.value:"SYMBOL" IS NOT NULL
)
SELECT
    total_counts."number_of_variants",
    total_counts."total_allele_count",
    total_counts."total_number_of_alleles",
    '[' || (SELECT LISTAGG(DISTINCT "gene_symbol", ', ') FROM gene_symbols) || ']' AS "distinct_gene_symbols",
    ROUND(((55064852 - 55039447 + 1)::FLOAT / total_counts."number_of_variants"), 4) AS "density_of_mutations"
FROM
    total_counts;