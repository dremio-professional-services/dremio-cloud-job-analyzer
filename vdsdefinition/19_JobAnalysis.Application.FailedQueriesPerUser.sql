CREATE OR REPLACE VDS 
JobAnalysis.Application.FailedQueriesPerUser 
AS 
SELECT 
    TO_DATE("startTime") queryStartDate, 
    username, 
    COUNT(*) failedQueries
FROM JobAnalysis.Business.SelectQueryData
WHERE status = 'FAILED'
GROUP BY username, queryStartDate
ORDER BY queryStartDate DESC, failedQueries DESC