WITH paad_patients AS (
  SELECT DISTINCT "bcr_patient_barcode" AS patient_id
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
  WHERE "acronym" = 'PAAD'
),
kras_patients AS (
  SELECT DISTINCT "ParticipantBarcode" AS patient_id
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
  WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS'
),
tp53_patients AS (
  SELECT DISTINCT "ParticipantBarcode" AS patient_id
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
  WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS'
),
patients_with_both AS (
  SELECT k.patient_id
  FROM kras_patients k
  INNER JOIN tp53_patients t ON k.patient_id = t.patient_id
),
patients_with_either AS (
  SELECT patient_id FROM kras_patients
  UNION
  SELECT patient_id FROM tp53_patients
),
patients_with_neither AS (
  SELECT patient_id
  FROM paad_patients
  WHERE patient_id NOT IN (SELECT patient_id FROM patients_with_either)
),
num_with_both AS (
  SELECT COUNT(*) AS count_with_both FROM patients_with_both
),
num_with_neither AS (
  SELECT COUNT(*) AS count_with_neither FROM patients_with_neither
)
SELECT (nwb.count_with_both - nwn.count_with_neither) AS Net_Difference
FROM num_with_both nwb, num_with_neither nwn;