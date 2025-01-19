SELECT
  em."EmbeddingMedium",
  ss."StainingSubstance",
  COUNT(DISTINCT em."SOPInstanceUID") AS "Count"
FROM (
  SELECT DISTINCT
    t."SOPInstanceUID",
    ccs.value:"CodeMeaning"::STRING AS "EmbeddingMedium"
  FROM IDC.IDC_V17.DICOM_METADATA t
  JOIN LATERAL FLATTEN(input => t."SpecimenDescriptionSequence") sd
  JOIN LATERAL FLATTEN(input => sd.value:"SpecimenPreparationSequence") sp
  JOIN LATERAL FLATTEN(input => sp.value:"SpecimenPreparationStepContentItemSequence") ci
  JOIN LATERAL FLATTEN(input => ci.value:"ConceptNameCodeSequence") cns
  JOIN LATERAL FLATTEN(input => ci.value:"ConceptCodeSequence") ccs
  WHERE t."Modality" = 'SM'
    AND ci.value:"ValueType"::STRING = 'CODE'
    AND cns.value:"CodeMeaning"::STRING = 'Embedding medium'
    AND ccs.value:"CodingSchemeDesignator"::STRING = 'SCT'
) em
JOIN (
  SELECT DISTINCT
    t."SOPInstanceUID",
    ccs.value:"CodeMeaning"::STRING AS "StainingSubstance"
  FROM IDC.IDC_V17.DICOM_METADATA t
  JOIN LATERAL FLATTEN(input => t."SpecimenDescriptionSequence") sd
  JOIN LATERAL FLATTEN(input => sd.value:"SpecimenPreparationSequence") sp
  JOIN LATERAL FLATTEN(input => sp.value:"SpecimenPreparationStepContentItemSequence") ci
  JOIN LATERAL FLATTEN(input => ci.value:"ConceptNameCodeSequence") cns
  JOIN LATERAL FLATTEN(input => ci.value:"ConceptCodeSequence") ccs
  WHERE t."Modality" = 'SM'
    AND ci.value:"ValueType"::STRING = 'CODE'
    AND cns.value:"CodeMeaning"::STRING = 'Using substance'
    AND ccs.value:"CodingSchemeDesignator"::STRING = 'SCT'
) ss
  ON em."SOPInstanceUID" = ss."SOPInstanceUID"
GROUP BY em."EmbeddingMedium", ss."StainingSubstance"
ORDER BY "Count" DESC NULLS LAST;