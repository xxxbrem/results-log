SELECT COUNT(DISTINCT "StudyInstanceUID") AS UniqueStudyInstanceUIDs
FROM IDC.IDC_V17.DICOM_PIVOT
WHERE "collection_id" = 'qin_prostate_repeatability'
  AND "SeriesDescription" IN (
    'DWI',
    'T2 Weighted Axial',
    'Apparent Diffusion Coefficient',
    'T2 Weighted Axial Segmentations',
    'Apparent Diffusion Coefficient Segmentations',
    'T2 Weighted Axial Measurements',
    'Apparent Diffusion Coefficient Measurements'
  );