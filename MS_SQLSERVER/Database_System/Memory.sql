
--To get the minimum and maximum size of memory configured for SQL Server.
SELECT [name]             AS [Name]
     , [configuration_id] AS [Number]
     , [minimum]          AS [Minimum]
     , [maximum]          AS [Maximum]
     , [is_dynamic]       AS [Dynamic]
     , [is_advanced]      AS [Advanced]
     , [value]            AS [ConfigValue]
     , [value_in_use]     AS [RunValue]
     , [description]      AS [Description]
FROM [master].[sys].[configurations]
WHERE Name IN ( 'Min server memory (MB)', 'Max server memory (MB)' );




SELECT end_time
     , avg_cpu_percent
     , avg_data_io_percent
     , avg_log_write_percent
     , avg_memory_usage_percent
     , xtp_storage_percent
     , max_worker_percent
     , max_session_percent
     , dtu_limit
     , avg_login_rate_percent
     , avg_instance_cpu_percent
     , avg_instance_memory_percent
     , cpu_limit
     , replica_role
FROM sys.dm_db_resource_stats;