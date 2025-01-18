SELECT
    sp_start."TICKER",
    ROUND(((sp_end."VALUE" - sp_start."VALUE") / sp_start."VALUE") * 100, 4) AS "Percentage_Change"
FROM
    (SELECT "TICKER", "VALUE"
     FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES
     WHERE "VARIABLE" = 'post-market_close'
       AND "DATE" = '2024-01-02'
       AND "TICKER" IN ('META', 'GOOGL', 'AMZN', 'MSFT', 'AAPL', 'TSLA', 'NVDA')) sp_start
JOIN
    (SELECT "TICKER", "VALUE"
     FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES
     WHERE "VARIABLE" = 'post-market_close'
       AND "DATE" = '2024-06-28'
       AND "TICKER" IN ('META', 'GOOGL', 'AMZN', 'MSFT', 'AAPL', 'TSLA', 'NVDA')) sp_end
ON sp_start."TICKER" = sp_end."TICKER";