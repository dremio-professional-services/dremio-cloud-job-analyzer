CREATE OR REPLACE VDS 
JobAnalysis.Application.MostUsedDatasetsPerDay 
AS 
SELECT 
    queryStartDate, 
    dataset, 
    COUNT(*) totalQueries, 
    COUNT(DISTINCT username) totalUsers 
FROM ( 
    SELECT queryStartDate, CAST(convert_from(convert_to(dataset, 'JSON'), 'UTF8') as VARCHAR) AS dataset, username 
    FROM ( 
        SELECT TO_DATE("attempt_started_ts") AS queryStartDate, FLATTEN("queried_datasets") AS dataset, user_name as username 
        FROM JobAnalysis.Preparation.Jobs 
    ) nested_0 
) RawFlattenDataset 
GROUP BY dataset, queryStartDate 
ORDER BY queryStartDate DESC, totalQueries DESC