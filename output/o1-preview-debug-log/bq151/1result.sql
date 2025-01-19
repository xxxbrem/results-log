WITH paad_patients AS (
    SELECT DISTINCT bcr_patient_barcode AS ParticipantBarcode
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup`
    WHERE acronym = 'PAAD'
),
kras_mutations AS (
    SELECT DISTINCT ParticipantBarcode
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
    WHERE Study = 'PAAD' AND Hugo_Symbol = 'KRAS' AND Variant_Classification NOT IN ('Silent', 'Intron', 'RNA')
),
tp53_mutations AS (
    SELECT DISTINCT ParticipantBarcode
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
    WHERE Study = 'PAAD' AND Hugo_Symbol = 'TP53' AND Variant_Classification NOT IN ('Silent', 'Intron', 'RNA')
),
patient_mutations AS (
    SELECT 
        p.ParticipantBarcode,
        IF(k.ParticipantBarcode IS NOT NULL, 1, 0) AS KRAS_mutated,
        IF(t.ParticipantBarcode IS NOT NULL, 1, 0) AS TP53_mutated
    FROM paad_patients p
    LEFT JOIN kras_mutations k ON p.ParticipantBarcode = k.ParticipantBarcode
    LEFT JOIN tp53_mutations t ON p.ParticipantBarcode = t.ParticipantBarcode
),
counts AS (
    SELECT
        SUM(CASE WHEN KRAS_mutated = 1 AND TP53_mutated = 1 THEN 1 ELSE 0 END) AS n11,
        SUM(CASE WHEN KRAS_mutated = 1 AND TP53_mutated = 0 THEN 1 ELSE 0 END) AS n12,
        SUM(CASE WHEN KRAS_mutated = 0 AND TP53_mutated = 1 THEN 1 ELSE 0 END) AS n21,
        SUM(CASE WHEN KRAS_mutated = 0 AND TP53_mutated = 0 THEN 1 ELSE 0 END) AS n22,
        COUNT(*) AS total_patients
    FROM patient_mutations
),
chi2 AS (
    SELECT
        n11, n12, n21, n22, total_patients,
        (n11 + n12) AS row1_total,
        (n21 + n22) AS row2_total,
        (n11 + n21) AS col1_total,
        (n12 + n22) AS col2_total
    FROM counts
),
expected AS (
    SELECT
        chi2.*,
        (row1_total * col1_total) / total_patients AS e11,
        (row1_total * col2_total) / total_patients AS e12,
        (row2_total * col1_total) / total_patients AS e21,
        (row2_total * col2_total) / total_patients AS e22
    FROM chi2
),
chi_squared_statistic AS (
    SELECT
        ((n11 - e11)*(n11 - e11)) / e11 +
        ((n12 - e12)*(n12 - e12)) / e12 +
        ((n21 - e21)*(n21 - e21)) / e21 +
        ((n22 - e22)*(n22 - e22)) / e22 AS ChiSquaredStatistic
    FROM expected
)
SELECT ROUND(ChiSquaredStatistic, 4) AS ChiSquaredStatistic
FROM chi_squared_statistic;