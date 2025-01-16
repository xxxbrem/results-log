WITH total_received AS (
    SELECT 
        "to_address" AS "address",
        SUM(CAST("value" AS NUMBER(38,0))) AS "total_received_wei"
    FROM 
        CRYPTO.CRYPTO_ETHEREUM.TOKEN_TRANSFERS
    WHERE 
        "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
    GROUP BY 
        "to_address"
),
total_sent AS (
    SELECT 
        "from_address" AS "address",
        SUM(CAST("value" AS NUMBER(38,0))) AS "total_sent_wei"
    FROM 
        CRYPTO.CRYPTO_ETHEREUM.TOKEN_TRANSFERS
    WHERE 
        "token_address" = '0xa92a861fc11b99b24296af880011b47f9cafb5ab'
    GROUP BY 
        "from_address"
),
balances AS (
    SELECT 
        "address",
        ROUND((COALESCE("total_received_wei", 0) - COALESCE("total_sent_wei", 0)) / 1e18, 4) AS "balance"
    FROM 
        (SELECT "address" FROM total_received UNION SELECT "address" FROM total_sent) AS addresses
    LEFT JOIN total_received USING ("address")
    LEFT JOIN total_sent USING ("address")
)
SELECT 
    "address", 
    "balance"
FROM 
    balances
WHERE 
    "balance" > 0
ORDER BY 
    "balance" ASC NULLS LAST
LIMIT 3;