SELECT
  s."SegmentedPropertyCategory":"CodeMeaning"::VARCHAR AS SegmentationCategory,
  COUNT(*) AS Count
FROM IDC.IDC_V17."SEGMENTATIONS" s
JOIN IDC.IDC_V17."DICOM_PIVOT" d ON s."SOPInstanceUID" = d."SOPInstanceUID"
WHERE
  d."Modality" = 'SEG'
  AND d."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
  AND d."access" = 'Public'
GROUP BY SegmentationCategory
ORDER BY Count DESC NULLS LAST
LIMIT 5;