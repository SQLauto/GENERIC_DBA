:SETVAR DBNAME "SharedData"

USE [$(DBNAME)];
GO

ALTER INDEX ALL
	ON dbo.Notifications
	REBUILD
	WITH (ONLINE = ON, FILLFACTOR = 80);
GO

USE [$(DBNAME)];
GO

EXEC sp_MSforeachtable 'UPDATE STATISTICS ? WITH FULLSCAN;';
GO

USE [$(DBNAME)];
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT	@sql += N'EXEC sp_refreshview ''' + [name] + N'''' + CHAR(10)
FROM	sys.objects
WHERE
	[type] IN ( 'V' );

EXEC (@sql);

USE [$(DBNAME)];
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT	@sql += N'EXEC sp_recompile ''' + [name] + N'''' + CHAR(10)
FROM	sys.objects
WHERE
	[type] IN ( 'P', 'FN', 'IF' );

EXEC (@sql);

USE $(DBNAME);
GO

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);

USE $(DBNAME);
GO

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);
