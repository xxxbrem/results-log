SELECT
  TO_DATE(DATEADD('second', FLOOR("block_timestamp" / 1e6), TIMESTAMP '1970-01-01')) AS "date",
  ROUND(SUM("amount") / 1e12, 4) AS "total_transaction_amount"
FROM
  "CRYPTO"."CRYPTO_ZILLIQA"."TRANSACTIONS"
WHERE
  TO_DATE(DATEADD('second', FLOOR("block_timestamp" / 1e6), TIMESTAMP '1970-01-01')) < '2022-01-01'
GROUP BY
  "date"
ORDER BY
  "total_transaction_amount" DESC NULLS LAST
LIMIT 1;