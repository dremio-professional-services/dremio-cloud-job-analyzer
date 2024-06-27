CREATE OR REPLACE VDS 
JobAnalysis.Application.QueryCostVsExecutionTime  
AS 
SELECT job_id, queryText, executionTimeMS, plannerEstimatedCost, accelerated 
FROM JobAnalysis.Business.SelectQueryData 
WHERE queryType IN ('UI_RUN', 'ODBC', 'JDBC') -- might be others e.g. FLIGHT, REST
AND status = 'COMPLETED' 