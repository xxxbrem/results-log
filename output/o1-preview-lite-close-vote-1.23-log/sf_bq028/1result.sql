SELECT p."Name" AS "ProjectName", p."StarsCount"
FROM DEPS_DEV_V1.DEPS_DEV_V1.PROJECTS p
WHERE p."StarsCount" IS NOT NULL
ORDER BY p."StarsCount" DESC NULLS LAST
LIMIT 8;