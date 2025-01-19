WITH
JanPrices AS (
  SELECT
    "TICKER",
    MIN("DATE") AS "Jan_Date"
  FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES
  WHERE "TICKER" IN ('AAPL', 'MSFT', 'GOOGL', 'AMZN', 'NVDA', 'TSLA', 'META')
    AND "DATE" BETWEEN '2024-01-01' AND '2024-01-31'
    AND "VARIABLE" = 'post-market_close'
  GROUP BY "TICKER"
),
JanValues AS (
  SELECT
    jp."TICKER",
    jp."Jan_Date",
    sp."VALUE" AS "Jan_Value"
  FROM JanPrices jp
  JOIN FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES sp
    ON jp."TICKER" = sp."TICKER"
    AND jp."Jan_Date" = sp."DATE"
    AND sp."VARIABLE" = 'post-market_close'
),
JunePrices AS (
  SELECT
    "TICKER",
    MAX("DATE") AS "June_Date"
  FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES
  WHERE "TICKER" IN ('AAPL', 'MSFT', 'GOOGL', 'AMZN', 'NVDA', 'TSLA', 'META')
    AND "DATE" BETWEEN '2024-06-01' AND '2024-06-30'
    AND "VARIABLE" = 'post-market_close'
  GROUP BY "TICKER"
),
JuneValues AS (
  SELECT
    jp."TICKER",
    jp."June_Date",
    sp."VALUE" AS "June_Value"
  FROM JunePrices jp
  JOIN FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES sp
    ON jp."TICKER" = sp."TICKER"
    AND jp."June_Date" = sp."DATE"
    AND sp."VARIABLE" = 'post-market_close'
)
SELECT
  jv."TICKER",
  jv."Jan_Date",
  jv."Jan_Value",
  jnv."June_Date",
  jnv."June_Value",
  ROUND(((jnv."June_Value" - jv."Jan_Value") / jv."Jan_Value") * 100, 4) AS "Percentage_Change"
FROM JanValues jv
JOIN JuneValues jnv
  ON jv."TICKER" = jnv."TICKER";