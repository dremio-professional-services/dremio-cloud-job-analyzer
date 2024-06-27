CREATE OR REPLACE VDS 
JobAnalysis.Preparation.Jobs 
AS 
--SELECT 
--    *, 
--    CASE WHEN "final_state_epoch" = 0 THEN 0 ELSE (("final_state_epoch" - "submitted_epoch") / 1000000) END AS "total_duration_ms",  
--FROM sys.project.history.jobs

SELECT * FROM (
    SELECT 
        *, 
        CASE WHEN "final_state_epoch" = 0 THEN 0 ELSE (("final_state_epoch" - "submitted_epoch") / 1000000) END AS "total_duration_ms", 
        ROW_NUMBER() OVER (PARTITION BY job_id) as RN 
    FROM "sys"."project"."history"."jobs") a 
WHERE a.RN = 1