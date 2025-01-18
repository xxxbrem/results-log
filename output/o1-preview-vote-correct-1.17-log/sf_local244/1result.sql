WITH duration_stats AS (
    SELECT 
        MIN("Milliseconds") AS min_duration,
        AVG("Milliseconds") AS avg_duration,
        MAX("Milliseconds") AS max_duration
    FROM MUSIC.MUSIC.TRACK
),
classified_tracks AS (
    SELECT
        t."TrackId",
        t."Milliseconds",
        (t."Milliseconds" / 60000.0) AS "DurationMinutes",
        CASE
            WHEN t."Milliseconds" >= ds.min_duration
                 AND t."Milliseconds" < (ds.min_duration + ds.avg_duration) / 2
                THEN 'short'
            WHEN t."Milliseconds" >= (ds.min_duration + ds.avg_duration) / 2
                 AND t."Milliseconds" < (ds.avg_duration + ds.max_duration) / 2
                THEN 'medium'
            WHEN t."Milliseconds" >= (ds.avg_duration + ds.max_duration) / 2
                 AND t."Milliseconds" <= ds.max_duration
                THEN 'long'
            ELSE 'unknown'
        END AS "Category"
    FROM MUSIC.MUSIC.TRACK t
    CROSS JOIN duration_stats ds
),
revenue_per_track AS (
    SELECT
        il."TrackId",
        SUM(il."UnitPrice" * il."Quantity") AS "TotalRevenue"
    FROM MUSIC.MUSIC.INVOICELINE il
    GROUP BY il."TrackId"
)
SELECT
    ct."Category" AS "category",
    ROUND(MIN(ct."DurationMinutes"), 4) AS "min_duration_in_minutes",
    ROUND(MAX(ct."DurationMinutes"), 4) AS "max_duration_in_minutes",
    ROUND(SUM(COALESCE(rpt."TotalRevenue", 0)), 4) AS "total_revenue"
FROM classified_tracks ct
LEFT JOIN revenue_per_track rpt ON ct."TrackId" = rpt."TrackId"
WHERE ct."Category" IN ('short', 'medium', 'long')
GROUP BY ct."Category"
ORDER BY ct."Category";