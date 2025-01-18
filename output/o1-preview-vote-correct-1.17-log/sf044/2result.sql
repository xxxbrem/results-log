WITH first_prices AS (
    SELECT
        p1."TICKER",
        p1."VALUE" AS first_price
    FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES p1
    WHERE
        p1."VARIABLE" = 'post-market_close' AND
        p1."DATE" = (
            SELECT MIN(p2."DATE")
            FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES p2
            WHERE
                p2."VARIABLE" = 'post-market_close' AND
                p2."DATE" >= '2024-01-01' AND
                p2."DATE" <= '2024-06-30' AND
                p2."TICKER" = p1."TICKER"
        ) AND
        p1."TICKER" IN ('META', 'GOOGL', 'AMZN', 'MSFT', 'AAPL', 'TSLA', 'NVDA')
),
last_prices AS (
    SELECT
        p1."TICKER",
        p1."VALUE" AS last_price
    FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES p1
    WHERE
        p1."VARIABLE" = 'post-market_close' AND
        p1."DATE" = (
            SELECT MAX(p2."DATE")
            FROM FINANCE__ECONOMICS.CYBERSYN.STOCK_PRICE_TIMESERIES p2
            WHERE
                p2."VARIABLE" = 'post-market_close' AND
                p2."DATE" >= '2024-01-01' AND
                p2."DATE" <= '2024-06-30' AND
                p2."TICKER" = p1."TICKER"
        ) AND
        p1."TICKER" IN ('META', 'GOOGL', 'AMZN', 'MSFT', 'AAPL', 'TSLA', 'NVDA')
)
SELECT
    f."TICKER" AS "Ticker",
    ROUND(((l.last_price - f.first_price) / f.first_price) * 100, 4) AS "PercentageChange"
FROM first_prices f
JOIN last_prices l ON f."TICKER" = l."TICKER";