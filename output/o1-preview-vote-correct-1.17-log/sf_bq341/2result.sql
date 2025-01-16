SELECT address, ROUND(balance, 4) AS balance
FROM (
  SELECT address, SUM(value) AS balance
  FROM (
    SELECT LOWER("from_address") AS address, -TO_NUMBER("value") / 1e18 AS value
    FROM "CRYPTO"."CRYPTO_ETHEREUM"."TOKEN_TRANSFERS"
    WHERE LOWER("token_address") = LOWER('0xa92a861fc11b99b24296af880011b47f9cafb5ab')
    
    UNION ALL
    
    SELECT LOWER("to_address") AS address, TO_NUMBER("value") / 1e18 AS value
    FROM "CRYPTO"."CRYPTO_ETHEREUM"."TOKEN_TRANSFERS"
    WHERE LOWER("token_address") = LOWER('0xa92a861fc11b99b24296af880011b47f9cafb5ab')
  ) AS address_transfers
  GROUP BY address
) AS balances
WHERE balance > 0
ORDER BY balance ASC NULLS LAST
LIMIT 3;