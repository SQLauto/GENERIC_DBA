-- Variable Declarations
DECLARE @dtPreviousDate DATETIME;
DECLARE @strYear VARCHAR(4);
DECLARE @strMonth VARCHAR(2);
DECLARE @strMonthPre VARCHAR(2);
DECLARE @strDay VARCHAR(2);
DECLARE @strDayPre VARCHAR(2);
DECLARE @intFinalDate INT;

-- Initialize Variables
SET @dtPreviousDate = DATEADD(dd, -7, GETDATE()); -- Last 7 days 
SET @strYear = DATEPART(yyyy, @dtPreviousDate);

SELECT  @strMonthPre = CONVERT(VARCHAR(2), DATEPART(mm, @dtPreviousDate));

SELECT  @strMonth = RIGHT(CONVERT(VARCHAR, (@strMonthPre + 1000000000)), 2);

SELECT  @strDayPre = CONVERT(VARCHAR(2), DATEPART(dd, @dtPreviousDate));

SELECT  @strDay = RIGHT(CONVERT(VARCHAR, (@strDayPre + 1000000000)), 2);

SET @intFinalDate = CAST(@strYear + @strMonth + @strDay AS INT);

-- Final Logic
SELECT  j.[name]
      , s.step_name
      , h.step_id
      , h.step_name
      , h.run_date
      , h.run_time
      , h.sql_severity
      , h.message
      , h.server
FROM    msdb.dbo.sysjobhistory h
    INNER JOIN
    msdb.dbo.sysjobs j
       ON h.job_id = j.job_id
    INNER JOIN
    msdb.dbo.sysjobsteps s
       ON j.job_id = s.job_id
          AND   h.step_id = s.step_id
WHERE   h.run_status = 0 -- Failure
        AND h.run_date > @intFinalDate
ORDER BY h.instance_id DESC;
