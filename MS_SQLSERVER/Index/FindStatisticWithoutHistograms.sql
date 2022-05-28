--BrentOzar's https://www.brentozar.com/archive/2018/09/finding-fixing-statistics-without-histograms/


SELECT DISTINCT SCHEMA_NAME(o.schema_id) AS schema_name,
       o.name AS table_name,
    'UPDATE STATISTICS ' + QUOTENAME(SCHEMA_NAME(o.schema_id)) + '.' + QUOTENAME(o.name) + ' WITH FULLSCAN;' AS the_fix
  FROM sys.all_objects o 
  INNER JOIN sys.stats s ON o.object_id = s.object_id AND s.has_filter = 0
  OUTER APPLY sys.dm_db_stats_histogram(o.object_id, s.stats_id) h
  WHERE o.is_ms_shipped = 0 AND o.type_desc = 'USER_TABLE'
    AND h.object_id IS NULL
    AND 0 < (SELECT SUM(row_count) FROM sys.dm_db_partition_stats ps WHERE ps.object_id = o.object_id)
  ORDER BY 1, 2;