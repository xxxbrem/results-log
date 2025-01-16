SELECT 
    DATE(TO_TIMESTAMP_NTZ("block_timestamp" / 1000000.0)) AS "date", 
    ROUND(SUM("amount"), 4) AS "total_amount"
FROM "CRYPTO"."CRYPTO_ZILLIQA"."TRANSACTIONS"
WHERE "block_timestamp" < 1640995200000000
    AND "success" = TRUE
    AND "accepted" = TRUE
    AND "amount" > 0
GROUP BY "date"
ORDER BY "total_amount" DESC NULLS LAST
LIMIT 1;