WITH paad_patients AS (
  SELECT DISTINCT "bcr_patient_barcode" AS "PatientBarcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
  WHERE "acronym" = 'PAAD'
),
valid_patients AS (
  SELECT DISTINCT "patient_barcode" AS "PatientBarcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.MERGED_SAMPLE_QUALITY_ANNOTATIONS
  WHERE ("Do_not_use" != 'Yes' OR "Do_not_use" IS NULL)
),
paad_valid_patients AS (
  SELECT p."PatientBarcode"
  FROM paad_patients p
  JOIN valid_patients v ON p."PatientBarcode" = v."PatientBarcode"
),
mutation_data AS (
  SELECT DISTINCT "ParticipantBarcode" AS "PatientBarcode", "Hugo_Symbol"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
  WHERE "Study" = 'PAAD'
    AND "FILTER" = 'PASS'
    AND "Hugo_Symbol" IN ('KRAS', 'TP53')
),
mutations_per_patient AS (
  SELECT pvp."PatientBarcode",
    MAX(CASE WHEN md."Hugo_Symbol" = 'KRAS' THEN 1 ELSE 0 END) AS KRAS_mut,
    MAX(CASE WHEN md."Hugo_Symbol" = 'TP53' THEN 1 ELSE 0 END) AS TP53_mut
  FROM paad_valid_patients pvp
  LEFT JOIN mutation_data md ON pvp."PatientBarcode" = md."PatientBarcode"
  GROUP BY pvp."PatientBarcode"
),
contingency_table AS (
  SELECT
    KRAS_mut, TP53_mut, COUNT(*) AS observed
  FROM mutations_per_patient
  GROUP BY KRAS_mut, TP53_mut
),
totals AS (
  SELECT
    SUM(observed) AS N,
    SUM(CASE WHEN KRAS_mut = 1 THEN observed ELSE 0 END) AS total_KRAS_yes,
    SUM(CASE WHEN KRAS_mut = 0 THEN observed ELSE 0 END) AS total_KRAS_no,
    SUM(CASE WHEN TP53_mut = 1 THEN observed ELSE 0 END) AS total_TP53_yes,
    SUM(CASE WHEN TP53_mut = 0 THEN observed ELSE 0 END) AS total_TP53_no
  FROM contingency_table
),
expected_counts AS (
  SELECT
    ct.*,
    ( (CASE WHEN ct.KRAS_mut = 1 THEN t.total_KRAS_yes ELSE t.total_KRAS_no END)
      * (CASE WHEN ct.TP53_mut = 1 THEN t.total_TP53_yes ELSE t.total_TP53_no END)
    ) / t.N AS expected
  FROM contingency_table ct CROSS JOIN totals t
),
chi_squared AS (
  SELECT
    SUM(
      CASE WHEN expected > 0 THEN
        POWER(observed - expected, 2) / expected
      ELSE 0 END
    ) AS chi_value
  FROM expected_counts
)

SELECT ROUND(chi_value, 4) AS chi_value
FROM chi_squared;