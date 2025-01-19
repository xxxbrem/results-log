WITH
Patients_with_KRAS_and_TP53 AS (
    SELECT "ParticipantBarcode"
    FROM (
        SELECT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Study" = 'PAAD' AND "FILTER" = 'PASS' AND "Hugo_Symbol" = 'KRAS'
    ) AS KRAS_Patients
    INNER JOIN (
        SELECT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Study" = 'PAAD' AND "FILTER" = 'PASS' AND "Hugo_Symbol" = 'TP53'
    ) AS TP53_Patients USING ("ParticipantBarcode")
),
Patients_with_KRAS_or_TP53 AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" IN ('KRAS', 'TP53') AND "FILTER" = 'PASS'
),
Total_patients_with_mutations AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "FILTER" = 'PASS'
),
Patients_with_neither_KRAS_nor_TP53 AS (
    SELECT "ParticipantBarcode"
    FROM Total_patients_with_mutations
    WHERE "ParticipantBarcode" NOT IN (SELECT "ParticipantBarcode" FROM Patients_with_KRAS_or_TP53)
)
SELECT
    (
        (SELECT COUNT(*) FROM Patients_with_KRAS_and_TP53)
        -
        (SELECT COUNT(*) FROM Patients_with_neither_KRAS_nor_TP53)
    ) AS "Net_Difference";