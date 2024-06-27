CREATE OR REPLACE VDS 
JobAnalysis.Application.PctEngineUsageAllStartedQueries  
AS 
SELECT 
    engine, 
    COUNT("engine") AS numQueriesPerEngine, 
    CAST(COUNT("engine")*100 AS FLOAT) / 
        (SELECT COUNT(*) FROM JobAnalysis.Business.SelectQueryData 
         WHERE "status" IN ('COMPLETED', 'FAILED', 'CANCELED') 
         AND queryType IN ('UI_RUN', 'JDBC', 'ODBC')  -- might be others e.g. FLIGHT, REST 
         AND executionTimeMS IS NOT NULL 
         AND plannerEstimatedCost > 10)  AS pctQueriesPerEngine
FROM JobAnalysis.Business.SelectQueryData 
WHERE "status" IN ('COMPLETED', 'FAILED', 'CANCELED') 
AND queryType IN ('UI_RUN', 'JDBC', 'ODBC')  -- might be others e.g. FLIGHT, REST 
AND executionTimeMS IS NOT NULL 
AND plannerEstimatedCost > 10 
GROUP BY engine