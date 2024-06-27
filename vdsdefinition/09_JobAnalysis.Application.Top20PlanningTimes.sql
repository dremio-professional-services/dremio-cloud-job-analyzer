CREATE OR REPLACE VDS 
JobAnalysis.Application.Top20PlanningTimes  
AS 
SELECT * FROM JobAnalysis.Business.SelectQueryData
WHERE planningTimeMS IS NOT NULL 
ORDER BY planningTimeMS DESC 
LIMIT 20