CREATE OR REPLACE VDS 
JobAnalysis.Application.QueryConcurrencyCount 
AS 
SELECT 
  thisQueryId, 
  count(thisQueryId) AS concurrency 
FROM JobAnalysis.Application.QueryConcurrency 
GROUP BY thisQueryId 
ORDER BY concurrency desc