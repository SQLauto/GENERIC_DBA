SELECT * FROM (
SELECT
        [s].[schema_id]        AS [OwnerId]
       ,SCHEMA_NAME([s].[schema_id]) AS [FunctionOwner]
       ,[s].[object_id]        AS [FunctionId]
       ,[s].[name]             AS [FunctionName]
       ,[s].[type]             AS [FunctionType]
       ,CONVERT(bit, ISNULL([sm].[uses_ansi_nulls], 0)) 
                               AS [IsAnsiNulls]
       ,CONVERT(bit, ISNULL([sm].[uses_quoted_identifier], 0)) 
                               AS [IsQuotedIdentifier]
       ,[sm].[definition]      AS [Script]
       ,CASE WHEN [s].[is_published] <> 0 OR [s].[is_schema_published] <> 0 THEN 1 ELSE 0 END AS [ReplInfo]
       ,[s].[create_date]            AS [CreatedDate]
       ,[sm].[is_schema_bound] AS [IsSchemaBound]
       ,[sm].[uses_native_compilation] AS [UsesNativeCompilation]
       ,[sm].[execute_as_principal_id] AS [ExecuteAsId]
       ,[p].[name] AS [ExecuteAsName]
       ,CAST([sm].[null_on_null_input] AS BIT) AS [NullOnNullInput]
       ,[ambiguous].[IsAmbiguous] AS [HasAmbiguousReference]
FROM   
        [sys].[objects] AS [s] WITH (NOLOCK)
        LEFT JOIN [sys].[sql_modules]         AS [sm] WITH (NOLOCK) ON [sm].[object_id] = [s].[object_id]
        LEFT JOIN [sys].[database_principals] [p] WITH (NOLOCK) ON [p].[principal_id] = [sm].[execute_as_principal_id]   
        OUTER APPLY (SELECT TOP 1 1 AS [IsAmbiguous] FROM [sys].[sql_expression_dependencies] AS [exp] WITH (NOLOCK)
            WHERE [exp].[referencing_id] = [s].[object_id] AND [exp].[referencing_class] = 1 AND ([exp].[is_ambiguous] = 1 OR ([exp].[is_caller_dependent] = 1 AND 1 <> (SELECT COUNT(1) FROM [sys].[objects] AS [o] WITH (NOLOCK) WHERE [o].[name] = [exp].[referenced_entity_name])) )) AS [ambiguous] 
WHERE   
        [s].[type] IN (N'IF', N'FN', N'TF', N'FT', N'FS') 
        AND ([s].[is_ms_shipped] = 0 AND NOT EXISTS (SELECT *
                                        FROM [sys].[extended_properties]
                                        WHERE     [major_id] = [s].[object_id]
                                              AND [minor_id] = 0
                                              AND [class] = 1
                                              AND [name] = N'microsoft_database_tools_support'
                                       )) AND OBJECTPROPERTY([s].[object_id], N'IsEncrypted') = 0
        AND SCHEMA_NAME([s].[schema_id]) <> N'cdc'
) AS [_results] OPTION (USE HINT('FORCE_LEGACY_CARDINALITY_ESTIMATION'))
