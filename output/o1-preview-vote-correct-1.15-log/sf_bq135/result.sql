SELECT DATE_TRUNC('DAY', TO_TIMESTAMP("block_timestamp" / 1e6)) AS "date",
       ROUND(SUM("amount"), 4) AS "total_transaction_amount"
FROM CRYPTO.CRYPTO_ZILLIQA.TRANSACTIONS
WHERE "block_timestamp" < 1640995200000000  -- Before 2022-01-01 in microseconds
GROUP BY "date"
ORDER BY "total_transaction_amount" DESC NULLS LAST
LIMIT 1;