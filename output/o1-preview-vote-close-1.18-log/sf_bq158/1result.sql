SELECT c."histological_type",
       ROUND((COUNT(DISTINCT m."ParticipantBarcode")::float / COUNT(DISTINCT c."bcr_patient_barcode")::float) * 100, 4) AS "Percentage_CDH1_Mutations"
FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED" c
LEFT JOIN PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
  ON c."bcr_patient_barcode" = m."ParticipantBarcode"
     AND m."Hugo_Symbol" = 'CDH1'
     AND m."Study" = 'BRCA'
WHERE c."acronym" = 'BRCA'
  AND c."histological_type" IS NOT NULL
GROUP BY c."histological_type"
ORDER BY "Percentage_CDH1_Mutations" DESC NULLS LAST
LIMIT 5;