WITH valid_loss_rates AS (
    SELECT
        "item_name",
        ROUND(TRY_TO_DOUBLE("loss_rate_%"), 4) AS loss_rate_float
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF"
    WHERE TRIM("loss_rate_%") <> ''
      AND TRY_TO_DOUBLE("loss_rate_%") IS NOT NULL
),
stats AS (
    SELECT
        AVG(loss_rate_float) AS avg_loss_rate,
        STDDEV(loss_rate_float) AS stddev_loss_rate
    FROM valid_loss_rates
),
categorized_items AS (
    SELECT
        vlr."item_name",
        vlr.loss_rate_float,
        CASE
            WHEN vlr.loss_rate_float < stats.avg_loss_rate - stats.stddev_loss_rate THEN 'Below one standard deviation'
            WHEN vlr.loss_rate_float > stats.avg_loss_rate + stats.stddev_loss_rate THEN 'Above one standard deviation'
            ELSE 'Within one standard deviation'
        END AS category
    FROM valid_loss_rates vlr CROSS JOIN stats
)
SELECT
    category AS "Category",
    COUNT(*) AS "Count"
FROM
    categorized_items
GROUP BY
    category
ORDER BY
    CASE category
        WHEN 'Below one standard deviation' THEN 1
        WHEN 'Within one standard deviation' THEN 2
        WHEN 'Above one standard deviation' THEN 3
        ELSE 4
    END;