SELECT cns."case_barcode",
       ROUND(
         SUM(
           (LEAST(cns."end_pos", cb."hg38_stop") - GREATEST(cns."start_pos", cb."hg38_start") + 1) * cns."segment_mean"
         ) /
         NULLIF(
           SUM(
             LEAST(cns."end_pos", cb."hg38_stop") - GREATEST(cns."start_pos", cb."hg38_start") + 1
           ), 0
         ),
         4
       ) AS "WeightedAverageCopyNumber"
FROM "TCGA_MITELMAN"."TCGA_VERSIONED"."COPY_NUMBER_SEGMENT_MASKED_HG38_GDC_2017_02" AS cns
JOIN "TCGA_MITELMAN"."PROD"."CYTOBANDS_HG38" AS cb
  ON 'chr' || cns."chromosome" = cb."chromosome"
  AND cns."start_pos" <= cb."hg38_stop"
  AND cns."end_pos" >= cb."hg38_start"
WHERE cns."project_short_name" = 'TCGA-LAML'
  AND cns."chromosome" = '15'
  AND cb."cytoband_name" LIKE '15q11%'
GROUP BY cns."case_barcode"
ORDER BY "WeightedAverageCopyNumber" DESC NULLS LAST
LIMIT 1;