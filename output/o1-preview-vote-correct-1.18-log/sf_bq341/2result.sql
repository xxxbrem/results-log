SELECT
    "address",
    ROUND(SUM("value_received") - SUM("value_sent"), 4) AS "balance"
FROM (
    SELECT
        "to_address" AS "address",
        CAST("value" AS FLOAT) AS "value_received",
        0.0 AS "value_sent"
    FROM
        "CRYPTO"."CRYPTO_ETHEREUM"."TOKEN_TRANSFERS"
    WHERE
        "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
    UNION ALL
    SELECT
        "from_address" AS "address",
        0.0 AS "value_received",
        CAST("value" AS FLOAT) AS "value_sent"
    FROM
        "CRYPTO"."CRYPTO_ETHEREUM"."TOKEN_TRANSFERS"
    WHERE
        "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
)
GROUP BY
    "address"
HAVING
    SUM("value_received") - SUM("value_sent") > 0
ORDER BY
    "balance" ASC
LIMIT 3;