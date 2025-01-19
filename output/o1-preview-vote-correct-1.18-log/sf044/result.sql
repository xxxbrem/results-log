WITH First_Prices AS (
    SELECT 
        sp."TICKER", 
        sp."VALUE" AS "first_price"
    FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES sp
    WHERE 
        sp."VARIABLE" = 'post-market_close' 
        AND sp."DATE" BETWEEN '2024-01-01' AND '2024-06-30'
        AND sp."TICKER" IN ('AAPL', 'MSFT', 'GOOGL', 'AMZN', 'NVDA', 'TSLA', 'META')
    QUALIFY ROW_NUMBER() OVER (PARTITION BY sp."TICKER" ORDER BY sp."DATE" ASC NULLS LAST) = 1
),
Last_Prices AS (
    SELECT 
        sp."TICKER", 
        sp."VALUE" AS "last_price"
    FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES sp
    WHERE 
        sp."VARIABLE" = 'post-market_close' 
        AND sp."DATE" BETWEEN '2024-01-01' AND '2024-06-30'
        AND sp."TICKER" IN ('AAPL', 'MSFT', 'GOOGL', 'AMZN', 'NVDA', 'TSLA', 'META')
    QUALIFY ROW_NUMBER() OVER (PARTITION BY sp."TICKER" ORDER BY sp."DATE" DESC NULLS LAST) = 1
)
SELECT
    fp."TICKER",
    ROUND(((lp."last_price" - fp."first_price") / fp."first_price") * 100, 4) AS "percentage_change"
FROM First_Prices fp
JOIN Last_Prices lp ON fp."TICKER" = lp."TICKER";