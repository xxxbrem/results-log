WITH stats AS (
    SELECT 
        AVG("loss_rate_%") AS avg_loss_rate, 
        STDDEV("loss_rate_%") AS std_loss_rate
    FROM 
        BANK_SALES_TRADING.BANK_SALES_TRADING.VEG_LOSS_RATE_DF
    WHERE 
        "loss_rate_%" IS NOT NULL
),
item_categories AS (
    SELECT
        "item_code",
        "loss_rate_%",
        CASE
            WHEN "loss_rate_%" < stats.avg_loss_rate - stats.std_loss_rate THEN 'Below'
            WHEN "loss_rate_%" > stats.avg_loss_rate + stats.std_loss_rate THEN 'Above'
            ELSE 'Within'
        END AS category
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.VEG_LOSS_RATE_DF
        CROSS JOIN stats
    WHERE 
        "loss_rate_%" IS NOT NULL
)
SELECT
    CAST((SELECT avg_loss_rate FROM stats) AS DECIMAL(10,4)) AS "Average_Loss_Rate(%)",
    SUM(CASE WHEN category = 'Below' THEN 1 ELSE 0 END) AS "Items_Below_One_Std_Dev",
    SUM(CASE WHEN category = 'Within' THEN 1 ELSE 0 END) AS "Items_Within_One_Std_Dev",
    SUM(CASE WHEN category = 'Above' THEN 1 ELSE 0 END) AS "Items_Above_One_Std_Dev"
FROM
    item_categories;