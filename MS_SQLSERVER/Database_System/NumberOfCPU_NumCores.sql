DECLARE @xp_msver TABLE (
    [idx] [int] NULL
    ,[c_name] [varchar](100) NULL
    ,[int_val] [float] NULL
    ,[c_val] [varchar](128) NULL
    )
 
INSERT INTO @xp_msver
EXEC ('[master]..[xp_msver]');;
 
WITH [ProcessorInfo]
AS (
    SELECT ([cpu_count] / [hyperthread_ratio]) AS [number_of_physical_cpus]
        ,CASE
            WHEN hyperthread_ratio = cpu_count
                THEN cpu_count
            ELSE (([cpu_count] - [hyperthread_ratio]) / ([cpu_count] / [hyperthread_ratio]))
            END AS [number_of_cores_per_cpu]
        ,CASE
            WHEN hyperthread_ratio = cpu_count
                THEN cpu_count
            ELSE ([cpu_count] / [hyperthread_ratio]) * (([cpu_count] - [hyperthread_ratio]) / ([cpu_count] / [hyperthread_ratio]))
            END AS [total_number_of_cores]
        ,[cpu_count] AS [number_of_virtual_cpus]
        ,(
            SELECT [c_val]
            FROM @xp_msver
            WHERE [c_name] = 'Platform'
            ) AS [cpu_category]
    FROM [sys].[dm_os_sys_info]
    )
SELECT [number_of_physical_cpus]
    ,[number_of_cores_per_cpu]
    ,[total_number_of_cores]
    ,[number_of_virtual_cpus]
    ,LTRIM(RIGHT([cpu_category], CHARINDEX('x', [cpu_category]) - 1)) AS [cpu_category]
FROM [ProcessorInfo]


--azure


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