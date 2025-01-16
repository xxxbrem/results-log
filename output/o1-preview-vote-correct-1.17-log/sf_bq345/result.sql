SELECT
    t."collection_id",
    t."StudyInstanceUID",
    t."SeriesInstanceUID",
    ROUND(SUM(t."instance_size") / 1024, 4) AS "TotalSizeKB",
    CONCAT('https://viewer.imaging.datacommons.cancer.gov/viewer/', t."StudyInstanceUID") AS "viewer_url"
FROM
    "IDC"."IDC_V17"."DICOM_ALL" t
WHERE
    t."Modality" IN ('SEG', 'RTSTRUCT')
    AND t."SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
    AND (
        t."ReferencedImageSequence" IS NULL OR
        ARRAY_SIZE(t."ReferencedImageSequence") = 0
    )
    AND (
        t."ReferencedSeriesSequence" IS NULL OR
        ARRAY_SIZE(t."ReferencedSeriesSequence") = 0
    )
    AND (
        t."SourceImageSequence" IS NULL OR
        ARRAY_SIZE(t."SourceImageSequence") = 0
    )
GROUP BY
    t."collection_id",
    t."StudyInstanceUID",
    t."SeriesInstanceUID"
ORDER BY
    "TotalSizeKB" DESC NULLS LAST
;