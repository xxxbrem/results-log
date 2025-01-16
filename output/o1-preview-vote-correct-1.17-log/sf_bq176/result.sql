SELECT
    "case_barcode",
    ROUND(SUM("overlap_length" * "segment_mean") / SUM("overlap_length"), 4) AS weighted_avg_copy_number
FROM (
    SELECT
        t."case_barcode",
        t."segment_mean",
        LEAST(t."end_pos", c."hg38_stop") - GREATEST(t."start_pos", c."hg38_start") AS "overlap_length"
    FROM
        TCGA_MITELMAN.TCGA_VERSIONED."COPY_NUMBER_SEGMENT_MASKED_HG38_GDC_2017_02" t
    JOIN
        TCGA_MITELMAN.PROD."CYTOBANDS_HG38" c
            ON t."chromosome" = REPLACE(c."chromosome", 'chr', '') AND c."cytoband_name" = '15q11'
    WHERE
        t."project_short_name" = 'TCGA-LAML' AND
        t."chromosome" = '15' AND
        t."start_pos" <= c."hg38_stop" AND
        t."end_pos" >= c."hg38_start"
) AS sub
GROUP BY
    "case_barcode"
ORDER BY
    weighted_avg_copy_number DESC NULLS LAST
LIMIT 1;