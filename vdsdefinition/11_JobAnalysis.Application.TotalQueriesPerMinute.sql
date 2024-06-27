CREATE OR REPLACE VDS 
JobAnalysis.Application.TotalQueriesPerMinute  
AS 
SELECT 
    DATE_TRUNC('minute', startTime) AS startMinute, 
    COUNT(*) AS queriesPerMinute 
FROM JobAnalysis.Business.SelectQueryData 
GROUP BY startMinute 
ORDER BY startMinute ASC