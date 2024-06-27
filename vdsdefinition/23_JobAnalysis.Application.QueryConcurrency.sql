CREATE OR REPLACE VDS 
JobAnalysis.Application.QueryConcurrency 
AS 
SELECT 
  this.job_id AS thisQueryId, 
  this.queryText as thisQueryText, 
  this.startTime AS thisStartTime, 
  this.finishTime AS thisFinishTime, 
  others.job_id as otherQueryId, 
  others.startTime AS otherStartTime, 
  others.FinishTime AS otherFinishTime, 
  CASE WHEN others.StartTime < this.startTime AND others.finishTime > this.finishTime THEN 'Other Started Before This and Finished After This' 
    WHEN others.StartTime < this.startTime AND others.finishTime <= this.finishTime THEN 'Other Started Before This and Finished During This' 
    WHEN others.StartTime >= this.startTime AND others.finishTime <= this.FinishTime THEN 'Other Ran During This' 
    WHEN others.StartTime >= this.startTime AND others.finishTime > this.FinishTime THEN 'Other Started During This and Finished After This' 
  END AS relation 
FROM JobAnalysis.Business.SelectQueryData this LEFT OUTER JOIN 
  JobAnalysis.Business.SelectQueryData others 
ON (others.startTime < this.startTime  AND others.FinishTime > this.StartTime) OR 
    (others.StartTime >= this.startTime AND others.startTime <= this.FinishTime) 
AND this.job_id != others.job_id 
AND this."status" IN ('COMPLETED', 'FAILED', 'CANCELED')