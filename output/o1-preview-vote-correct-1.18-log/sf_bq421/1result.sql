WITH embedding AS (
    SELECT DISTINCT
        t."SOPInstanceUID",
        ci.value:"ConceptCodeSequence"[0]:"CodeMeaning"::STRING AS embedding_medium_code_meaning
    FROM
        IDC.IDC_V17.DICOM_METADATA t
        , LATERAL FLATTEN(input => t."SpecimenDescriptionSequence") sds
        , LATERAL FLATTEN(input => sds.value:"SpecimenPreparationSequence") sps
        , LATERAL FLATTEN(input => sps.value:"SpecimenPreparationStepContentItemSequence") ci
    WHERE
        t."Modality" = 'SM'
        AND ci.value:"ConceptNameCodeSequence"[0]:"CodeMeaning"::STRING = 'Embedding medium'
),
staining AS (
    SELECT DISTINCT
        t."SOPInstanceUID",
        ci.value:"ConceptCodeSequence"[0]:"CodeMeaning"::STRING AS staining_substance_code_meaning
    FROM
        IDC.IDC_V17.DICOM_METADATA t
        , LATERAL FLATTEN(input => t."SpecimenDescriptionSequence") sds
        , LATERAL FLATTEN(input => sds.value:"SpecimenPreparationSequence") sps
        , LATERAL FLATTEN(input => sps.value:"SpecimenPreparationStepContentItemSequence") ci
    WHERE
        t."Modality" = 'SM'
        AND ci.value:"ConceptNameCodeSequence"[0]:"CodeMeaning"::STRING = 'Using substance'
        AND ci.value:"ConceptCodeSequence"[0]:"CodingSchemeDesignator"::STRING = 'SCT'
)
SELECT
    embedding.embedding_medium_code_meaning,
    staining.staining_substance_code_meaning,
    COUNT(DISTINCT embedding."SOPInstanceUID") AS occurrences
FROM
    embedding
    INNER JOIN staining ON embedding."SOPInstanceUID" = staining."SOPInstanceUID"
GROUP BY
    embedding.embedding_medium_code_meaning,
    staining.staining_substance_code_meaning
ORDER BY
    occurrences DESC NULLS LAST;