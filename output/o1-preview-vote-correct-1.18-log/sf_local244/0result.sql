WITH durations AS (
  SELECT
    "TrackId",
    "Name",
    ("Milliseconds" / (1000 * 60)) AS "DurationMinutes"
  FROM "MUSIC"."MUSIC"."TRACK"
),
stats AS (
  SELECT
    MIN("DurationMinutes") AS "MinDuration",
    AVG("DurationMinutes") AS "AvgDuration",
    MAX("DurationMinutes") AS "MaxDuration"
  FROM durations
),
classifications AS (
  SELECT
    d."TrackId",
    d."Name",
    d."DurationMinutes",
    CASE
      WHEN d."DurationMinutes" >= s."MinDuration"
       AND d."DurationMinutes" < ((s."MinDuration" + s."AvgDuration") / 2)
      THEN 'Short'
      WHEN d."DurationMinutes" >= ((s."MinDuration" + s."AvgDuration") / 2)
       AND d."DurationMinutes" < ((s."AvgDuration" + s."MaxDuration") / 2)
      THEN 'Medium'
      WHEN d."DurationMinutes" >= ((s."AvgDuration" + s."MaxDuration") / 2)
       AND d."DurationMinutes" <= s."MaxDuration"
      THEN 'Long'
    END AS "Category"
  FROM durations d CROSS JOIN stats s
),
revenues AS (
  SELECT
    il."TrackId",
    SUM(il."UnitPrice" * il."Quantity") AS "Revenue"
  FROM "MUSIC"."MUSIC"."INVOICELINE" il
  GROUP BY il."TrackId"
)
SELECT
  c."Category",
  ROUND(MIN(c."DurationMinutes"), 4) AS "Min_Duration_in_minutes",
  ROUND(MAX(c."DurationMinutes"), 4) AS "Max_Duration_in_minutes",
  ROUND(COALESCE(SUM(r."Revenue"), 0), 4) AS "Total_Revenue"
FROM classifications c
LEFT JOIN revenues r ON c."TrackId" = r."TrackId"
GROUP BY c."Category"
ORDER BY c."Category";