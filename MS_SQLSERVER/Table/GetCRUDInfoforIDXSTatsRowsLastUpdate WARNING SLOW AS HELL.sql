WITH GET_CRUD_COLS
AS (SELECT	DISTINCT
			OBJECT_NAME(A.[object_id]) AS [ObjectName]
		  , I.[name] AS [IndexName]
		  , A.leaf_insert_count
		  , A.leaf_update_count
		  , A.leaf_delete_count
	FROM	sys.dm_db_index_operational_stats(NULL, NULL, NULL, NULL) A
	INNER JOIN sys.indexes AS I (NOLOCK)
			ON I.[object_id] = A.[object_id]
				AND I.index_id = A.index_id
	WHERE	OBJECTPROPERTY(A.[object_id], 'IsUserTable') = 1)
	--get reads 
   , GET_READS
AS (SELECT	DISTINCT
			OBJECT_NAME(S.[object_id]) AS [ObjectName]
		  , I.[name] AS [IndexName]
		  , user_seeks
		  , user_scans
		  , user_lookups
		  , user_updates
	FROM	sys.dm_db_index_usage_stats AS S (NOLOCK)
	INNER JOIN sys.indexes AS I (NOLOCK)
			ON I.[object_id] = S.[object_id]
				AND I.index_id = S.index_id
	WHERE	OBJECTPROPERTY(S.[object_id], 'IsUserTable') = 1)
   , GET_STATS
AS (SELECT	OBJECT_NAME(st.object_id) AS 'TableName'
		  , sp.stats_id
		  , st.name AS 'StatisticsName'
		  , ob.type
		  , sc.column_id
		  , co.name AS 'ColumnName'
		  , st.filter_definition
		  , sp.last_updated
		  , sp.rows
		  , sp.rows_sampled


	FROM	sys.stats AS st
	INNER JOIN sys.stats_columns sc (NOLOCK)
			ON st.object_id = sc.object_id
				AND st.stats_id = sc.stats_id
	INNER JOIN sys.columns co (NOLOCK)
			ON sc.column_id = co.column_id
				AND sc.object_id = co.object_id
	INNER JOIN sysobjects ob (NOLOCK)
			ON sc.object_id = ob.id
	CROSS APPLY sys.dm_db_stats_properties(st.object_id, st.stats_id) AS sp
	WHERE	ob.type = 'u'
   /*AND CONVERT(DECIMAL(32,2),CASE WHEN sp.modification_counter > 0 
 THEN CONVERT(DECIMAL(32,2),sp.modification_counter)/CONVERT(DECIMAL(32,2),sp.rows) 
 ELSE 0 END) > .4 */
   )
SELECT	DISTINCT
		gcc.[ObjectName]
	  , gcc.[IndexName]
	  , gs.StatisticsName
	  , gcc.leaf_delete_count
	  , gcc.leaf_insert_count
	  , gcc.leaf_update_count
	  , gr.user_lookups
	  , gr.user_scans
	  , gr.user_seeks
	  , gr.user_updates
	  , gs.rows AS RowsInTable
	  , gs.last_updated AS StatsLastUpdatedOn
FROM	GET_CRUD_COLS gcc
JOIN GET_READS gr
  ON gcc.[IndexName] = gr.[IndexName]
	  AND	gcc.[ObjectName] = gr.[ObjectName]
RIGHT JOIN GET_STATS gs
		ON gcc.ObjectName = gs.TableName
			AND gcc.IndexName = gs.StatisticsName;