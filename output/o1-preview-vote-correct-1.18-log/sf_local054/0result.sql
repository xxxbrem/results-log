WITH BestSellingArtist AS (
    SELECT AR."ArtistId", AR."Name" AS "ArtistName", SUM(II."UnitPrice" * II."Quantity") AS "TotalSales"
    FROM "CHINOOK"."CHINOOK"."INVOICE_ITEMS" II
    JOIN "CHINOOK"."CHINOOK"."TRACKS" T ON II."TrackId" = T."TrackId"
    JOIN "CHINOOK"."CHINOOK"."ALBUMS" AL ON T."AlbumId" = AL."AlbumId"
    JOIN "CHINOOK"."CHINOOK"."ARTISTS" AR ON AL."ArtistId" = AR."ArtistId"
    GROUP BY AR."ArtistId", AR."Name"
    ORDER BY "TotalSales" DESC NULLS LAST
    LIMIT 1
),
TracksByBestSellingArtist AS (
    SELECT T."TrackId"
    FROM "CHINOOK"."CHINOOK"."TRACKS" T
    JOIN "CHINOOK"."CHINOOK"."ALBUMS" AL ON T."AlbumId" = AL."AlbumId"
    JOIN BestSellingArtist BSA ON AL."ArtistId" = BSA."ArtistId"
),
CustomerSpentLessThanOne AS (
    SELECT C."FirstName", SUM(II."UnitPrice" * II."Quantity") AS "AmountSpent"
    FROM "CHINOOK"."CHINOOK"."INVOICE_ITEMS" II
    JOIN "CHINOOK"."CHINOOK"."INVOICES" INV ON II."InvoiceId" = INV."InvoiceId"
    JOIN "CHINOOK"."CHINOOK"."CUSTOMERS" C ON INV."CustomerId" = C."CustomerId"
    WHERE II."TrackId" IN (SELECT "TrackId" FROM TracksByBestSellingArtist)
    GROUP BY C."FirstName", C."CustomerId"
    HAVING SUM(II."UnitPrice" * II."Quantity") < 1
)
SELECT "FirstName", ROUND("AmountSpent", 4) AS "AmountSpent"
FROM CustomerSpentLessThanOne;