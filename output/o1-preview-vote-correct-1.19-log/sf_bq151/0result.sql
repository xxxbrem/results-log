SELECT
    CASE WHEN KRAS_Mutated = 1 THEN 'Yes' ELSE 'No' END AS "KRAS_mutated",
    CASE WHEN TP53_Mutated = 1 THEN 'Yes' ELSE 'No' END AS "TP53_mutated",
    COUNT(*) AS "Count"
FROM (
    SELECT
        "ParticipantBarcode",
        MAX(CASE WHEN "Hugo_Symbol" = 'KRAS' THEN 1 ELSE 0 END) AS KRAS_Mutated,
        MAX(CASE WHEN "Hugo_Symbol" = 'TP53' THEN 1 ELSE 0 END) AS TP53_Mutated
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "FILTER" = 'PASS'
    GROUP BY "ParticipantBarcode"
) AS Mutations
GROUP BY
    KRAS_Mutated,
    TP53_Mutated
ORDER BY
    KRAS_Mutated DESC NULLS LAST,
    TP53_Mutated DESC NULLS LAST;