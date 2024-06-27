CREATE OR REPLACE VDS 
JobAnalysis.Application.TotalQueriesStartedPerSecond  
AS 
SELECT 
	DATE_TRUNC('second', "startTime") AS "startSecond", 
	COUNT(*) AS "queriesPerSecond" 
FROM "JobAnalysis"."Business"."SelectQueryData" 
GROUP BY "startSecond" 
ORDER BY "startSecond"