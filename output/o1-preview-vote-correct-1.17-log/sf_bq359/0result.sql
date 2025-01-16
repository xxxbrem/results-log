WITH language_bytes AS (
    SELECT
        t."repo_name",
        (f.VALUE:"name")::STRING AS "language_name",
        SUM((f.VALUE:"bytes")::NUMBER) AS "language_bytes"
    FROM GITHUB_REPOS.GITHUB_REPOS.LANGUAGES t,
         LATERAL FLATTEN(input => t."language") f
    GROUP BY t."repo_name", "language_name"
),
primary_languages AS (
    SELECT
        lb."repo_name",
        lb."language_name",
        lb."language_bytes",
        ROW_NUMBER() OVER(
            PARTITION BY lb."repo_name"
            ORDER BY lb."language_bytes" DESC
        ) AS rn
    FROM language_bytes lb
)
SELECT
    sc."repo_name",
    COUNT(*) AS "commit_count"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_COMMITS sc
JOIN primary_languages pl ON sc."repo_name" = pl."repo_name"
WHERE pl.rn = 1 AND pl."language_name" = 'JavaScript'
GROUP BY sc."repo_name"
ORDER BY "commit_count" DESC NULLS LAST
LIMIT 2;