WITH TrackDuration AS (
    SELECT
        "TrackId",
        "Name",
        ROUND(("Milliseconds" / 60000.0), 4) AS DurationMinutes,
        CASE
            WHEN ("Milliseconds" / 60000.0) < 3 THEN 'Short'
            WHEN ("Milliseconds" / 60000.0) BETWEEN 3 AND 6 THEN 'Medium'
            ELSE 'Long'
        END AS Category
    FROM "Track"
),
TrackRevenue AS (
    SELECT
        "TrackId",
        SUM("UnitPrice" * "Quantity") AS TotalRevenue
    FROM "InvoiceLine"
    GROUP BY "TrackId"
)
SELECT
    td.Category,
    MIN(td.DurationMinutes) AS Min_time_minutes,
    MAX(td.DurationMinutes) AS Max_time_minutes,
    ROUND(SUM(COALESCE(tr.TotalRevenue, 0)), 4) AS Total_revenue
FROM
    TrackDuration td
    LEFT JOIN TrackRevenue tr ON td."TrackId" = tr."TrackId"
GROUP BY
    td.Category
ORDER BY
    td.Category;