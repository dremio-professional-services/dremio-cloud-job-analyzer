CREATE OR REPLACE VDS 
JobAnalysis.Application.Top20ExecutionTimes  
AS 
SELECT * FROM JobAnalysis.Business.SelectQueryData 
WHERE executionTimeMS IS NOT NULL 
ORDER BY executionTimeMS DESC 
LIMIT 20