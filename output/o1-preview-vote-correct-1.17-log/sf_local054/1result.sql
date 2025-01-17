SELECT c."FirstName",
       ROUND(SUM(ii."UnitPrice" * ii."Quantity"), 4) AS "AmountSpent"
FROM "CHINOOK"."CHINOOK"."CUSTOMERS" c
JOIN "CHINOOK"."CHINOOK"."INVOICES" inv ON c."CustomerId" = inv."CustomerId"
JOIN "CHINOOK"."CHINOOK"."INVOICE_ITEMS" ii ON inv."InvoiceId" = ii."InvoiceId"
JOIN "CHINOOK"."CHINOOK"."TRACKS" t ON ii."TrackId" = t."TrackId"
JOIN "CHINOOK"."CHINOOK"."ALBUMS" alb ON t."AlbumId" = alb."AlbumId"
JOIN "CHINOOK"."CHINOOK"."ARTISTS" ar ON alb."ArtistId" = ar."ArtistId"
WHERE ar."Name" = 'Iron Maiden'
GROUP BY c."CustomerId", c."FirstName"
HAVING SUM(ii."UnitPrice" * ii."Quantity") < 1.00
ORDER BY c."FirstName";