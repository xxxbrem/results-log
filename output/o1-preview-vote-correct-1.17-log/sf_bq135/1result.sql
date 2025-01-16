SELECT DATE_TRUNC('day', TO_TIMESTAMP_NTZ("block_timestamp" / 1e6)) AS "date",
       SUM("amount") AS "total_transaction_amount"
FROM CRYPTO.CRYPTO_ZILLIQA.TRANSACTIONS
WHERE "block_timestamp" < 1640995200000000
  AND "accepted" = TRUE
  AND "success" = TRUE
GROUP BY "date"
ORDER BY "total_transaction_amount" DESC NULLS LAST
LIMIT 1;