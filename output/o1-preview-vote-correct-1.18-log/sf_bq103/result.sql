WITH variants AS (
    SELECT *
    FROM "GNOMAD"."GNOMAD"."V3_GENOMES__CHR1"
    WHERE "start_position" BETWEEN 55039447 AND 55064852
),
variant_counts AS (
    SELECT
        COUNT(*) AS "Number_of_variants",
        SUM("AN") AS "Total_number_of_alleles"
    FROM variants
),
allele_counts AS (
    SELECT
        SUM(TRY_CAST(ab.value:"AC"::STRING AS INT)) AS "Total_allele_count"
    FROM variants v, LATERAL FLATTEN(input => v."alternate_bases") ab
)
SELECT
    vc."Number_of_variants",
    ac."Total_allele_count",
    vc."Total_number_of_alleles",
    ROUND(((55064852 - 55039447 + 1) / vc."Number_of_variants")::FLOAT, 4) AS "Density_of_mutations",
    (
        SELECT LISTAGG(DISTINCT vep_item.value:"SYMBOL"::STRING, ';') WITHIN GROUP (ORDER BY vep_item.value:"SYMBOL"::STRING)
        FROM variants v,
             LATERAL FLATTEN(input => v."alternate_bases") ab,
             LATERAL FLATTEN(input => ab.value:"vep") vep_item
        WHERE vep_item.value:"SYMBOL"::STRING IS NOT NULL AND vep_item.value:"SYMBOL"::STRING != ''
    ) AS "Distinct_gene_symbols"
FROM
    variant_counts vc,
    allele_counts ac;