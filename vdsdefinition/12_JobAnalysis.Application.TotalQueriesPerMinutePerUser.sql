CREATE OR REPLACE VDS 
JobAnalysis.Application.TotalQueriesPerMinutePerUser  
AS 
SELECT 
    DATE_TRUNC('minute', startTime) AS startMinute, 
    username, 
    status, 
    COUNT(*) AS queriesPerMinute 
FROM JobAnalysis.Business.SelectQueryData 
GROUP BY startMinute, username, status 
ORDER BY startMinute, username, status ASC