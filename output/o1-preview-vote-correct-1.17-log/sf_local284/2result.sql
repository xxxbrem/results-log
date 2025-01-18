WITH stats AS (
    SELECT
        AVG("loss_rate_%") AS avg_loss_rate,
        STDDEV_SAMP("loss_rate_%") AS stddev_loss_rate
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF"
),
categorized AS (
    SELECT
        CASE
            WHEN "loss_rate_%" < (stats.avg_loss_rate - stats.stddev_loss_rate) THEN 'Below_one_standard_deviation'
            WHEN "loss_rate_%" > (stats.avg_loss_rate + stats.stddev_loss_rate) THEN 'Above_one_standard_deviation'
            ELSE 'Within_one_standard_deviation'
        END AS Category
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF"
    CROSS JOIN stats
),
counts AS (
    SELECT Category, COUNT(*) AS Count_Of_Items
    FROM categorized
    GROUP BY Category
),
final_result AS (
    SELECT 0 AS ordering, 'Average_Loss_Rate' AS Category, ROUND(stats.avg_loss_rate, 4) AS Value
    FROM stats
    UNION ALL
    SELECT 
        CASE Category
            WHEN 'Below_one_standard_deviation' THEN 1
            WHEN 'Within_one_standard_deviation' THEN 2
            WHEN 'Above_one_standard_deviation' THEN 3
        END AS ordering,
        Category,
        Count_Of_Items::FLOAT AS Value
    FROM counts
)
SELECT Category, Value
FROM final_result
ORDER BY ordering;