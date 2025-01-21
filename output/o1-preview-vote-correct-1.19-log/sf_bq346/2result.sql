SELECT s.value:"SegmentedPropertyTypeCodeSequence"[0]:"CodeMeaning"::string AS "Segmentation_Category",
       COUNT(*) AS Count
FROM "IDC"."IDC_V17"."DICOM_ALL" t,
     LATERAL FLATTEN(input => t."SegmentSequence") s
WHERE t."Modality" = 'SEG'
  AND t."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
  AND t."access" = 'Public'
GROUP BY "Segmentation_Category"
ORDER BY Count DESC NULLS LAST
LIMIT 5;