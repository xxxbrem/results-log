SELECT s."SegmentedPropertyCategory"['CodeMeaning']::STRING AS "SegmentationCategory",
       COUNT(*) AS "Frequency"
FROM IDC.IDC_V17.DICOM_PIVOT p
JOIN IDC.IDC_V17.SEGMENTATIONS s ON p."SOPInstanceUID" = s."SOPInstanceUID"
WHERE p."Modality" = 'SEG'
  AND p."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
GROUP BY "SegmentationCategory"
ORDER BY "Frequency" DESC NULLS LAST
LIMIT 5;