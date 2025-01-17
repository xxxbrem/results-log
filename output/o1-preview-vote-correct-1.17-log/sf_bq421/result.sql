WITH
embedding_medium AS (
  SELECT DISTINCT
    t."SOPInstanceUID",
    sd.seq AS sd_seq,
    sp.seq AS sp_seq,
    c.value:"ConceptCodeSequence"[0]:"CodeMeaning"::STRING AS "embedding_medium_meaning"
  FROM IDC.IDC_V17.DICOM_ALL t
    CROSS JOIN LATERAL FLATTEN(input => t."SpecimenDescriptionSequence") sd
    CROSS JOIN LATERAL FLATTEN(input => sd.value:"SpecimenPreparationSequence") sp
    CROSS JOIN LATERAL FLATTEN(input => sp.value:"SpecimenPreparationStepContentItemSequence") c
  WHERE t."Modality" = 'SM'
    AND c.value:"ConceptNameCodeSequence"[0]:"CodeMeaning"::STRING = 'Embedding medium'
    AND c.value:"ConceptCodeSequence"[0]:"CodingSchemeDesignator"::STRING = 'SCT'
),
staining_substance AS (
  SELECT DISTINCT
    t."SOPInstanceUID",
    sd.seq AS sd_seq,
    sp.seq AS sp_seq,
    c_us.value:"ConceptCodeSequence"[0]:"CodeMeaning"::STRING AS "staining_substance_meaning"
  FROM IDC.IDC_V17.DICOM_ALL t
    CROSS JOIN LATERAL FLATTEN(input => t."SpecimenDescriptionSequence") sd
    CROSS JOIN LATERAL FLATTEN(input => sd.value:"SpecimenPreparationSequence") sp
    CROSS JOIN LATERAL FLATTEN(input => sp.value:"SpecimenPreparationStepContentItemSequence") c_pt
    CROSS JOIN LATERAL FLATTEN(input => sp.value:"SpecimenPreparationStepContentItemSequence") c_us
  WHERE t."Modality" = 'SM'
    AND c_pt.value:"ConceptNameCodeSequence"[0]:"CodeMeaning"::STRING = 'Processing type'
    AND c_pt.value:"ConceptCodeSequence"[0]:"CodeMeaning"::STRING = 'Staining'
    AND c_us.value:"ConceptNameCodeSequence"[0]:"CodeMeaning"::STRING = 'Using substance'
    AND c_us.value:"ConceptCodeSequence"[0]:"CodingSchemeDesignator"::STRING = 'SCT'
)
SELECT
  em."embedding_medium_meaning",
  ss."staining_substance_meaning",
  COUNT(DISTINCT em."SOPInstanceUID", em.sd_seq, em.sp_seq) AS "occurrences"
FROM embedding_medium em
JOIN staining_substance ss
  ON em."SOPInstanceUID" = ss."SOPInstanceUID"
     AND em.sd_seq = ss.sd_seq
     AND em.sp_seq = ss.sp_seq
GROUP BY em."embedding_medium_meaning", ss."staining_substance_meaning"
ORDER BY "occurrences" DESC NULLS LAST;