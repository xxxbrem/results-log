SELECT
    s."SegmentedPropertyCategory":"CodeMeaning"::STRING AS "SegmentedPropertyCategory",
    COUNT(*) AS "Count"
FROM IDC.IDC_V17."SEGMENTATIONS" AS s
JOIN IDC.IDC_V17."DICOM_ALL" AS d
  ON s."SOPInstanceUID" = d."SOPInstanceUID"
WHERE
  d."Modality" = 'SEG'
  AND d."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
  AND d."access" = 'Public'
GROUP BY
  "SegmentedPropertyCategory"
ORDER BY
  "Count" DESC NULLS LAST
LIMIT 5;