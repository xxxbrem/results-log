SELECT "id" AS drug_id, "drugType" AS drug_type, "hasBeenWithdrawn"
FROM OPEN_TARGETS_PLATFORM_1.PLATFORM.MOLECULE
WHERE "id" IN ('CHEMBL3137343', 'CHEMBL122', 'CHEMBL1201649', 'CHEMBL1201580')
  AND "isApproved" = TRUE
  AND "blackBoxWarning" = TRUE
  AND "drugType" IS NOT NULL;