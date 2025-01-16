SELECT
    "collection_id",
    "StudyInstanceUID",
    "SeriesInstanceUID",
    'https://viewer.imaging.datacommons.cancer.gov/viewer/' || "StudyInstanceUID" AS "viewer_url",
    ROUND(SUM("instance_size") / 1024.0, 4) AS "size_kb"
FROM
    IDC.IDC_V17.DICOM_ALL
WHERE
    ("Modality" = 'SEG' OR "Modality" = 'RTSTRUCT')
    AND "SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
    AND (("ReferencedSeriesSequence" IS NULL) OR (ARRAY_SIZE("ReferencedSeriesSequence") = 0))
    AND (("ReferencedImageSequence" IS NULL) OR (ARRAY_SIZE("ReferencedImageSequence") = 0))
    AND (("SourceImageSequence" IS NULL) OR (ARRAY_SIZE("SourceImageSequence") = 0))
GROUP BY
    "collection_id",
    "StudyInstanceUID",
    "SeriesInstanceUID"
ORDER BY
    "size_kb" DESC NULLS LAST;