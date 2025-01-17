WITH BestSellingArtist AS (
    SELECT
        A."ArtistId",
        A."Name",
        SUM(II."Quantity") AS TotalTracksSold
    FROM
        "CHINOOK"."CHINOOK"."INVOICE_ITEMS" II
        JOIN "CHINOOK"."CHINOOK"."TRACKS" T ON II."TrackId" = T."TrackId"
        JOIN "CHINOOK"."CHINOOK"."ALBUMS" AL ON T."AlbumId" = AL."AlbumId"
        JOIN "CHINOOK"."CHINOOK"."ARTISTS" A ON AL."ArtistId" = A."ArtistId"
    GROUP BY
        A."ArtistId",
        A."Name"
    ORDER BY
        TotalTracksSold DESC NULLS LAST
    LIMIT 1
)
SELECT
    C."FirstName",
    ROUND(SUM(II."UnitPrice" * II."Quantity"), 4) AS "Amount"
FROM
    "CHINOOK"."CHINOOK"."CUSTOMERS" C
    JOIN "CHINOOK"."CHINOOK"."INVOICES" I ON C."CustomerId" = I."CustomerId"
    JOIN "CHINOOK"."CHINOOK"."INVOICE_ITEMS" II ON I."InvoiceId" = II."InvoiceId"
    JOIN "CHINOOK"."CHINOOK"."TRACKS" T ON II."TrackId" = T."TrackId"
    JOIN "CHINOOK"."CHINOOK"."ALBUMS" AL ON T."AlbumId" = AL."AlbumId"
    JOIN BestSellingArtist BSA ON AL."ArtistId" = BSA."ArtistId"
GROUP BY
    C."CustomerId",
    C."FirstName"
HAVING
    SUM(II."UnitPrice" * II."Quantity") < 1.0000;