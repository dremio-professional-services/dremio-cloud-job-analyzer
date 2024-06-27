CREATE OR REPLACE VDS 
JobAnalysis.Application.AcceleratedSelects 
AS 
SELECT * FROM JobAnalysis.Business.SelectQueryData 
WHERE accelerated = true