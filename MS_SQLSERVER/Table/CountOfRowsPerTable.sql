-- Shows all user tables and row counts for the current database 
-- Remove is_ms_shipped = 0 check to include system objects 
-- i.index_id < 2 indicates clustered index (1) or hash table (0) 
SELECT o.name
	, ddps.row_count
FROM sys.indexes AS i
INNER JOIN sys.objects AS o
	ON i.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.dm_db_partition_stats AS ddps
	ON i.OBJECT_ID = ddps.OBJECT_ID
		AND i.index_id = ddps.index_id
WHERE i.index_id < 2
	AND o.is_ms_shipped = 0
	AND lower(o.name) LIKE '%pol%'
ORDER BY o.NAME
