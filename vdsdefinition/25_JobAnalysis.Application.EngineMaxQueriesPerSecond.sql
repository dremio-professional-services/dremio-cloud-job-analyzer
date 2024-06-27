CREATE OR REPLACE VDS 
JobAnalysis.Application.EngineMaxQueriesPerSecond 
AS 
SELECT qc.engine, MAX(qc.queriesPerSecond) maxQPS 
FROM 
    (SELECT engine, "DATE_TRUNC"('second', "startTime") AS "startSecond", COUNT(*) AS "queriesPerSecond" 
    FROM "JobAnalysis"."Business"."SelectQueryData" 
    WHERE engine != '' and engine != 'preview' 
    GROUP BY engine, "startSecond" 
    ORDER BY engine, "startSecond") qc 
GROUP by qc.engine 