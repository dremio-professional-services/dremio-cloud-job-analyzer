CREATE OR REPLACE VDS 
JobAnalysis.Application.OverallWorkloadDistribution 
AS 
WITH t1 AS ( 
    SELECT 
    TO_DATE("attempt_started_ts") AS queryStartDate, 
    DATE_PART('hour', "attempt_started_ts") queryStartHour, 
    "attempt_started_epoch" / 1000000000 queryStartSecond, 
    COUNT(*) queriesPerSecond 
    FROM JobAnalysis.Preparation.Jobs 
    GROUP BY queryStartDate, queryStartHour, queryStartSecond 
    ) 
SELECT 
queryStartDate, 
queryStartHour, 
SUM(queriesPerSecond) queriesPerHour, 
MAX(queriesPerSecond) peakQueriesPerSecond 
FROM t1 
GROUP BY queryStartDate, queryStartHour 
ORDER BY queryStartDate DESC, queryStartHour