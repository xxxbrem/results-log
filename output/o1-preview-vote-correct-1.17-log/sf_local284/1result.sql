SELECT
    ROUND(avg_stats."Average_Loss_Rate", 4) AS "Average_Loss_Rate",
    COUNT(CASE WHEN v."loss_rate_%" < avg_stats."Average_Loss_Rate" - avg_stats."Loss_Rate_StdDev" THEN 1 END) AS "Items_Below_One_SD",
    COUNT(CASE WHEN v."loss_rate_%" BETWEEN avg_stats."Average_Loss_Rate" - avg_stats."Loss_Rate_StdDev" AND avg_stats."Average_Loss_Rate" + avg_stats."Loss_Rate_StdDev" THEN 1 END) AS "Items_Within_One_SD",
    COUNT(CASE WHEN v."loss_rate_%" > avg_stats."Average_Loss_Rate" + avg_stats."Loss_Rate_StdDev" THEN 1 END) AS "Items_Above_One_SD"
FROM
    "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF" v
    CROSS JOIN
    (
        SELECT
            AVG("loss_rate_%") AS "Average_Loss_Rate",
            STDDEV("loss_rate_%") AS "Loss_Rate_StdDev"
        FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF"
        WHERE "loss_rate_%" IS NOT NULL
    ) avg_stats
WHERE v."loss_rate_%" IS NOT NULL
GROUP BY avg_stats."Average_Loss_Rate", avg_stats."Loss_Rate_StdDev";