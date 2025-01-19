SELECT 
    "collection_id", 
    "StudyInstanceUID", 
    "SeriesInstanceUID", 
    ROUND(SUM("instance_size") / 1024, 4) AS "size_in_kilobytes", 
    CONCAT('https://viewer.imaging.datacommons.cancer.gov/viewer/', "StudyInstanceUID") AS "viewer_url"
FROM 
    IDC.IDC_V17.DICOM_ALL
WHERE 
    ("Modality" = 'SEG' OR "Modality" = 'RTSTRUCT')
    AND "SOPClassUID" = '1.2.840.10008.5.1.4.1.1.66.4'
    AND (
        ("ReferencedImageSequence" IS NULL OR ARRAY_SIZE("ReferencedImageSequence") = 0)
        AND ("ReferencedSeriesSequence" IS NULL OR ARRAY_SIZE("ReferencedSeriesSequence") = 0)
        AND ("ReferencedSOPInstanceUIDInFile" IS NULL OR "ReferencedSOPInstanceUIDInFile" = '')
        AND ("ReferencedSOPClassUID" IS NULL OR "ReferencedSOPClassUID" = '')
        AND ("ReferencedImageEvidenceSequence" IS NULL OR ARRAY_SIZE("ReferencedImageEvidenceSequence") = 0)
        AND ("SourceImageSequence" IS NULL OR ARRAY_SIZE("SourceImageSequence") = 0)
        AND ("SourceIrradiationEventSequence" IS NULL OR ARRAY_SIZE("SourceIrradiationEventSequence") = 0)
        AND ("ReferencedRawDataSequence" IS NULL OR ARRAY_SIZE("ReferencedRawDataSequence") = 0)
    )
GROUP BY 
    "collection_id", 
    "StudyInstanceUID", 
    "SeriesInstanceUID"
ORDER BY 
    "size_in_kilobytes" DESC NULLS LAST;