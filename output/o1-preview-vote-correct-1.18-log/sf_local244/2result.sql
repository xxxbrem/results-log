WITH
durations AS (
    SELECT
        "TrackId",
        "Milliseconds" / 60000.0 AS DurationMinutes
    FROM MUSIC.MUSIC."TRACK"
),
stats AS (
    SELECT
        MIN(DurationMinutes) AS MinDuration,
        AVG(DurationMinutes) AS AvgDuration,
        MAX(DurationMinutes) AS MaxDuration
    FROM durations
),
thresholds AS (
    SELECT
        MinDuration,
        AvgDuration,
        MaxDuration,
        (MinDuration + AvgDuration) / 2 AS MidMinAvg,
        (AvgDuration + MaxDuration) / 2 AS MidAvgMax
    FROM stats
),
classified_tracks AS (
    SELECT
        d."TrackId",
        d.DurationMinutes,
        CASE
            WHEN d.DurationMinutes <= t.MidMinAvg THEN 'Short'
            WHEN d.DurationMinutes <= t.MidAvgMax THEN 'Medium'
            ELSE 'Long'
        END AS Category
    FROM durations d
    CROSS JOIN thresholds t
),
revenue_per_track AS (
    SELECT
        "TrackId",
        SUM("UnitPrice" * "Quantity") AS Revenue
    FROM MUSIC.MUSIC."INVOICELINE"
    GROUP BY "TrackId"
)
SELECT
    Category,
    ROUND(MIN(DurationMinutes), 4) AS MinTime,
    ROUND(MAX(DurationMinutes), 4) AS MaxTime,
    ROUND(COALESCE(SUM(Revenue), 0), 4) AS TotalRevenue
FROM classified_tracks ct
LEFT JOIN revenue_per_track rpt ON ct."TrackId" = rpt."TrackId"
GROUP BY Category
ORDER BY Category;