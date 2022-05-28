/*Finds all Blobs and VarcharMax 
should work on  SQLServer, MySQL, Postgres, DB2
  Column Alias names may need to be enclosed in [] or  or '' depending on system
  --Dave Babler 2022-03-23*/

SELECT  tab.TABLE_CATALOG AS DatabaseName
      , tab.TABLE_SCHEMA AS SchemaName
      , tab.TABLE_NAME AS TableName
      , col.COLUMN_NAME AS ColumnName
      , col.DATA_TYPE AS DataType
FROM    INFORMATION_SCHEMA.TABLES AS tab
    INNER JOIN
    INFORMATION_SCHEMA.COLUMNS AS col
       ON col.TABLE_SCHEMA = tab.TABLE_SCHEMA
          AND   col.TABLE_NAME = tab.TABLE_NAME
WHERE   tab.TABLE_TYPE = 'BASE TABLE'
        AND (TABLE_SCHEMA NOT IN ( 'sys', 'information_schema', 'mysql', 'performance_schema', 'pg_catalog', 'syscat' ))
        AND
        (
            col.DATA_TYPE IN ( 'blob'
                             , 'mediumblob'
                             , 'longblob'
                             , 'text'
                             , 'mediumtext'
                             , 'longtext'
                             , 'binary'
                             , 'varbinary'
                             , 'lob'
                             , 'NText'
                             , 'Image'
                             )
            OR
            (
                col.DATA_TYPE IN ( 'VARCHAR', 'NVARCHAR' )
                AND col.CHARACTER_MAXIMUM_LENGTH = -1
            )
        )
ORDER BY tab.TABLE_NAME
       , col.COLUMN_NAME;