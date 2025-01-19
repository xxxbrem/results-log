WITH stats AS (
    SELECT
        AVG("loss_rate_%") AS avg_loss_rate,
        STDDEV("loss_rate_%") AS sd_loss_rate
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF"
)
SELECT
    ROUND(stats.avg_loss_rate, 4) AS "Average_loss_rate",
    (SELECT COUNT(*) 
     FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF" v 
     WHERE v."loss_rate_%" < stats.avg_loss_rate - stats.sd_loss_rate) AS "Items_below_one_SD",
    (SELECT COUNT(*) 
     FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF" v 
     WHERE v."loss_rate_%" BETWEEN stats.avg_loss_rate - stats.sd_loss_rate AND stats.avg_loss_rate + stats.sd_loss_rate) AS "Items_within_one_SD",
    (SELECT COUNT(*) 
     FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF" v 
     WHERE v."loss_rate_%" > stats.avg_loss_rate + stats.sd_loss_rate) AS "Items_above_one_SD"
FROM
    stats;