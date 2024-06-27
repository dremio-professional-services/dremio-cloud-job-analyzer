CREATE OR REPLACE VDS 
JobAnalysis.Application.SummaryEngineExecTimeByEngine 
AS 
WITH T1 AS
(SELECT engine, 
        1 as QueryCount , 
    case WHEN (coalesce(pendingTimeMS,0) <= 0) THEN 0
         ELSE 1 end WaitQuery,
    coalesce(enqueuedTimeMS,0)/1000 as QueueTimeSec,
    coalesce(executionTimeMS,0)/1000 as ExecTimeSec
FROM JobAnalysis.Business.SelectQueryData 
 where engine <> ''
  and status = 'COMPLETED'
)
SELECT engine, 
       SUM(QueryCount) as TotalQueryCount, 
       SUM(WaitQuery) as QueuedQueries, 
       (100 * SUM(WaitQuery)) / SUM(QueryCount) as PercentageQueued,
       Max(QueueTimeSec) as MaxQueueTimeSec, 
       Max(ExecTimeSec) as  MaxExecTimeSec,
       (Max(QueueTimeSec))/60 as MaxQueueTimeMinutes, 
       (Max(ExecTimeSec))/60 MaxExecTimeMinutes
FROM T1
group by engine order by 2 desc
