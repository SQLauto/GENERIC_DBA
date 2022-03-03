vUSE tempdb;
GO

IF (OBJECT_ID('tempdb.dbo.#t_ObjectsOfInterest', 'U') IS NOT NULL)
DROP TABLE IF exists #t_ObjectsOfInterest
BEGIN
	CREATE TABLE #t_ObjectsOfInterest
	(
		DBName NVARCHAR(128)
	  , ObjectName NVARCHAR(128)
	  , Definition NVARCHAR(MAX)
	  , ObjectType CHAR(2)
	);
END;

EXECUTE dbo.sp_MSforeachdb @command1 = 'IF ''?''  IN(''mapbenefits'', ''Utility'', ''Archival'', ''CustomLog'') BEGIN
    USE [?];

    INSERT  INTO #t_ObjectsOfInterest ( [DBName], [ObjectName], [Definition], [ObjectType] )
    SELECT  DB_NAME(), OBJECT_NAME( sm.object_id ), sm.definition, o.type
    FROM    sys.sql_modules sm
	JOIN sys.objects AS o ON sm.object_id = o.object_id  
  ;
	END';
GO

DECLARE @charHardReturn CHAR(2) = CONCAT(CHAR(10), CHAR(13));

SELECT	CASE
			WHEN ObjectType = 'V' THEN CONCAT('EXEC sp_refreshview ', '''', ObjectName, '''', ';', @charHardReturn)
			ELSE CONCAT('EXEC sp_recompile ', '''', ObjectName, '''', ';', @charHardReturn)
		END AS "Command"
FROM	#t_ObjectsOfInterest
WHERE	DBName IN 'Mapbenefits, Utility, Archival';
GO

--DROP TABLE #t_ObjectsOfInterest;