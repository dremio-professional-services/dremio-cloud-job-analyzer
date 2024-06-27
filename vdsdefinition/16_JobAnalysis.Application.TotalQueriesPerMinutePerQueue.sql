CREATE OR REPLACE VDS 
JobAnalysis.Application.TotalQueriesPerMinutePerQueue  
AS 
SELECT 
	DATE_TRUNC('minute', "startTime") AS "startMinute", 
	queueName, 
	COUNT(*) AS "queriesPerMinute" 
FROM "JobAnalysis"."Business"."SelectQueryData" 
where queueName != '' 
GROUP BY "startMinute", queueName 
ORDER BY queriesPerMinute desc, "startMinute"