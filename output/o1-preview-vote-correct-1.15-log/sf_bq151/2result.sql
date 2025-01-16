WITH whitelist AS (
  SELECT DISTINCT "ParticipantBarcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."WHITELIST_PARTICIPANTBARCODES"
),
paad_patients AS (
  SELECT DISTINCT clinical."bcr_patient_barcode" AS "ParticipantBarcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP" AS clinical
  INNER JOIN whitelist ON clinical."bcr_patient_barcode" = whitelist."ParticipantBarcode"
  WHERE clinical."acronym" = 'PAAD'
),
kras_mutations AS (
  SELECT DISTINCT "ParticipantBarcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE"
  WHERE "Hugo_Symbol" = 'KRAS' AND "Study" = 'PAAD'
),
tp53_mutations AS (
  SELECT DISTINCT "ParticipantBarcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE"
  WHERE "Hugo_Symbol" = 'TP53' AND "Study" = 'PAAD'
)
SELECT
  CASE WHEN k."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END AS "KRAS_mutation_status",
  CASE WHEN t."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END AS "TP53_mutation_status",
  COUNT(*) AS "patient_count"
FROM paad_patients p
LEFT JOIN kras_mutations k ON p."ParticipantBarcode" = k."ParticipantBarcode"
LEFT JOIN tp53_mutations t ON p."ParticipantBarcode" = t."ParticipantBarcode"
GROUP BY
  CASE WHEN k."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END,
  CASE WHEN t."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END
ORDER BY
  "KRAS_mutation_status" DESC,
  "TP53_mutation_status" DESC;