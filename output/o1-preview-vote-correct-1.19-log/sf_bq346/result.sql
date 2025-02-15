SELECT t."SegmentedPropertyTypeCodeSequence" AS "Segmentation_Category",
       COUNT(*) AS "Count"
FROM IDC.IDC_V17.DICOM_PIVOT t
WHERE t."Modality" = 'SEG'
  AND t."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
  AND t."access" = 'Public'
  AND t."SegmentedPropertyTypeCodeSequence" IS NOT NULL
  AND t."SegmentedPropertyTypeCodeSequence" != ''
GROUP BY t."SegmentedPropertyTypeCodeSequence"
ORDER BY "Count" DESC NULLS LAST
LIMIT 5;