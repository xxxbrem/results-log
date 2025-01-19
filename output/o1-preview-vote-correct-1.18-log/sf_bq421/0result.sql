SELECT
    "primaryAnatomicStructure" AS "EmbeddingMediumCodeMeaning",
    "illuminationType" AS "StainingSubstanceCodeMeaning",
    COUNT(DISTINCT "SOPInstanceUID") AS "Occurrences"
FROM IDC.IDC_V17.DICOM_PIVOT
WHERE "Modality" = 'SM'
GROUP BY "primaryAnatomicStructure", "illuminationType";