WITH date_range AS (
  SELECT 
    "TICKER",
    MIN("DATE") AS "START_DATE",
    MAX("DATE") AS "END_DATE"
  FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES
  WHERE
    "TICKER" IN ('META', 'GOOGL', 'AMZN', 'MSFT', 'AAPL', 'TSLA', 'NVDA')
    AND "VARIABLE" = 'post-market_close'
    AND "DATE" BETWEEN '2024-01-01' AND '2024-06-30'
  GROUP BY "TICKER"
),
start_prices AS (
  SELECT dr."TICKER", st."VALUE" AS "START_VALUE"
  FROM date_range dr
  JOIN FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES st
    ON dr."TICKER" = st."TICKER" 
    AND dr."START_DATE" = st."DATE"
    AND st."VARIABLE" = 'post-market_close'
),
end_prices AS (
  SELECT dr."TICKER", st."VALUE" AS "END_VALUE"
  FROM date_range dr
  JOIN FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES st
    ON dr."TICKER" = st."TICKER" 
    AND dr."END_DATE" = st."DATE"
    AND st."VARIABLE" = 'post-market_close'
)
SELECT
  s."TICKER",
  ROUND(((e."END_VALUE" - s."START_VALUE") / s."START_VALUE") * 100, 4) AS "Percentage_Change"
FROM start_prices s
JOIN end_prices e ON s."TICKER" = e."TICKER";