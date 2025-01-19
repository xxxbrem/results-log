SELECT s."SegmentedPropertyCategory":"CodeMeaning"::STRING AS "SegmentedPropertyCategory", COUNT(*) AS "Frequency"
FROM IDC.IDC_V17.SEGMENTATIONS s
JOIN IDC.IDC_V17.DICOM_ALL d ON s."SOPInstanceUID" = d."SOPInstanceUID"
WHERE d."access" = 'Public'
  AND d."Modality" = 'SEG'
  AND d."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
  AND s."SegmentedPropertyCategory":"CodeMeaning" IS NOT NULL
GROUP BY s."SegmentedPropertyCategory":"CodeMeaning"::STRING
ORDER BY "Frequency" DESC NULLS LAST
LIMIT 5;