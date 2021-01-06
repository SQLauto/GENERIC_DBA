DECLARE @intErrorLogCount INT
DECLARE @dateLastLogRecord DATETIME
DECLARE @tblErrorLogMetaData TABLE (
	LogDate DATETIME
	, ProcessInfo NVARCHAR(50)
	, [Text] NVARCHAR(MAX)
	)
DECLARE @tblCredentialErrorLogs TABLE (
	[Archive#] INT
	, [Date] DATETIME
	, LogFileSizeMB INT
	)

INSERT INTO @tblCredentialErrorLogs
EXEC sp_enumerrorlogs  --if the sp literally has 'sp' as a prefix you can mostly always insert into a TV or a TT like this...mostly always....👽

SELECT @intErrorLogCount = MIN([Archive#])
	, @dateLastLogRecord = MAX([Date])
FROM @tblCredentialErrorLogs


WHILE @intErrorLogCount IS NOT NULL
BEGIN
	INSERT INTO @tblErrorLogMetaData
	EXEC sp_readerrorlog @intErrorLogCount

	SELECT @intErrorLogCount = MIN([Archive#])
		, @dateLastLogRecord = MAX([Date])
	FROM @tblCredentialErrorLogs
	WHERE [Archive#] > @intErrorLogCount
		AND @dateLastLogRecord > getdate() - 360
END

-- List all last week failed logins count of attempts and the Login failure message
SELECT COUNT(TEXT) AS NumberOfAttempts
	, TEXT AS Details
	, MIN(LogDate) AS MinLogDate
	, MAX(LogDate) AS MaxLogDate
FROM @tblErrorLogMetaData
WHERE ProcessInfo = 'Logon'
	AND TEXT LIKE '%fail%'
	AND LogDate > getdate() - 360
GROUP BY TEXT
ORDER BY NumberOfAttempts DESC
