WITH stats AS (
    SELECT
        AVG("loss_rate_%") AS "Average_Loss_Rate",
        STDDEV("loss_rate_%") AS "Stddev_Loss_Rate"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF"
    WHERE
        "loss_rate_%" IS NOT NULL AND "loss_rate_%" != 0
)
SELECT
    ROUND(MAX(stats."Average_Loss_Rate"), 4) AS "Average_Loss_Rate",
    COUNT(
        CASE
            WHEN v."loss_rate_%" < stats."Average_Loss_Rate" - stats."Stddev_Loss_Rate" THEN 1
            ELSE NULL
        END
    ) AS "Count_Below_One_Std_Dev",
    COUNT(
        CASE
            WHEN v."loss_rate_%" BETWEEN stats."Average_Loss_Rate" - stats."Stddev_Loss_Rate" AND stats."Average_Loss_Rate" + stats."Stddev_Loss_Rate" THEN 1
            ELSE NULL
        END
    ) AS "Count_Within_One_Std_Dev",
    COUNT(
        CASE
            WHEN v."loss_rate_%" > stats."Average_Loss_Rate" + stats."Stddev_Loss_Rate" THEN 1
            ELSE NULL
        END
    ) AS "Count_Above_One_Std_Dev"
FROM
    "BANK_SALES_TRADING"."BANK_SALES_TRADING"."VEG_LOSS_RATE_DF" v
CROSS JOIN
    stats
WHERE
    v."loss_rate_%" IS NOT NULL AND v."loss_rate_%" != 0;