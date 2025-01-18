WITH latest_package_versions AS (
    SELECT 
        pv."System",
        pv."Name" AS "PackageName",
        pv."Version",
        pv."UpstreamPublishedAt",
        ROW_NUMBER() OVER (
            PARTITION BY pv."System", pv."Name" 
            ORDER BY pv."UpstreamPublishedAt" DESC NULLS LAST
        ) AS rn
    FROM 
        DEPS_DEV_V1.DEPS_DEV_V1."PACKAGEVERSIONS" pv
    WHERE 
        pv."System" = 'NPM' AND pv."UpstreamPublishedAt" IS NOT NULL
),
top_packages AS (
    SELECT 
        lpv."PackageName",
        lpv."Version",
        pr."StarsCount"
    FROM 
        latest_package_versions lpv
    JOIN DEPS_DEV_V1.DEPS_DEV_V1."PACKAGEVERSIONTOPROJECT" ptp
        ON lpv."System" = ptp."System" 
        AND lpv."PackageName" = ptp."Name" 
        AND lpv."Version" = ptp."Version"
    JOIN DEPS_DEV_V1.DEPS_DEV_V1."PROJECTS" pr
        ON ptp."ProjectName" = pr."Name" 
        AND ptp."ProjectType" = pr."Type"
    WHERE 
        lpv.rn = 1 
        AND ptp."ProjectType" = 'GITHUB' 
        AND pr."StarsCount" IS NOT NULL
)
SELECT 
    "PackageName", 
    "Version"
FROM (
    SELECT 
        "PackageName", 
        "Version", 
        ROW_NUMBER() OVER (ORDER BY "StarsCount" DESC NULLS LAST) AS rn
    FROM 
        top_packages
)
WHERE rn <= 8;