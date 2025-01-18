WITH cnv_kirc AS (
    SELECT 
        "sample_barcode",
        "chromosome",
        "start_pos",
        "end_pos",
        "copy_number"
    FROM 
        TCGA_MITELMAN.TCGA_VERSIONED."COPY_NUMBER_SEGMENT_ALLELIC_HG38_GDC_R23"
    WHERE
        "project_short_name" = 'TCGA-KIRC'
),
cnv_banded AS (
    SELECT DISTINCT
        cnv."sample_barcode",
        cb."chromosome",
        cb."cytoband_name",
        cnv."copy_number"
    FROM
        cnv_kirc cnv
    JOIN
        TCGA_MITELMAN.PROD."CYTOBANDS_HG38" cb
    ON
        cnv."chromosome" = cb."chromosome" AND
        cnv."start_pos" <= cb."hg38_stop" AND
        cnv."end_pos" >= cb."hg38_start"
),
max_copy_number_per_sample_cytoband AS (
    SELECT
        "sample_barcode",
        "chromosome",
        "cytoband_name",
        MAX("copy_number") AS "max_copy_number"
    FROM
        cnv_banded
    GROUP BY
        "sample_barcode",
        "chromosome",
        "cytoband_name"
),
categorized_counts AS (
    SELECT
        "chromosome",
        "cytoband_name",
        COUNT(DISTINCT CASE WHEN "max_copy_number" > 3 THEN "sample_barcode" END) AS "Amplifications",
        COUNT(DISTINCT CASE WHEN "max_copy_number" = 3 THEN "sample_barcode" END) AS "Gains",
        COUNT(DISTINCT CASE WHEN "max_copy_number" = 0 THEN "sample_barcode" END) AS "Homozygous_Del",
        COUNT(DISTINCT CASE WHEN "max_copy_number" = 1 THEN "sample_barcode" END) AS "Heterozygous_Del",
        COUNT(DISTINCT CASE WHEN "max_copy_number" = 2 THEN "sample_barcode" END) AS "Normal_Diploid"
    FROM
        max_copy_number_per_sample_cytoband
    GROUP BY
        "chromosome",
        "cytoband_name"
)
SELECT
    "chromosome" AS "Chromosome",
    "cytoband_name" AS "Cytoband",
    "Amplifications",
    "Gains",
    "Homozygous_Del",
    "Heterozygous_Del",
    "Normal_Diploid"
FROM
    categorized_counts
ORDER BY
    "chromosome",
    "cytoband_name";