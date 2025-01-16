SELECT 
    TO_CHAR(TO_TIMESTAMP("block_timestamp" / 1000000), 'YYYY-MM-DD') AS "date", 
    ROUND(SUM("amount"), 4) AS "total_transaction_amount"
FROM CRYPTO.CRYPTO_ZILLIQA.TRANSACTIONS
WHERE "block_timestamp" < 1640995200000000  -- UNIX timestamp in microseconds for 2022-01-01
  AND "success" = TRUE
  AND "accepted" = TRUE
GROUP BY "date"
ORDER BY "total_transaction_amount" DESC NULLS LAST
LIMIT 1;