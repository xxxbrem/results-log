WITH paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode" AS patient_barcode
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),
mutations AS (
    SELECT DISTINCT "ParticipantBarcode" AS patient_barcode, "Hugo_Symbol"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "FILTER" = 'PASS' AND "Hugo_Symbol" IN ('KRAS', 'TP53')
),
patient_mutations AS (
    SELECT p.patient_barcode,
        MAX(CASE WHEN m."Hugo_Symbol" = 'KRAS' THEN 1 ELSE 0 END) AS has_KRAS_mutation,
        MAX(CASE WHEN m."Hugo_Symbol" = 'TP53' THEN 1 ELSE 0 END) AS has_TP53_mutation
    FROM paad_patients p
    LEFT JOIN mutations m ON p.patient_barcode = m.patient_barcode
    GROUP BY p.patient_barcode
),
counts AS (
    SELECT
        SUM(CASE WHEN has_KRAS_mutation = 1 AND has_TP53_mutation = 1 THEN 1 ELSE 0 END) AS "PatientsWithBothMutations",
        SUM(CASE WHEN has_KRAS_mutation = 0 AND has_TP53_mutation = 0 THEN 1 ELSE 0 END) AS "PatientsWithNeitherMutation"
    FROM patient_mutations
)
SELECT
    "PatientsWithBothMutations",
    "PatientsWithNeitherMutation",
    "PatientsWithBothMutations" - "PatientsWithNeitherMutation" AS "NetDifference"
FROM counts;