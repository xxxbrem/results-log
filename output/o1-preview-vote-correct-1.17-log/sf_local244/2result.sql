WITH stats AS (
    SELECT MIN("Milliseconds") / (1000 * 60.0) AS min_duration,
           AVG("Milliseconds") / (1000 * 60.0) AS avg_duration,
           MAX("Milliseconds") / (1000 * 60.0) AS max_duration
    FROM MUSIC.MUSIC.TRACK
),
thresholds AS (
    SELECT 
        ROUND(min_duration, 4) AS min_duration,
        ROUND(avg_duration, 4) AS avg_duration,
        ROUND(max_duration, 4) AS max_duration,
        ROUND((min_duration + avg_duration) / 2, 4) AS mid1,
        ROUND((avg_duration + max_duration) / 2, 4) AS mid2
    FROM stats
),
categorized_tracks AS (
    SELECT 
        t."TrackId",
        t."Milliseconds" / (1000 * 60.0) AS duration_minutes,
        CASE
            WHEN t."Milliseconds" / (1000 * 60.0) >= thresholds.min_duration AND t."Milliseconds" / (1000 * 60.0) < thresholds.mid1 THEN 'Short'
            WHEN t."Milliseconds" / (1000 * 60.0) >= thresholds.mid1 AND t."Milliseconds" / (1000 * 60.0) < thresholds.mid2 THEN 'Medium'
            WHEN t."Milliseconds" / (1000 * 60.0) >= thresholds.mid2 THEN 'Long'
        END AS Category
    FROM MUSIC.MUSIC.TRACK t
    CROSS JOIN thresholds
),
track_revenues AS (
    SELECT il."TrackId",
           SUM(il."UnitPrice" * il."Quantity") AS Total_Revenue
    FROM MUSIC.MUSIC.INVOICELINE il
    GROUP BY il."TrackId"
),
category_revenues AS (
    SELECT c.Category,
           SUM(COALESCE(tr.Total_Revenue, 0)) AS Total_Revenue
    FROM categorized_tracks c
    LEFT JOIN track_revenues tr ON c."TrackId" = tr."TrackId"
    GROUP BY c.Category
),
category_thresholds AS (
    SELECT 'Short' AS Category, thresholds.min_duration AS Minimum_Duration_Minutes, thresholds.mid1 AS Maximum_Duration_Minutes FROM thresholds
    UNION ALL
    SELECT 'Medium' AS Category, thresholds.mid1 AS Minimum_Duration_Minutes, thresholds.mid2 AS Maximum_Duration_Minutes FROM thresholds
    UNION ALL
    SELECT 'Long' AS Category, thresholds.mid2 AS Minimum_Duration_Minutes, thresholds.max_duration AS Maximum_Duration_Minutes FROM thresholds
)
SELECT ct.Category,
       ct.Minimum_Duration_Minutes,
       ct.Maximum_Duration_Minutes,
       ROUND(cr.Total_Revenue, 4) AS Total_Revenue
FROM category_thresholds ct
LEFT JOIN category_revenues cr ON ct.Category = cr.Category
ORDER BY CASE
             WHEN ct.Category = 'Short' THEN 1
             WHEN ct.Category = 'Medium' THEN 2
             WHEN ct.Category = 'Long' THEN 3
         END;