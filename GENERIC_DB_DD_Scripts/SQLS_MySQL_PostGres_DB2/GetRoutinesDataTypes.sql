/*Get Routines and Data Types should work on 
  SQLServer, MySQL, Postgres, DB2
  Column Alias names may need to be enclosed in [] or "" or '' depending on system
  --Dave Babler 2022-03-23*/
SELECT  r.ROUTINE_SCHEMA AS DatabaseName
      , r.SPECIFIC_NAME AS RoutineName
      , r.ROUTINE_TYPE AS TypeofRoutine
      , p.PARAMETER_NAME AS ParamaterName
      , p.DATA_TYPE AS ParamaterDataType
      , CASE
             WHEN p.PARAMETER_MODE IS NULL
                  AND   p.DATA_TYPE IS NOT NULL THEN
                 'RETURN'
             ELSE
                 PARAMETER_MODE
        END AS ParamaterMode
      , p.CHARACTER_MAXIMUM_LENGTH AS CharacterLength
      , p.NUMERIC_PRECISION AS NumericPrecision
      , p.NUMERIC_SCALE AS NumericScale
FROM    INFORMATION_SCHEMA.ROUTINES r
    LEFT JOIN
    INFORMATION_SCHEMA.PARAMETERS p
      ON p.SPECIFIC_SCHEMA = r.ROUTINE_SCHEMA
         AND p.SPECIFIC_NAME = r.SPECIFIC_NAME
WHERE   r.ROUTINE_SCHEMA NOT IN ( 'sys', 'information_schema', 'mysql', 'performance_schema', 'pg_catalog', 'syscat' )
-- and r.routine_schema = 'database_name' -- put your database name here
ORDER BY r.ROUTINE_SCHEMA
       , r.SPECIFIC_NAME
       , p.ORDINAL_POSITION;