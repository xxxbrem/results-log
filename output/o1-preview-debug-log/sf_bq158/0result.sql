SELECT
  c."histological_type",
  ROUND((COUNT(DISTINCT m."ParticipantBarcode") * 100.0) / COUNT(DISTINCT c."bcr_patient_barcode"), 4) AS "Percentage of CDH1 Mutations"
FROM
  PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED.CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED AS c
LEFT JOIN
  (SELECT DISTINCT "ParticipantBarcode"
   FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED.MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
   WHERE "Hugo_Symbol" = 'CDH1' AND "Study" = 'BRCA') AS m
ON
  c."bcr_patient_barcode" = m."ParticipantBarcode"
WHERE
  c."acronym" = 'BRCA'
GROUP BY
  c."histological_type"
ORDER BY
  "Percentage of CDH1 Mutations" DESC NULLS LAST
LIMIT 5;