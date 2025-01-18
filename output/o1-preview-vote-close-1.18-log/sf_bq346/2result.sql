SELECT
    s."SegmentedPropertyCategory":"CodeMeaning"::STRING AS "SegmentedPropertyCategory",
    COUNT(*) AS "Count"
FROM
    IDC.IDC_V17.SEGMENTATIONS s
JOIN
    IDC.IDC_V17.DICOM_METADATA m
    ON s."SOPInstanceUID" = m."SOPInstanceUID"
WHERE
    m."Modality" = 'SEG'
    AND m."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
GROUP BY
    "SegmentedPropertyCategory"
ORDER BY
    "Count" DESC NULLS LAST
LIMIT 5;