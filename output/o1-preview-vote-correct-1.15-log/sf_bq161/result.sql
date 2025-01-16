WITH
    KRAS_patients AS (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE"
        WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS'
    ),
    TP53_patients AS (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE"
        WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS'
    ),
    Patients_with_KRAS_and_TP53 AS (
        SELECT kp."ParticipantBarcode"
        FROM KRAS_patients kp
        INNER JOIN TP53_patients tp ON kp."ParticipantBarcode" = tp."ParticipantBarcode"
    ),
    all_PAAD_patients AS (
        SELECT DISTINCT "bcr_patient_barcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP"
        WHERE "acronym" = 'PAAD'
    ),
    patients_with_KRAS_or_TP53 AS (
        SELECT DISTINCT "ParticipantBarcode"
        FROM KRAS_patients
        UNION
        SELECT DISTINCT "ParticipantBarcode"
        FROM TP53_patients
    ),
    Patients_without_KRAS_or_TP53 AS (
        SELECT "bcr_patient_barcode"
        FROM all_PAAD_patients
        WHERE "bcr_patient_barcode" NOT IN (SELECT "ParticipantBarcode" FROM patients_with_KRAS_or_TP53)
    )
SELECT
    (SELECT COUNT(*) FROM Patients_with_KRAS_and_TP53) -
    (SELECT COUNT(*) FROM Patients_without_KRAS_or_TP53) AS "Net_Difference";