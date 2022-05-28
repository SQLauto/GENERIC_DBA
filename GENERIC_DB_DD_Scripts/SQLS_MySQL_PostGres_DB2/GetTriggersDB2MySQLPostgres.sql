/*Get Trigger facts will only work on MySQL/Postgres
  This MAY work on DB2
  --Dave Babler 2022-03-23*/

SELECT  event_object_schema AS DatabaseName
      , event_object_table AS TableName
      , trigger_name TriggerName
      , action_order OrdinalofTriggerExeuction
      , action_timing TriggerTiming
      , event_manipulation AS TriggerEventType
      , action_statement AS CodeDefinition
FROM    INFORMATION_SCHEMA.triggers
WHERE   trigger_schema NOT IN ( 'sys', 'mysql', 'pg_catalog', 'syscat', 'INFORMATION_SCHEMA' )
ORDER BY database_name
       , table_name;