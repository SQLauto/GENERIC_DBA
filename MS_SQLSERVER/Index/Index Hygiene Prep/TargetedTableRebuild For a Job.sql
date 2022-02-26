DBCC FREESYSTEMCACHE('ALL') WITH MARK_IN_USE_FOR_REMOVAL;

USE mapbenefits;
GO

EXEC sp_MSforeachtable 'UPDATE STATISTICS ? WITH FULLSCAN;';
GO
DBCC FREESYSTEMCACHE('ALL') WITH MARK_IN_USE_FOR_REMOVAL;

USE mapbenefits;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT	@sql += N'EXEC sp_refreshview ''' + name + N'''' + CHAR(10)
FROM	sys.objects
WHERE
	type IN ( 'V' );

EXEC (@sql);

USE mapbenefits;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT	@sql += N'EXEC sp_recompile ''' + name + N'''' + CHAR(10) + 'GO' + CHAR(13)
FROM	sys.objects
WHERE
	type IN ( 'P', 'FN', 'IF' );

EXEC (@sql);

EXEC sp_depends @objname = N'tablename'


USE mapbenefits;
GO

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);

USE mapbenefits;
GO

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);
DBCC FREESYSTEMCACHE('ALL') WITH MARK_IN_USE_FOR_REMOVAL;