SELECT "model" AS "L1_model", COUNT(*) AS "Total_Count"
FROM "STACKING"."STACKING"."MODEL_SCORE"
GROUP BY "model"
ORDER BY "Total_Count" DESC NULLS LAST, "L1_model" ASC
LIMIT 1;