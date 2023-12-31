-------------------------------------------------
-- NAME:	 PERF-AU-01-counts-by-hour.txt
-------------------------------------------------
-- DESCRIPTION:
--	VARIOUS SQL TO SLICE 'N DICE REQUEST COUNTS
--
-- OUTPUT:
--	UNDERSTANDING VOLUME OF STATEMENT TYPES BY VARIOUS VIEWS
--
-- NEXT STEPS:
--	LOOK FOR OUTLIERS TO NARROW PERFORMANCE ANALYSIS TO DISCOVER ISSUE
--
-- OPTIONS:
--	NARROW ANALYSIS BASED ON A TIMEFRAMES VOLUME OF REQUESTS
--	NARROW ANALYSIS BASED ON STATEMENT TYPE VOLUME OF REQUESTS
--	DRILLDOWN TO WAREHOUSE LEVEL FOR SAME INSIGHTS
--
-- REVISION HISTORY
-- DATE		INIT	DESCRIPTION
----------  ----    -----------
-- 18JAN22	WNA		CREATED/UPDATED FOR REPOSITORY
-------------------------------------------------
	
--------------------------------------
-- ACCOUNT HOUR REQUEST COUNTS
--
-- DETERMINE ACCOUNT TO DRILL DOWN ON
-- SET ACCOUNT_NAME WITH THAT ACCOUNT FOR NEXT QUERY
--------------------------------------
SELECT
    TO_CHAR(MONTH(START_TIME),'00')||
    TO_CHAR(DAY(START_TIME),'00')||
    TO_CHAR(HOUR(START_TIME),'00') AS DAY_HOUR,
    $ACCOUNT_NAME AS ACCOUNT_NAME,
    COUNT(*)
FROM
    TABLE($QUERY_HISTORY)
WHERE
    START_TIME BETWEEN $TS_START AND $TS_END
GROUP BY
    1
HAVING COUNT(*)>1000
ORDER BY
    1
;


--------------------------------------
-- ACCOUNT WH HOUR REQUEST COUNTS
--
-- DETERMINE WAREHOUSE TO DRILL DOWN ON
-- CREATE IN LIST FOR NEXT QUERY
--------------------------------------

SELECT
    TO_CHAR(MONTH(START_TIME),'00')||
    TO_CHAR(DAY(START_TIME),'00')||
    TO_CHAR(HOUR(START_TIME),'00') AS DAY_HOUR,
    WAREHOUSE_NAME,
    COUNT(*)
FROM
    TABLE($QUERY_HISTORY)
WHERE
    START_TIME BETWEEN $TS_START AND $TS_END
GROUP BY
    1,2
HAVING COUNT(*)>1000
ORDER BY
    1,2
;


--------------------------------------
-- ACCOUNT WH USER HOUR REQUEST COUNTS
--------------------------------------
SELECT
    TO_CHAR(MONTH(START_TIME),'00')||
    TO_CHAR(DAY(START_TIME),'00')||
    TO_CHAR(HOUR(START_TIME),'00') AS DAY_HOUR,
    WAREHOUSE_NAME||'~'||USER_NAME AS WH_USER,
    COUNT(*)
FROM
    TABLE($QUERY_HISTORY)
WHERE
    START_TIME BETWEEN $TS_START AND $TS_END AND
    WAREHOUSE_NAME = $WAREHOUSE_NAME
GROUP BY
    1,2
ORDER BY
    1,2
;