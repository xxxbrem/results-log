SELECT "SegmentedPropertyTypeCodeSequence" AS "Segmentation_Category", COUNT(*) AS Count
FROM IDC.IDC_V17.DICOM_PIVOT
WHERE "Modality" = 'SEG'
  AND "SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
  AND "access" = 'Public'
  AND "SegmentedPropertyTypeCodeSequence" IS NOT NULL
  AND "SegmentedPropertyTypeCodeSequence" != ''
GROUP BY "SegmentedPropertyTypeCodeSequence"
ORDER BY Count DESC NULLS LAST
LIMIT 5;