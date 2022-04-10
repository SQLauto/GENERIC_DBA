
DBCC FREESYSTEMCACHE('ALL') WITH MARK_IN_USE_FOR_REMOVAL;

USE REPLACEWITHDBNAME;
GO

EXEC sys.sp_MSforeachtable 'UPDATE STATISTICS ? WITH FULLSCAN;';
GO
DBCC FREESYSTEMCACHE('ALL') WITH MARK_IN_USE_FOR_REMOVAL;

USE REPLACEWITHDBNAME;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT  @sql += N'EXEC sp_refreshview ' + N'''' + SCHEMA_NAME(schema_id) + N'.' + name + N'''' + CHAR(10) /*+ 'GO' + CHAR(13) --uncomment if need to print  */
FROM    sys.objects
WHERE   type IN ( 'V' );    

EXEC (@sql);

USE REPLACEWITHDBNAME;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT  @sql += N'EXEC sp_recompile ' + N'''' + SCHEMA_NAME(schema_id) + N'.' + name + N'''' + CHAR(10) /*+ 'GO' + CHAR(13) --uncomment if need to print  */
FROM    sys.objects
WHERE   type IN ( 'P', 'FN', 'IF' );

EXEC (@sql);



USE REPLACEWITHDBNAME;
GO

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);

USE REPLACEWITHDBNAME;
GO

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);
DBCC FREESYSTEMCACHE('ALL') WITH MARK_IN_USE_FOR_REMOVAL;


--EXEC sys.sp_depends @objname = N'tablename';
