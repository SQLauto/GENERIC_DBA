DECLARE @db_name AS nvarchar(max)
DECLARE c_db_names CURSOR FOR
SELECT name
FROM sys.databases
WHERE name  IN(
'ReportServer'
, 'RSExecutionLog'
, 'Reporting')

OPEN c_db_names

FETCH c_db_names INTO @db_name

WHILE @@Fetch_Status = 0
BEGIN
  EXEC('
   USE ' + @db_name + ';

WITH CTE_tblsiz
AS (
	SELECT t.[object_id] AS TableObject
		, t.name AS TableName
		, SUM(s.used_page_count) AS used_pages_count
		, SUM(CASE 
				WHEN (i.index_id < 2)
					THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count
							)
				ELSE lob_used_page_count + row_overflow_used_page_count
				END) AS pages
	FROM sys.dm_db_partition_stats AS s
	INNER JOIN sys.tables AS t
		ON s.object_id = t.object_id
	INNER JOIN sys.indexes AS i
		ON i.[object_id] = t.[object_id]
			AND s.index_id = i.index_id
	WHERE lower(t.name) NOT LIKE ''%dt''
		AND (
			lower(t.name) NOT LIKE ''%sys%''
			AND lower(t.name) NOT LIKE ''%dba%''
			AND lower(t.name) NOT LIKE ''%temp%''
			AND lower(t.name) NOT LIKE ''%command%''
			AND lower(t.name) NOT LIKE ''%log%''
			AND lower(t.name) NOT LIKE ''%test%''
			)

	GROUP BY t.[object_id]
		, t.name
	)
	, CTE_tblrows
AS (
	SELECT DISTINCT ts.TableName AS TableName
		, p.rows AS RecordsPerTable
		, cast((ts.pages * 8.) / 1024 AS DECIMAL(10, 3)) AS TableSizeInMB
		, cast((
				(
					CASE 
						WHEN ts.used_pages_count > ts.pages
							THEN ts.used_pages_count - ts.pages
						ELSE 0
						END
					) * 8. / 1024
				) AS DECIMAL(10, 3)) AS IndexSizeInMB
	FROM CTE_tblsiz ts
	LEFT JOIN sys.partitions AS p
		ON ts.TableObject = p.[object_id]
	WHERE p.rows > 0
	)
	, CTE_TablePerc
AS (
	SELECT TableName
		, CAST((RecordsPerTable * 100) / (SUM(RecordsPerTable) OVER ()) AS 
			DECIMAL(24, 6)) AS [PercOfDbRows]
		, CAST((TableSizeInMB * 100) / (SUM(TableSizeInMB) OVER ()) AS 
			DECIMAL(24, 6)) AS [PercOfDbSize]
		, CAST((IndexSizeInMB * 100) / (SUM(IndexSizeInMB) OVER ()) AS 
			DECIMAL(24, 6)) AS [PercOfOverallIndexSize]
	FROM CTE_tblrows
	GROUP BY TableName
		, RecordsPerTable
		, TableSizeInMB
		, IndexSizeInMB
	)
	, CTE_rollup
AS (
	SELECT TableName AS TableName
		, SUM(RecordsPerTable) AS RecordsPerTable
		, SUM(TableSizeInMB) AS TableSizeInMB
		, SUM(IndexSizeInMB) AS IndexSizeInMB
	FROM CTE_tblrows
	GROUP BY TableName
	WITH ROLLUP
	)
    INSERT INTO Utility.[DBINFO].[DBTableSizes]
           ([DataBaseName]
           ,[TableName]
           ,[RecordsPerTable]
           ,[PercOfDbRows]
           ,[TableSizeInMB]
           ,[PercOfDbSize]
           ,[IndexSizeInMB]
           ,[PercOfOverallIndexSize]
         )

SELECT IIF(DB_NAME() = ''ReportServer'', ''ReportServer_sqlCN2'', DB_NAME()) AS DatabaseName
, COALESCE(r.TableName, ''Totals'') AS TableName
	, r.RecordsPerTable
	, p.PercOfDbRows
	, r.TableSizeInMB
	, p.PercOfDbSize
	, r.IndexSizeInMB
	, p.PercOfOverallIndexSize
FROM CTE_rollup r
LEFT JOIN CTE_TablePerc p
	ON r.TableName = p.TableName
ORDER BY IIF(p.TableName IS NULL, 1, 0)');



  FETCH c_db_names INTO @db_name
END

CLOSE c_db_names
DEALLOCATE c_db_names