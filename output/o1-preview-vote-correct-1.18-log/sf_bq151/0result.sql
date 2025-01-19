SELECT
  SUM(CASE WHEN KRAS_Mutated = 1 AND TP53_Mutated = 1 THEN 1 ELSE 0 END) AS "Both_Mutated",
  SUM(CASE WHEN KRAS_Mutated = 0 AND TP53_Mutated = 1 THEN 1 ELSE 0 END) AS "Only_TP53_Mutated",
  SUM(CASE WHEN KRAS_Mutated = 1 AND TP53_Mutated = 0 THEN 1 ELSE 0 END) AS "Only_KRAS_Mutated",
  SUM(CASE WHEN KRAS_Mutated = 0 AND TP53_Mutated = 0 THEN 1 ELSE 0 END) AS "Neither_Mutated"
FROM (
  SELECT
    c."bcr_patient_barcode" AS "ParticipantBarcode",
    MAX(CASE WHEN m."Hugo_Symbol" = 'KRAS' THEN 1 ELSE 0 END) AS KRAS_Mutated,
    MAX(CASE WHEN m."Hugo_Symbol" = 'TP53' THEN 1 ELSE 0 END) AS TP53_Mutated
  FROM
    PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP" c
  LEFT JOIN
    PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
  ON
    c."bcr_patient_barcode" = m."ParticipantBarcode"
    AND m."Hugo_Symbol" IN ('KRAS', 'TP53')
    AND m."FILTER" = 'PASS'
    AND m."Study" = 'PAAD'
  WHERE
    c."acronym" = 'PAAD'
  GROUP BY
    c."bcr_patient_barcode"
) sub;