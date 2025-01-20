WITH paad_patients AS (
  SELECT DISTINCT c.`bcr_patient_barcode` AS PatientBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup` AS c
  WHERE c.`acronym` = 'PAAD'
),
kras_patients AS (
  SELECT DISTINCT m.`ParticipantBarcode`
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample` AS m
  WHERE m.`FILTER` = 'PASS'
    AND m.`Hugo_Symbol` = 'KRAS'
    AND m.`ParticipantBarcode` IN (SELECT PatientBarcode FROM paad_patients)
),
tp53_patients AS (
  SELECT DISTINCT m.`ParticipantBarcode`
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample` AS m
  WHERE m.`FILTER` = 'PASS'
    AND m.`Hugo_Symbol` = 'TP53'
    AND m.`ParticipantBarcode` IN (SELECT PatientBarcode FROM paad_patients)
),
mutation_status AS (
  SELECT p.PatientBarcode,
    CASE WHEN k.`ParticipantBarcode` IS NOT NULL THEN 'Mutated' ELSE 'Not_Mutated' END AS KRAS_mutation_status,
    CASE WHEN t.`ParticipantBarcode` IS NOT NULL THEN 'Mutated' ELSE 'Not_Mutated' END AS TP53_mutation_status
  FROM paad_patients AS p
  LEFT JOIN kras_patients AS k ON p.PatientBarcode = k.ParticipantBarcode
  LEFT JOIN tp53_patients AS t ON p.PatientBarcode = t.ParticipantBarcode
),
mutation_counts AS (
  SELECT KRAS_mutation_status, TP53_mutation_status, COUNT(*) AS Number_of_patients
  FROM mutation_status
  GROUP BY KRAS_mutation_status, TP53_mutation_status
)
SELECT KRAS_mutation_status, TP53_mutation_status, Number_of_patients
FROM mutation_counts
ORDER BY KRAS_mutation_status DESC, TP53_mutation_status DESC