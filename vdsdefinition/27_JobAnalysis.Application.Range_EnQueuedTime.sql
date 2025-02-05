CREATE OR REPLACE VDS 
JobAnalysis.Application.Range_EnQueuedTime 
AS 
WITH "T1" AS (SELECT CASE WHEN "enqueuedTimeMS" <= 1000 THEN 'R00 < 1000ms  i.e Less than 1 sec' 
                          WHEN "enqueuedTimeMS" <= 10000 THEN 'R01 < 10000ms i.e Less than 10 secs' 
                          WHEN "enqueuedTimeMS" <= 60000 THEN 'R02 < 60000ms i.e. Less than 60 secs' 
                          WHEN "enqueuedTimeMS" <= 120000 THEN 'R03 < 120000ms i.e. Less than 2 minutes' 
                          WHEN "enqueuedTimeMS" <= 180000 THEN 'R04 < 180000ms i.e. Less than 3 minutes' 
                          WHEN "enqueuedTimeMS" <= 300000 THEN 'R05 < 300000ms i.e. Less than 5 minutes' 
                          WHEN "enqueuedTimeMS" <= 600000 THEN 'R06 < 600000ms i.e. Less than 10 minutes' 
                          WHEN "enqueuedTimeMS" <= 1200000 THEN 'R07 < 1200000ms i.e. Less than 20 minutes' 
                          WHEN "enqueuedTimeMS" <= 1800000 THEN 'R08 < 1800000ms i.e. Less than 30 minutes' 
                          WHEN "enqueuedTimeMS" <= 3600000 THEN 'R09 < 1800000ms i.e. Less than 60 minutes (1 hour)' 
                          WHEN "enqueuedTimeMS" <= 5400000 THEN 'R10 < 5400000ms i.e. Less than 90 minutes (1-1/2 hours)' 
                          WHEN "enqueuedTimeMS" <= 7200000 THEN 'R11 < 7200000ms i.e. Less than 120 minutes(2 hours)' 
                          WHEN "enqueuedTimeMS" <= 10800000 THEN 'R12 < 10800000ms i.e. Less than 180 minutes(3 hours)' 
                          WHEN "enqueuedTimeMS" <= 14400000 THEN 'R13 < 14400000ms i.e. Less than 240 minutes(4 hours)' 
                          WHEN "enqueuedTimeMS" <= 18000000 THEN 'R14 < 18000000ms i.e. Less than 300 minutes(5 hours)' 
                          WHEN "enqueuedTimeMS" <= 21600000 THEN 'R15 < 21600000ms i.e. Less than 360 minutes(6 hours)' 
                          WHEN "enqueuedTimeMS" <= 25200000 THEN 'R16 < 25200000ms i.e. Less than 420 minutes(7 hours)' 
                          WHEN "enqueuedTimeMS" <= 28800000 THEN 'R17 < 28800000ms i.e. Less than 480 minutes(8 hours)' 
                          WHEN "enqueuedTimeMS" <= 32400000 THEN 'R18 < 32400000ms i.e. Less than 540 minutes(9 hours)' 
                          WHEN "enqueuedTimeMS" <= 36000000 THEN 'R19 < 36000000ms i.e. Less than 600 minutes(10 hours)' 
                          ELSE 'R20 > 36000000ms i.e. Greater than 600 minutes(10 hours)' END AS "RangeEnQueuedTime"
             FROM "JobAnalysis"."Business"."SelectQueryData"
            WHERE "enqueuedTimeMS" IS NOT NULL), 
       "T2" AS (SELECT SUM(1) AS "TotalQ" FROM "T1") 
(SELECT "RangeEnQueuedTime", COUNT(*) AS "querycount", CAST(COUNT(*) * 100.00 / "T2"."TotalQ" AS DECIMAL(5, 2)) AS "PerCentQs"
   FROM "T1", "T2"
GROUP BY "RangeEnQueuedTime", "T2"."TotalQ")
ORDER BY "RangeEnQueuedTime"
