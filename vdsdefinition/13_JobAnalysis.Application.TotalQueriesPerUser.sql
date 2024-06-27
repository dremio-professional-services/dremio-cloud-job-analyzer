CREATE OR REPLACE VDS 
JobAnalysis.Application.TotalQueriesPerUser  
AS 
SELECT username, status, COUNT(status) as countQueries 
FROM JobAnalysis.Business.SelectQueryData 
GROUP BY username, status 
ORDER BY username, status