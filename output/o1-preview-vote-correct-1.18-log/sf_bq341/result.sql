SELECT "Address", ROUND("Balance" / 1e18, 4) AS "Balance"
FROM
(
    SELECT
        addr AS "Address",
        SUM(amount) AS "Balance"
    FROM
    (
        SELECT
            "to_address" AS addr,
            TRY_TO_NUMBER("value") AS amount
        FROM CRYPTO.CRYPTO_ETHEREUM."TOKEN_TRANSFERS"
        WHERE "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'

        UNION ALL

        SELECT
            "from_address" AS addr,
            -TRY_TO_NUMBER("value") AS amount
        FROM CRYPTO.CRYPTO_ETHEREUM."TOKEN_TRANSFERS"
        WHERE "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
    ) AS token_flows
    GROUP BY addr
) AS balances
WHERE "Balance" > 0
ORDER BY "Balance" ASC
LIMIT 3;