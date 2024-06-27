CREATE OR REPLACE VDS 
JobAnalysis.Application.Top20DataSetsQueried   
AS 
SELECT 
    dataSet, 
    dataSetType, 
    COUNT(*) AS countTimesQueried 
FROM ( 
    SELECT  
        nested_0.parentsList.name AS dataSet, 
        nested_0.parentsList."type" AS dataSetType 
    FROM ( 
        SELECT FLATTEN(queriedDatasets) as parentsList  
        FROM JobAnalysis.Business.SelectQueryData 
        WHERE queriedDatasets IS NOT NULL 
        AND queryType IN ('ODBC', 'JDBC', 'UI_RUN')  -- might be others e.g. FLIGHT, REST
     ) nested_0 
) nested_1 
GROUP BY dataSet, dataSetType 
ORDER BY countTimesQueried DESC 
LIMIT 20