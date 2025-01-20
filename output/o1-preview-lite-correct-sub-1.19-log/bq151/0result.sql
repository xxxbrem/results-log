WITH paad_patients AS (
  SELECT DISTINCT bcr_patient_barcode AS ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup`
  WHERE acronym = 'PAAD'
),
kras_mutations AS (
  SELECT DISTINCT ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
  WHERE Study = 'PAAD' AND Hugo_Symbol = 'KRAS' AND FILTER = 'PASS'
),
tp53_mutations AS (
  SELECT DISTINCT ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
  WHERE Study = 'PAAD' AND Hugo_Symbol = 'TP53' AND FILTER = 'PASS'
)
SELECT
  CASE WHEN k.ParticipantBarcode IS NOT NULL THEN 'Mutated' ELSE 'Not_Mutated' END AS KRAS_mutation_status,
  CASE WHEN t.ParticipantBarcode IS NOT NULL THEN 'Mutated' ELSE 'Not_Mutated' END AS TP53_mutation_status,
  COUNT(DISTINCT p.ParticipantBarcode) AS Number_of_patients
FROM paad_patients p
LEFT JOIN kras_mutations k ON p.ParticipantBarcode = k.ParticipantBarcode
LEFT JOIN tp53_mutations t ON p.ParticipantBarcode = t.ParticipantBarcode
GROUP BY KRAS_mutation_status, TP53_mutation_status
ORDER BY KRAS_mutation_status DESC, TP53_mutation_status DESC;