CREATE OR REPLACE VDS 
JobAnalysis.Application.QueriesNotCompleted  
AS 
SELECT * FROM JobAnalysis.Business.SelectQueryData 
WHERE status NOT IN ('COMPLETED')