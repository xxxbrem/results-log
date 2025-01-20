WITH patients_with_both AS (
    SELECT ParticipantBarcode
    FROM (
        SELECT DISTINCT ParticipantBarcode
        FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
        WHERE Study = 'PAAD' AND Hugo_Symbol = 'KRAS' AND FILTER = 'PASS'
    ) AS KRAS_patients
    INNER JOIN (
        SELECT DISTINCT ParticipantBarcode
        FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
        WHERE Study = 'PAAD' AND Hugo_Symbol = 'TP53' AND FILTER = 'PASS'
    ) AS TP53_patients
    USING (ParticipantBarcode)
),
patients_without_either AS (
    SELECT DISTINCT bcr_patient_barcode AS ParticipantBarcode
    FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup`
    WHERE acronym = 'PAAD' AND bcr_patient_barcode NOT IN (
        SELECT DISTINCT ParticipantBarcode
        FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample`
        WHERE Study = 'PAAD' AND FILTER = 'PASS' AND Hugo_Symbol IN ('KRAS', 'TP53')
    )
)
SELECT
   (SELECT COUNT(*) FROM patients_with_both) - (SELECT COUNT(*) FROM patients_without_either) AS NetDifference