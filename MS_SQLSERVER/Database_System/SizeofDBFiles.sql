CREATE TABLE #FileSize (
	dbName NVARCHAR(128)
	, FileName NVARCHAR(128)
	, type_desc NVARCHAR(128)
	, CurrentSizeMB DECIMAL(10, 2)
	, FreeSpaceMB DECIMAL(10, 2)
	);

INSERT INTO #FileSize (
	dbName
	, FileName
	, type_desc
	, CurrentSizeMB
	, FreeSpaceMB
	)
EXEC sp_msforeachdb 
	'use [?]; 
 SELECT DB_NAME() AS DbName, 
        name AS FileName, 
        type_desc,
        size/128.0 AS CurrentSizeMB,  
        size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 AS FreeSpaceMB
FROM sys.database_files
WHERE type IN (0,1);'
	;

SELECT *
FROM #FileSize
WHERE dbName NOT IN ('distribution', 'master', 'model', 'msdb')

--AND FreeSpaceMB < 100 ;
DROP TABLE #FileSize;




-- Review file properties, including file_id values to reference in shrink commands
SELECT file_id,
       name,
       CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8 / 1024 /1024. AS space_used_gb,
       CAST(size AS bigint) * 8 / 1024/1024. AS space_allocated_gb,
       CAST(max_size AS bigint) * 8 / 1024/1024. AS max_size_gb
FROM sys.database_files
WHERE type_desc IN ('ROWS','LOG');
GO





;WITH GetSizeTotals AS (-- Review file properties, including file_id values to reference in shrink commands
SELECT file_id AS FileID,
       name AS FileName,
       CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8 / 1024 /1024. AS space_used_gb,
       CAST(size AS bigint) * 8 / 1024/1024. AS space_allocated_gb,
       CAST(max_size AS bigint) * 8 / 1024/1024. AS max_size_gb
FROM sys.database_files
WHERE type_desc IN ('ROWS','LOG')
)
SELECT	FileName
		, SUM(gst.space_used_gb) AS UsedSpace
		, SUM(gst.space_allocated_gb) AS AllocatedSpace
		, SUM(gst.max_size_gb) AS MaxSize
FROM GetSizeTotals AS gst
GROUP BY FileName WITH ROLLUP