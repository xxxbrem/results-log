SELECT
  KRAS_mutation_status,
  TP53_mutation_status,
  COUNT(*) AS Number_of_patients
FROM (
  SELECT
    clin.bcr_patient_barcode AS Patient,
    CASE WHEN kras.Patient IS NOT NULL THEN 'Mutated' ELSE 'Not_Mutated' END AS KRAS_mutation_status,
    CASE WHEN tp53.Patient IS NOT NULL THEN 'Mutated' ELSE 'Not_Mutated' END AS TP53_mutation_status
  FROM (
    SELECT DISTINCT bcr_patient_barcode
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup`
    WHERE acronym = 'PAAD'
  ) AS clin
  LEFT JOIN (
    SELECT DISTINCT SUBSTR(ParticipantBarcode, 1, 12) AS Patient
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
    WHERE
      Study = 'PAAD' AND
      Hugo_Symbol = 'KRAS' AND
      Variant_Classification NOT IN ('Silent')
  ) AS kras
    ON clin.bcr_patient_barcode = kras.Patient
  LEFT JOIN (
    SELECT DISTINCT SUBSTR(ParticipantBarcode, 1, 12) AS Patient
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
    WHERE
      Study = 'PAAD' AND
      Hugo_Symbol = 'TP53' AND
      Variant_Classification NOT IN ('Silent')
  ) AS tp53
    ON clin.bcr_patient_barcode = tp53.Patient
)
GROUP BY KRAS_mutation_status, TP53_mutation_status
ORDER BY KRAS_mutation_status DESC, TP53_mutation_status DESC