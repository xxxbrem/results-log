SELECT 
    "STATE_ABBREVIATION" AS "State",
    SUM(CASE WHEN "START_DATE" <= '2020-03-01' AND ("END_DATE" IS NULL OR "END_DATE" >= '2020-03-01') THEN 1 ELSE 0 END) AS "Num_Entities_Mar_1_2020",
    SUM(CASE WHEN "START_DATE" <= '2021-12-31' AND ("END_DATE" IS NULL OR "END_DATE" >= '2021-12-31') THEN 1 ELSE 0 END) AS "Num_Entities_Dec_31_2021",
    ROUND(
        (
            SUM(CASE WHEN "START_DATE" <= '2021-12-31' AND ("END_DATE" IS NULL OR "END_DATE" >= '2021-12-31') THEN 1 ELSE 0 END) -
            SUM(CASE WHEN "START_DATE" <= '2020-03-01' AND ("END_DATE" IS NULL OR "END_DATE" >= '2020-03-01') THEN 1 ELSE 0 END)
        ) * 100.0 / 
        NULLIF(SUM(CASE WHEN "START_DATE" <= '2020-03-01' AND ("END_DATE" IS NULL OR "END_DATE" >= '2020-03-01') THEN 1 ELSE 0 END), 0)
        ,
        4
    ) AS "Percentage_Change"
FROM "FINANCE__ECONOMICS"."CYBERSYN"."FINANCIAL_BRANCH_ENTITIES"
GROUP BY "STATE_ABBREVIATION";