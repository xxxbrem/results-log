SELECT DATE(TO_TIMESTAMP("block_timestamp" / 1000000)) AS "Date",
       ROUND(SUM("amount"), 4) AS "Total_Transaction_Amount"
FROM CRYPTO.CRYPTO_ZILLIQA.TRANSACTIONS
WHERE DATE(TO_TIMESTAMP("block_timestamp" / 1000000)) < '2022-01-01'
  AND "amount" > 0
  AND "accepted" = TRUE
  AND "success" = TRUE
GROUP BY "Date"
ORDER BY "Total_Transaction_Amount" DESC NULLS LAST
LIMIT 1;