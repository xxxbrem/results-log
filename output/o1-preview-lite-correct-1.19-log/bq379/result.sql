SELECT
  t.approvedSymbol AS Approved_Symbol
FROM
  `open-targets-prod.platform.targets` t
JOIN
  `open-targets-prod.platform.associationByOverallDirect` a ON t.id = a.targetId
CROSS JOIN
  (
    SELECT AVG(score) AS mean_score
    FROM `open-targets-prod.platform.associationByOverallDirect`
    WHERE diseaseId = 'EFO_0000676'
  ) avg_score
WHERE
  a.diseaseId = 'EFO_0000676'
ORDER BY
  ABS(a.score - avg_score.mean_score) ASC
LIMIT 1;