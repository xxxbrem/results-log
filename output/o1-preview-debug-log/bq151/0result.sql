WITH paad_patients AS (
  SELECT DISTINCT bcr_patient_barcode AS ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup`
  WHERE acronym = 'PAAD'
),
kras_mutations AS (
  SELECT DISTINCT ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
  WHERE Hugo_Symbol = 'KRAS' AND Study = 'PAAD' AND FILTER = 'PASS'
),
tp53_mutations AS (
  SELECT DISTINCT ParticipantBarcode
  FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
  WHERE Hugo_Symbol = 'TP53' AND Study = 'PAAD' AND FILTER = 'PASS'
),
patient_mutation_status AS (
  SELECT
    paad.ParticipantBarcode,
    IF(kras.ParticipantBarcode IS NOT NULL, 1, 0) AS KRAS_Mutated,
    IF(tp53.ParticipantBarcode IS NOT NULL, 1, 0) AS TP53_Mutated
  FROM
    paad_patients paad
    LEFT JOIN kras_mutations kras ON paad.ParticipantBarcode = kras.ParticipantBarcode
    LEFT JOIN tp53_mutations tp53 ON paad.ParticipantBarcode = tp53.ParticipantBarcode
),
counts AS (
  SELECT
    SUM(CASE WHEN KRAS_Mutated=1 AND TP53_Mutated=1 THEN 1 ELSE 0 END) AS n11,
    SUM(CASE WHEN KRAS_Mutated=1 AND TP53_Mutated=0 THEN 1 ELSE 0 END) AS n12,
    SUM(CASE WHEN KRAS_Mutated=0 AND TP53_Mutated=1 THEN 1 ELSE 0 END) AS n21,
    SUM(CASE WHEN KRAS_Mutated=0 AND TP53_Mutated=0 THEN 1 ELSE 0 END) AS n22
  FROM patient_mutation_status
),
chi_sq AS (
  SELECT
    *,
    (n11 + n12) AS Row_Total1,
    (n21 + n22) AS Row_Total2,
    (n11 + n21) AS Col_Total1,
    (n12 + n22) AS Col_Total2,
    (n11 + n12 + n21 + n22) AS N
  FROM counts
),
expected AS (
  SELECT
    chi_sq.*,
    (Row_Total1 * Col_Total1) / N AS e11,
    (Row_Total1 * Col_Total2) / N AS e12,
    (Row_Total2 * Col_Total1) / N AS e21,
    (Row_Total2 * Col_Total2) / N AS e22
  FROM chi_sq
),
chi_statistic AS (
  SELECT
    ROUND(
      ((n11 - e11)*(n11 - e11)/e11) +
      ((n12 - e12)*(n12 - e12)/e12) +
      ((n21 - e21)*(n21 - e21)/e21) +
      ((n22 - e22)*(n22 - e22)/e22),
      4
    ) AS ChiSquaredStatistic
  FROM expected
)
SELECT ChiSquaredStatistic
FROM chi_statistic