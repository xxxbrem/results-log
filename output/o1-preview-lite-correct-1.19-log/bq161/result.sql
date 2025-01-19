WITH paad_patients AS (
  SELECT DISTINCT bcr_patient_barcode AS PatientBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup`
  WHERE acronym = 'PAAD'
),
patients_with_kras_mutation AS (
  SELECT DISTINCT ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
  WHERE Study = 'PAAD' AND Hugo_Symbol = 'KRAS' AND FILTER = 'PASS'
),
patients_with_tp53_mutation AS (
  SELECT DISTINCT ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
  WHERE Study = 'PAAD' AND Hugo_Symbol = 'TP53' AND FILTER = 'PASS'
),
patients_with_both_mutations AS (
  SELECT ParticipantBarcode
  FROM patients_with_kras_mutation
  INNER JOIN patients_with_tp53_mutation USING (ParticipantBarcode)
),
patients_with_no_kras_or_tp53_mutations AS (
  SELECT PatientBarcode
  FROM paad_patients
  WHERE PatientBarcode NOT IN (SELECT ParticipantBarcode FROM patients_with_kras_mutation)
    AND PatientBarcode NOT IN (SELECT ParticipantBarcode FROM patients_with_tp53_mutation)
)
SELECT 
  (SELECT COUNT(DISTINCT ParticipantBarcode) FROM patients_with_both_mutations) -
  (SELECT COUNT(DISTINCT PatientBarcode) FROM patients_with_no_kras_or_tp53_mutations)
  AS net_difference;