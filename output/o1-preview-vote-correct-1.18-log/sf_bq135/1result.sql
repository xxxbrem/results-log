SELECT TO_DATE(TO_TIMESTAMP("block_timestamp" / 1e6)) AS "Date",
       ROUND(SUM("amount"), 4) AS "Total_Transaction_Amount"
FROM CRYPTO.CRYPTO_ZILLIQA.TRANSACTIONS
WHERE "block_timestamp" < 1640995200000000
  AND "amount" > 0
GROUP BY "Date"
ORDER BY "Total_Transaction_Amount" DESC NULLS LAST
LIMIT 1;