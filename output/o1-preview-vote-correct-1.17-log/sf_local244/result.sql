WITH boundaries AS (
    SELECT 
        MIN(t."Milliseconds") AS min_ms,
        AVG(t."Milliseconds") AS avg_ms,
        MAX(t."Milliseconds") AS max_ms,
        (MIN(t."Milliseconds") + AVG(t."Milliseconds")) / 2 AS mid_min_avg,
        (AVG(t."Milliseconds") + MAX(t."Milliseconds")) / 2 AS mid_avg_max
    FROM MUSIC.MUSIC.TRACK t
)
SELECT
    CASE
        WHEN t."Milliseconds" <= b.mid_min_avg THEN 'Short'
        WHEN t."Milliseconds" <= b.mid_avg_max THEN 'Medium'
        ELSE 'Long'
    END AS "Category",
    ROUND(MIN(t."Milliseconds") / 60000.0, 4) AS "Min_Duration(min)",
    ROUND(MAX(t."Milliseconds") / 60000.0, 4) AS "Max_Duration(min)",
    ROUND(COALESCE(SUM(il."UnitPrice" * il."Quantity"), 0), 2) AS "Total_Revenue"
FROM MUSIC.MUSIC.TRACK t
LEFT JOIN MUSIC.MUSIC.INVOICELINE il ON t."TrackId" = il."TrackId"
CROSS JOIN boundaries b
GROUP BY
    CASE
        WHEN t."Milliseconds" <= b.mid_min_avg THEN 'Short'
        WHEN t."Milliseconds" <= b.mid_avg_max THEN 'Medium'
        ELSE 'Long'
    END;