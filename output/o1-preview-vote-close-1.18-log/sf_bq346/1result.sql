SELECT
  t."SegmentedPropertyCategory"['CodeMeaning']::STRING AS "SegmentedPropertyCategory",
  COUNT(*) AS "Count"
FROM
  IDC.IDC_V17.SEGMENTATIONS t
JOIN
  IDC.IDC_V17.DICOM_ALL d
  ON t."SOPInstanceUID" = d."SOPInstanceUID"
WHERE
  d."Modality" = 'SEG'
  AND d."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
GROUP BY
  "SegmentedPropertyCategory"
ORDER BY
  "Count" DESC NULLS LAST
LIMIT 5;