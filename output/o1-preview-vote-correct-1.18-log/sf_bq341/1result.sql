WITH transfers AS (
    SELECT
        LOWER("from_address") AS "address",
        -TRY_TO_NUMERIC("value") AS "value"
    FROM CRYPTO.CRYPTO_ETHEREUM."TOKEN_TRANSFERS"
    WHERE "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'

    UNION ALL

    SELECT
        LOWER("to_address") AS "address",
        TRY_TO_NUMERIC("value") AS "value"
    FROM CRYPTO.CRYPTO_ETHEREUM."TOKEN_TRANSFERS"
    WHERE "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
),
balances AS (
    SELECT
        "address",
        SUM("value") AS "balance"
    FROM transfers
    GROUP BY "address"
)
SELECT
    "address",
    ROUND("balance", 4) AS "balance"
FROM balances
WHERE "balance" > 0
ORDER BY "balance" ASC NULLS LAST
LIMIT 3;