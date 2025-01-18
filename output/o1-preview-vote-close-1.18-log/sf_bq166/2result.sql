SELECT
    'chr' || Chromosome AS Chromosome,
    Cytoband,
    COUNT(CASE WHEN max_segment_mean > 0.9 THEN 1 END) AS Amplification,
    COUNT(CASE WHEN max_segment_mean BETWEEN 0.2 AND 0.9 THEN 1 END) AS Gain,
    COUNT(CASE WHEN max_segment_mean < -0.9 THEN 1 END) AS Homozygous_Deletion,
    COUNT(CASE WHEN max_segment_mean BETWEEN -0.9 AND -0.2 THEN 1 END) AS Heterozygous_Deletion,
    COUNT(CASE WHEN max_segment_mean BETWEEN -0.2 AND 0.2 THEN 1 END) AS Normal
FROM
(
    SELECT
        s."chromosome" AS Chromosome,
        c."cytoband_name" AS Cytoband,
        MAX(s."segment_mean") AS max_segment_mean
    FROM
        "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_MASKED_HG38_GDC_R14" s
    JOIN
        "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38" c
    ON
        s."chromosome" = SUBSTRING(c."chromosome", 4)
        AND s."start_pos" <= c."hg38_stop"
        AND s."end_pos" >= c."hg38_start"
    WHERE
        s."project_short_name" = 'TCGA-KIRC'
    GROUP BY
        s."chromosome",
        c."cytoband_name",
        s."start_pos",
        s."end_pos"
) AS sub
GROUP BY
    Chromosome, Cytoband
ORDER BY
    Chromosome, Cytoband;