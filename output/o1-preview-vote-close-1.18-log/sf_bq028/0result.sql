WITH latest_versions AS (
  SELECT
    pv."Name",
    MAX(pv."UpstreamPublishedAt") AS "LatestPublishedAt"
  FROM DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS pv
  WHERE pv."System" = 'NPM' AND pv."UpstreamPublishedAt" IS NOT NULL
  GROUP BY pv."Name"
),
latest_packages AS (
  SELECT
    pv."Name",
    pv."Version"
  FROM DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS pv
  JOIN latest_versions lv
    ON pv."Name" = lv."Name" AND pv."UpstreamPublishedAt" = lv."LatestPublishedAt"
  WHERE pv."System" = 'NPM'
),
package_projects AS (
  SELECT
    DISTINCT lp."Name" AS "PackageName",
    lp."Version",
    pvtp."ProjectName"
  FROM latest_packages lp
  JOIN DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONTOPROJECT pvtp
    ON pvtp."System" = 'NPM'
    AND pvtp."Name" = lp."Name"
    AND pvtp."Version" = lp."Version"
  WHERE pvtp."ProjectType" = 'GITHUB'
),
package_stars AS (
  SELECT
    pp."PackageName",
    pp."Version",
    pj."StarsCount"
  FROM package_projects pp
  JOIN DEPS_DEV_V1.DEPS_DEV_V1.PROJECTS pj
    ON LOWER(pp."ProjectName") = LOWER(pj."Name")
  WHERE pj."Type" = 'GITHUB' AND pj."StarsCount" IS NOT NULL
)
SELECT
  "PackageName",
  "Version",
  "StarsCount"
FROM package_stars
ORDER BY "StarsCount" DESC NULLS LAST
LIMIT 8;