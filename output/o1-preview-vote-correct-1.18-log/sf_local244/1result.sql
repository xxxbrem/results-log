WITH durations AS (
    SELECT T."TrackId", T."Milliseconds" / 60000.0 AS "duration_minutes"
    FROM MUSIC.MUSIC.TRACK T
),
stats AS (
    SELECT
        MIN("duration_minutes") AS "min_duration",
        AVG("duration_minutes") AS "avg_duration",
        MAX("duration_minutes") AS "max_duration"
    FROM durations
),
midpoints AS (
    SELECT
        stats."min_duration",
        stats."avg_duration",
        stats."max_duration",
        (stats."min_duration" + stats."avg_duration") / 2 AS "min_avg_midpoint",
        (stats."avg_duration" + stats."max_duration") / 2 AS "avg_max_midpoint"
    FROM stats
),
classified_tracks AS (
    SELECT
        d."TrackId",
        d."duration_minutes",
        CASE
            WHEN d."duration_minutes" >= midpoints."min_duration" AND d."duration_minutes" < midpoints."min_avg_midpoint" THEN 'Short'
            WHEN d."duration_minutes" >= midpoints."min_avg_midpoint" AND d."duration_minutes" < midpoints."avg_max_midpoint" THEN 'Medium'
            WHEN d."duration_minutes" >= midpoints."avg_max_midpoint" AND d."duration_minutes" <= midpoints."max_duration" THEN 'Long'
            ELSE 'Unclassified'
        END AS "Length_category"
    FROM durations d, midpoints
),
revenue_per_track AS (
    SELECT
        il."TrackId",
        SUM(il."UnitPrice" * il."Quantity") AS "total_revenue"
    FROM MUSIC.MUSIC.INVOICELINE il
    GROUP BY il."TrackId"
),
tracks_with_revenue AS (
    SELECT
        ct."Length_category",
        ct."duration_minutes",
        COALESCE(r."total_revenue", 0) AS "total_revenue"
    FROM classified_tracks ct
    LEFT JOIN revenue_per_track r ON ct."TrackId" = r."TrackId"
),
category_stats AS (
    SELECT
        "Length_category",
        MIN("duration_minutes") AS "min_time",
        MAX("duration_minutes") AS "max_time",
        SUM("total_revenue") AS "total_revenue"
    FROM tracks_with_revenue
    WHERE "Length_category" IN ('Short', 'Medium', 'Long')
    GROUP BY "Length_category"
)
SELECT "Length_category", ROUND("min_time", 4) AS "min_time", ROUND("max_time", 4) AS "max_time", ROUND("total_revenue", 4) AS "total_revenue"
FROM category_stats
ORDER BY "Length_category";