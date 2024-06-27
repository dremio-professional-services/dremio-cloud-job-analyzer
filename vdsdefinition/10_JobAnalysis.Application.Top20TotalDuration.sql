CREATE OR REPLACE VDS 
JobAnalysis.Application.Top20TotalDuration  
AS 
SELECT * FROM JobAnalysis.Business.SelectQueryData 
ORDER BY totalDurationMS DESC 
LIMIT 20