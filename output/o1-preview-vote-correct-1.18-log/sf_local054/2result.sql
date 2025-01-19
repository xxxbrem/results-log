SELECT c."FirstName",
       ROUND(SUM(ii."UnitPrice" * ii."Quantity"), 4) AS "AmountSpent"
FROM "CHINOOK"."CHINOOK"."CUSTOMERS" c
JOIN "CHINOOK"."CHINOOK"."INVOICES" i ON c."CustomerId" = i."CustomerId"
JOIN "CHINOOK"."CHINOOK"."INVOICE_ITEMS" ii ON i."InvoiceId" = ii."InvoiceId"
JOIN "CHINOOK"."CHINOOK"."TRACKS" t ON ii."TrackId" = t."TrackId"
JOIN "CHINOOK"."CHINOOK"."ALBUMS" a ON t."AlbumId" = a."AlbumId"
WHERE a."ArtistId" = (
    SELECT "ArtistId"
    FROM (
        SELECT a2."ArtistId", SUM(ii2."UnitPrice" * ii2."Quantity") AS "TotalSales"
        FROM "CHINOOK"."CHINOOK"."INVOICE_ITEMS" ii2
        JOIN "CHINOOK"."CHINOOK"."TRACKS" t2 ON ii2."TrackId" = t2."TrackId"
        JOIN "CHINOOK"."CHINOOK"."ALBUMS" a2 ON t2."AlbumId" = a2."AlbumId"
        GROUP BY a2."ArtistId"
        ORDER BY "TotalSales" DESC NULLS LAST
        LIMIT 1
    ) AS BestArtist
)
GROUP BY c."CustomerId", c."FirstName"
HAVING SUM(ii."UnitPrice" * ii."Quantity") < 1;