SELECT c."FirstName", ROUND(SUM(ii."UnitPrice" * ii."Quantity"), 4) AS "AmountSpent"
FROM "customers" AS c
JOIN "invoices" AS i ON c."CustomerId" = i."CustomerId"
JOIN "invoice_items" AS ii ON i."InvoiceId" = ii."InvoiceId"
JOIN "tracks" AS t ON ii."TrackId" = t."TrackId"
JOIN "albums" AS a ON t."AlbumId" = a."AlbumId"
JOIN "artists" AS ar ON a."ArtistId" = ar."ArtistId"
WHERE ar."ArtistId" = (
    SELECT ar2."ArtistId"
    FROM "artists" AS ar2
    JOIN "albums" AS a2 ON ar2."ArtistId" = a2."ArtistId"
    JOIN "tracks" AS t2 ON a2."AlbumId" = t2."AlbumId"
    JOIN "invoice_items" AS ii2 ON t2."TrackId" = ii2."TrackId"
    GROUP BY ar2."ArtistId"
    ORDER BY SUM(ii2."UnitPrice" * ii2."Quantity") DESC
    LIMIT 1
)
GROUP BY c."CustomerId", c."FirstName"
HAVING "AmountSpent" < 1
LIMIT 1000;