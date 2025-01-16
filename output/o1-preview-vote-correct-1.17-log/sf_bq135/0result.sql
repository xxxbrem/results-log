SELECT
    TO_DATE(TO_TIMESTAMP_NTZ("block_timestamp" / 1e6)) AS "date",
    SUM("amount") AS "total_transaction_amount"
FROM
    CRYPTO.CRYPTO_ZILLIQA."TRANSACTIONS"
WHERE
    TO_TIMESTAMP_NTZ("block_timestamp" / 1e6) < TIMESTAMP '2022-01-01 00:00:00'
GROUP BY
    "date"
ORDER BY
    "total_transaction_amount" DESC NULLS LAST
LIMIT 1;