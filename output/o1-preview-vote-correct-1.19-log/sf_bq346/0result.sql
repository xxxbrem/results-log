SELECT s."SegmentedPropertyCategory":CodeMeaning::STRING AS "SegmentationCategory", COUNT(*) AS "Frequency"
FROM IDC.IDC_V17.SEGMENTATIONS s
JOIN IDC.IDC_V17.DICOM_PIVOT dp ON s."SOPInstanceUID" = dp."SOPInstanceUID"
WHERE dp."Modality" = 'SEG' 
  AND dp."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
GROUP BY "SegmentationCategory"
ORDER BY "Frequency" DESC NULLS LAST
LIMIT 5;