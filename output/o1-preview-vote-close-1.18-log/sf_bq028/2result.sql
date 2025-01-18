WITH latest_versions AS (
    SELECT
        pv."System",
        pv."Name" AS PackageName,
        pv."Version",
        pv."UpstreamPublishedAt",
        ROW_NUMBER() OVER (
            PARTITION BY pv."Name"
            ORDER BY pv."UpstreamPublishedAt" DESC
        ) AS rn
    FROM DEPS_DEV_V1.DEPS_DEV_V1."PACKAGEVERSIONS" pv
    WHERE
        pv."System" = 'NPM'
        AND pv."UpstreamPublishedAt" IS NOT NULL
        AND pv."Version" NOT LIKE '%-%'  -- Exclude pre-release versions
),
latest_npm_versions AS (
    SELECT * FROM latest_versions WHERE rn = 1
),
package_projects AS (
    SELECT
        ln.PackageName,
        ln."Version",
        ptp."ProjectType",
        ptp."ProjectName"
    FROM latest_npm_versions ln
    JOIN DEPS_DEV_V1.DEPS_DEV_V1."PACKAGEVERSIONTOPROJECT" ptp
        ON ln."System" = ptp."System" AND ln.PackageName = ptp."Name" AND ln."Version" = ptp."Version"
    WHERE ptp."ProjectType" = 'GITHUB'
),
project_stars AS (
    SELECT
        pp.PackageName,
        pp."Version",
        p."StarsCount"
    FROM package_projects pp
    JOIN DEPS_DEV_V1.DEPS_DEV_V1."PROJECTS" p
        ON pp."ProjectType" = p."Type" AND pp."ProjectName" = p."Name"
    WHERE p."StarsCount" IS NOT NULL
),
ranked_packages AS (
    SELECT
        PackageName,
        "Version",
        "StarsCount",
        ROW_NUMBER() OVER (ORDER BY "StarsCount" DESC NULLS LAST) AS rn_overall
    FROM project_stars
)
SELECT PackageName, "Version"
FROM ranked_packages
WHERE rn_overall <= 8;