CREATE OR REPLACE VDS 
JobAnalysis.Application.PctAccelerated  
AS 
SELECT 
	SUM(CASE WHEN "accelerated" = 'true' THEN 1 ELSE 0 END) AS "acceleratedCount", 
	SUM(CASE WHEN "accelerated" = 'true' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT) * 100 AS "pctAccelerated" 
FROM JobAnalysis.Business.SelectQueryData 
WHERE "status" = 'COMPLETED'