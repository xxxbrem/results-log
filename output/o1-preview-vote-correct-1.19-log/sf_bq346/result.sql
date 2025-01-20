SELECT
    s."SegmentedPropertyCategory":CodeMeaning::STRING AS "SegmentationCategory",
    COUNT(*) AS "Frequency"
FROM
    "IDC"."IDC_V17"."DICOM_PIVOT" d
JOIN
    "IDC"."IDC_V17"."SEGMENTATIONS" s
    ON d."SOPInstanceUID" = s."SOPInstanceUID"
WHERE
    d."Modality" = 'SEG'
    AND d."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
    AND d."access" = 'Public'
GROUP BY
    "SegmentationCategory"
ORDER BY
    "Frequency" DESC NULLS LAST
LIMIT 5;