WITH LargestZIP AS (
    SELECT "ZIP"
    FROM "US_ADDRESSES__POI"."CYBERSYN"."US_ADDRESSES"
    WHERE "STATE" = 'FL' AND "ZIP" IS NOT NULL AND "ZIP" != ''
    GROUP BY "ZIP"
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT "NUMBER", "STREET", "STREET_TYPE"
FROM "US_ADDRESSES__POI"."CYBERSYN"."US_ADDRESSES"
WHERE "STATE" = 'FL' AND "ZIP" = (SELECT "ZIP" FROM LargestZIP)
ORDER BY "LATITUDE" DESC NULLS LAST
LIMIT 10;