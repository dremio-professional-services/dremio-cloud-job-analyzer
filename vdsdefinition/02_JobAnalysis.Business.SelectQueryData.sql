CREATE OR REPLACE VDS 
JobAnalysis.Business.SelectQueryData 
AS 
--SELECT * FROM jobs
SELECT 
    job_id, --queryId, 
    query /*queryTextFirstChunk*/ AS queryText, 
	query_chunks AS additionalQueryChunks, 
    planner_estimated_cost AS plannerEstimatedCost, --queryCost, 
	CAST(16000 AS INTEGER) queryChunkSizeBytes, 
	1 + array_length(query_chunks) as nrQueryChunks, 
    submitted_ts AS startTime, 
    final_state_ts AS finishTime, 
    CAST(total_duration_ms/60000.000 AS DECIMAL(10,3)) AS totalDurationMinutes, 
    CAST(total_duration_ms/1000.000 AS DECIMAL(10,3)) AS totalDurationSeconds, 
    total_duration_ms AS "totalDurationMS", 
    status, --outcome 
    error_msg AS errorMessage, 
    user_name AS username, 
    query_type AS queryType, 
    queried_datasets AS queriedDatasets, --parentsList, 
    scanned_datasets AS scannedDatasets, 
    queue_name AS queueName, 
    engine, 
    execution_nodes as executionNodes, 
    attempt_count AS attemptCount, 
    execution_cpu_time_ns AS executionCPUTimeNS, 
    memory_available AS memoryAvailable, 
	submitted_ts,
	attempt_started_ts,
	metadata_retrieval_ts,
	planning_start_ts,
	query_enqueued_ts,
	engine_start_ts,
	execution_planning_start_ts,
	starting_ts,
	execution_start_ts,
	final_state_ts,
	submitted_epoch,
	attempt_started_epoch,
	metadata_retrieval_epoch,
	planning_start_epoch,
	query_enqueued_epoch,
	engine_start_epoch,
	execution_planning_start_epoch,
	starting_epoch,
	execution_start_epoch,
	final_state_epoch,
    (attempt_started_epoch - submitted_epoch) / 1000000 AS pendingTimeMS,
	CASE WHEN metadata_retrieval_epoch = 0 THEN 0 
		ELSE ((metadata_retrieval_epoch - attempt_started_epoch) / 1000000) 
	END AS metadataRetrievalTimeMS,
    CASE WHEN planning_start_epoch = 0 OR (engine_start_epoch = 0 AND query_enqueued_epoch = 0) THEN 0
		WHEN engine_start_epoch = 0 THEN ((query_enqueued_epoch - planning_start_epoch) / 1000000) 
		ELSE ((engine_start_epoch - planning_start_epoch) / 1000000) 
	END AS planningTimeMS,
	CASE WHEN engine_start_epoch = 0 OR query_enqueued_epoch = 0 THEN 0
		ELSE ((query_enqueued_epoch - engine_start_epoch) / 1000000) 
	END AS engineStartMS,
	CASE WHEN query_enqueued_epoch = 0 OR execution_planning_start_epoch = 0 THEN 0
		ELSE ((execution_planning_start_epoch - query_enqueued_epoch) / 1000000) 
	END AS enqueuedTimeMS,
	CASE WHEN starting_epoch = 0 OR execution_planning_start_epoch = 0 THEN 0 
		ELSE ((starting_epoch - execution_planning_start_epoch) / 1000000) 
	END AS executionPlanningTimeMS, 
	CASE WHEN execution_start_epoch = 0 OR starting_epoch = 0 THEN 0 
		ELSE ((execution_start_epoch - starting_epoch) / 1000000) 
	END AS startingTimeMS,
    CASE WHEN final_state_epoch = 0 OR execution_start_epoch = 0 THEN 0 
		ELSE ((final_state_epoch - execution_start_epoch) / 1000000) 
	END AS executionTimeMS,
    accelerated, 
    reflection_matches AS reflectionMatches, 
    rows_scanned AS rowsScanned, --inputRecords, 
    bytes_scanned AS bytesScanned, --inputBytes, 
    rows_returned AS rowsReturned, --outputRecords, 
    bytes_returned AS bytesReturned, --outputBytes, 
    CONCAT('https://app.dremio.cloud/job/', "job_id") AS "profileUrl" 
FROM JobAnalysis.Preparation.Jobs AS jobs 
-- We only want select statements 
WHERE SUBSTR(UPPER("query"), STRPOS(UPPER("query"), 'SELECT')) LIKE 'SELECT%'
AND UPPER("query") NOT LIKE 'CREATE TABLE%'
