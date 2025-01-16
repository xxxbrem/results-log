WITH paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode" AS "patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),
filtered_paad_patients AS (
    SELECT p."patient_barcode"
    FROM paad_patients p
    LEFT JOIN PANCANCER_ATLAS_2.PANCANCER_ATLAS.MERGED_SAMPLE_QUALITY_ANNOTATIONS mq
        ON p."patient_barcode" = mq."patient_barcode"
    GROUP BY p."patient_barcode"
    HAVING SUM(CASE WHEN mq."Do_not_use" = 'TRUE' THEN 1 ELSE 0 END) = 0
),
patients_with_kras_mutation AS (
    SELECT DISTINCT "ParticipantBarcode" AS "patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS'
),
patients_with_tp53_mutation AS (
    SELECT DISTINCT "ParticipantBarcode" AS "patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53'
),
mutations AS (
    SELECT
        p."patient_barcode",
        CASE WHEN k."patient_barcode" IS NOT NULL THEN 1 ELSE 0 END AS "KRAS_mut",
        CASE WHEN t."patient_barcode" IS NOT NULL THEN 1 ELSE 0 END AS "TP53_mut"
    FROM filtered_paad_patients p
    LEFT JOIN patients_with_kras_mutation k ON p."patient_barcode" = k."patient_barcode"
    LEFT JOIN patients_with_tp53_mutation t ON p."patient_barcode" = t."patient_barcode"
),
counts AS (
    SELECT
        SUM(CASE WHEN "KRAS_mut" = 1 AND "TP53_mut" = 1 THEN 1 ELSE 0 END) AS a,
        SUM(CASE WHEN "KRAS_mut" = 1 AND "TP53_mut" = 0 THEN 1 ELSE 0 END) AS b,
        SUM(CASE WHEN "KRAS_mut" = 0 AND "TP53_mut" = 1 THEN 1 ELSE 0 END) AS c,
        SUM(CASE WHEN "KRAS_mut" = 0 AND "TP53_mut" = 0 THEN 1 ELSE 0 END) AS d,
        COUNT(*) AS n
    FROM mutations
)
SELECT
    ROUND( ( (a * d - b * c) * (a * d - b * c) * n ) / ( (a + b) * (c + d) * (a + c) * (b + d) ), 4 ) AS "Chi_Squared_Statistic"
FROM counts;