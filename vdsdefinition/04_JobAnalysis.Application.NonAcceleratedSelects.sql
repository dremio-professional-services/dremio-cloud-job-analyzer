CREATE OR REPLACE VDS 
JobAnalysis.Application.NonAcceleratedSelects  
AS 
SELECT * FROM JobAnalysis.Business.SelectQueryData 
WHERE accelerated = FALSE 
AND totalDurationMS > 1000 
ORDER BY totalDurationMS DESC