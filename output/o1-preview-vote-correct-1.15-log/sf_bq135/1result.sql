SELECT
    DATE(TO_TIMESTAMP_LTZ("block_timestamp" / 1000000)) AS "date",
    ROUND(SUM("amount"), 4) AS "total_transaction_amount"
FROM
    CRYPTO.CRYPTO_ZILLIQA.TRANSACTIONS
WHERE
    "block_timestamp" < 1640995200000000
    AND "accepted" = TRUE
    AND "success" = TRUE
    AND "amount" IS NOT NULL
    AND "amount" > 0
GROUP BY
    "date"
ORDER BY
    "total_transaction_amount" DESC NULLS LAST
LIMIT 1;