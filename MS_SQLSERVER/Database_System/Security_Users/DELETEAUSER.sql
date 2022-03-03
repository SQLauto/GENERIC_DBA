USE [master]
GO

DROP LOGIN yourloginhere
GO

EXECUTE master.sys.sp_MSforeachdb 
	'USE [?]; 
    DECLARE @Tsql NVARCHAR(MAX)
    SET @Tsql = ''''

    SELECT @Tsql = ''DROP USER '' + d.name
    FROM sys.database_principals d
    JOIN master.sys.server_principals s
        ON s.sid = d.sid
    WHERE s.name = ''yourloginhere''
 
    EXEC (@Tsql)

'
GO


