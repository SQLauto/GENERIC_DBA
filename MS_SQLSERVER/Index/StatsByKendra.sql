SELECT	stat.auto_created
	  , stat.name AS stats_name
	  , STUFF((
				  SELECT	', ' + cols.name
				  FROM	sys.stats_columns AS statcols
				  JOIN sys.columns AS cols
					ON statcols.column_id = cols.column_id
						AND statcols.object_id = cols.object_id
				  WHERE
						statcols.stats_id = stat.stats_id
					  AND	statcols.object_id = stat.object_id
				  ORDER BY statcols.stats_column_id
				  FOR XML PATH(''), TYPE
			  ).value('.', 'NVARCHAR(MAX)')
			, 1
			, 2
			, ''
			 ) AS stat_cols
	  , stat.filter_definition
	  , stat.is_temporary
	  , stat.no_recompute
	  , sp.last_updated
	  , sp.modification_counter
	  , sp.rows
	  , sp.rows_sampled
FROM	sys.stats AS stat
CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
JOIN sys.objects AS so
  ON stat.object_id = so.object_id
JOIN sys.schemas AS sc
  ON so.schema_id = sc.schema_id
ORDER BY sp.last_updated DESC;
GO