SELECT l."block_timestamp", l."block_number", l."transaction_hash"
FROM "CRYPTO"."CRYPTO_ETHEREUM"."LOGS" l
WHERE l."address" = '0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8'
  AND (
    l."topics"[0]::STRING = '0x7a53080ba414158be7ec69b987b5fb7d07dee101fe85488f0853ae16239d0bde'  -- Mint event topic
    OR
    l."topics"[0]::STRING = '0x0c396cd989a39f4459b5fa1aed6a9a8dcdbc45908acfd67e028cd568da98982c'  -- Burn event topic
  )
ORDER BY l."block_timestamp" ASC
LIMIT 5;