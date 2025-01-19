WITH BestSellingArtist AS (
    SELECT ARTISTS."ArtistId", ARTISTS."Name", SUM(INVOICE_ITEMS."UnitPrice" * INVOICE_ITEMS."Quantity") AS "TotalSales"
    FROM "CHINOOK"."CHINOOK"."INVOICE_ITEMS"
    JOIN "CHINOOK"."CHINOOK"."TRACKS" ON INVOICE_ITEMS."TrackId" = TRACKS."TrackId"
    JOIN "CHINOOK"."CHINOOK"."ALBUMS" ON TRACKS."AlbumId" = ALBUMS."AlbumId"
    JOIN "CHINOOK"."CHINOOK"."ARTISTS" ON ALBUMS."ArtistId" = ARTISTS."ArtistId"
    GROUP BY ARTISTS."ArtistId", ARTISTS."Name"
    ORDER BY "TotalSales" DESC NULLS LAST
    LIMIT 1
),
CustomerArtistPurchases AS (
    SELECT INVOICES."CustomerId", CUSTOMERS."FirstName", ROUND(SUM(INVOICE_ITEMS."UnitPrice" * INVOICE_ITEMS."Quantity"), 4) AS "AmountSpent"
    FROM "CHINOOK"."CHINOOK"."INVOICE_ITEMS"
    JOIN "CHINOOK"."CHINOOK"."INVOICES" ON INVOICE_ITEMS."InvoiceId" = INVOICES."InvoiceId"
    JOIN "CHINOOK"."CHINOOK"."CUSTOMERS" ON INVOICES."CustomerId" = CUSTOMERS."CustomerId"
    JOIN "CHINOOK"."CHINOOK"."TRACKS" ON INVOICE_ITEMS."TrackId" = TRACKS."TrackId"
    JOIN "CHINOOK"."CHINOOK"."ALBUMS" ON TRACKS."AlbumId" = ALBUMS."AlbumId"
    JOIN BestSellingArtist ON ALBUMS."ArtistId" = BestSellingArtist."ArtistId"
    GROUP BY INVOICES."CustomerId", CUSTOMERS."FirstName"
    HAVING SUM(INVOICE_ITEMS."UnitPrice" * INVOICE_ITEMS."Quantity") < 1
)
SELECT "FirstName", "AmountSpent"
FROM CustomerArtistPurchases
ORDER BY "FirstName";