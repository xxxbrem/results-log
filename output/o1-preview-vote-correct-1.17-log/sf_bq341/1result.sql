SELECT
  "address" AS "Ethereum_address",
  ROUND(SUM("balance_change") / 1e18, 4) AS "Balance"
FROM (
  SELECT
    "from_address" AS "address",
    -TRY_TO_NUMBER("value") AS "balance_change"
  FROM
    CRYPTO.CRYPTO_ETHEREUM."TOKEN_TRANSFERS"
  WHERE
    LOWER("token_address") = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
  UNION ALL
  SELECT
    "to_address" AS "address",
    TRY_TO_NUMBER("value") AS "balance_change"
  FROM
    CRYPTO.CRYPTO_ETHEREUM."TOKEN_TRANSFERS"
  WHERE
    LOWER("token_address") = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
) AS "all_transfers"
GROUP BY
  "address"
HAVING
  SUM("balance_change") > 0
ORDER BY
  "Balance" ASC
LIMIT
  3;