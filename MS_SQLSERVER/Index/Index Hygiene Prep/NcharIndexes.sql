WITH getIndexes
  AS (   SELECT i.[name]                                              AS "IndexName"
              , SUBSTRING(D.column_names, 1, LEN(D.column_names) - 1) AS "columns"
              , CASE
                     WHEN i.[type] = 1 THEN
                         'Clustered index'
                     WHEN i.[type] = 2 THEN
                         'Nonclustered unique index'
                     WHEN i.[type] = 3 THEN
                         'XML index'
                     WHEN i.[type] = 4 THEN
                         'Spatial index'
                     WHEN i.[type] = 5 THEN
                         'Clustered columnstore index'
                     WHEN i.[type] = 6 THEN
                         'Nonclustered columnstore index'
                     WHEN i.[type] = 7 THEN
                         'Nonclustered hash index'
                END                                                   AS "index_type"
              , CASE
                     WHEN i.is_unique = 1 THEN
                         'Unique'
                     ELSE
                         'Not unique'
                END                                                   AS "unique"
              , SCHEMA_NAME(t.schema_id)                              AS "SchemaName"
              , t.[name]                                              AS "TableName"
              , SCHEMA_NAME(t.schema_id) + '.' + t.[name]             AS "table_view"
              , CASE
                     WHEN t.[type] = 'U' THEN
                         'Table'
                     WHEN t.[type] = 'V' THEN
                         'View'
                END                                                   AS "object_type"
         FROM   sys.objects         AS t
             INNER JOIN sys.indexes AS i
                 ON t.object_id = i.object_id
             CROSS APPLY
         (
             SELECT col.name + ', '
             FROM   sys.index_columns   AS ic
                 INNER JOIN sys.columns AS col
                     ON ic.object_id     = col.object_id
                        AND ic.column_id = col.column_id
             WHERE  ic.object_id    = t.object_id
                    AND ic.index_id = i.index_id
             ORDER BY key_ordinal
             FOR XML PATH('')
         )                          AS D(column_names)
         WHERE  t.is_ms_shipped <> 1
                AND i.index_id  > 0)
   , getPKs
  AS (   SELECT SCHEMA_NAME(tab.schema_id)                            AS "SchemaName"
              , pk.[name]                                             AS "PrimaryKeyName"
              , SUBSTRING(D.column_names, 1, LEN(D.column_names) - 1) AS "Columns"
              , tab.[name]                                            AS "TableName"
         FROM   sys.tables          AS tab
             INNER JOIN sys.indexes AS pk
                 ON tab.object_id = pk.object_id
                    AND pk.is_primary_key = 1
             CROSS APPLY
         (
             SELECT col.name + ', '
             FROM   sys.index_columns   AS ic
                 INNER JOIN sys.columns AS col
                     ON ic.object_id     = col.object_id
                        AND ic.column_id = col.column_id
             WHERE  ic.object_id    = tab.object_id
                    AND ic.index_id = pk.index_id
             ORDER BY col.column_id
             FOR XML PATH('')
         )                          AS D(column_names) )
   , getFKs
  AS (   SELECT SCHEMA_NAME(fk_tab.schema_id)                         AS "SchemaName"
              , fk_tab.name                                           AS "TableName"
              , SUBSTRING(D.column_names, 1, LEN(D.column_names) - 1) AS "ColumnName"
              , fk.name                                               AS "fk_constraint_name"
         FROM   sys.foreign_keys   AS fk
             INNER JOIN sys.tables AS fk_tab
                 ON fk_tab.object_id = fk.parent_object_id
             INNER JOIN sys.tables AS pk_tab
                 ON pk_tab.object_id = fk.referenced_object_id
             CROSS APPLY
         (
             SELECT col.name + ', '
             FROM   sys.foreign_key_columns AS fk_c
                 INNER JOIN sys.columns     AS col
                     ON fk_c.parent_object_id     = col.object_id
                        AND fk_c.parent_column_id = col.column_id
             WHERE  fk_c.parent_object_id         = fk_tab.object_id
                    AND fk_c.constraint_object_id = fk.object_id
             ORDER BY col.column_id
             FOR XML PATH('')
         )                         AS D(column_names) )
   , getPKsFKs
  AS (   SELECT gi.IndexName          AS "IndexName"
              , gi.SchemaName         AS "SchemaName"
              , gi.TableName          AS "TableName"
              , gi.columns            AS "ColumnsInvolved"
              , c.DATA_TYPE           AS "DataType"
              , pk.PrimaryKeyName     AS "PKName"
              , fk.fk_constraint_name AS "FKName"
              , CASE
                     WHEN pk.PrimaryKeyName IS NOT NULL THEN
                         pk.PrimaryKeyName
                     WHEN fk.fk_constraint_name IS NOT NULL THEN
                         fk.fk_constraint_name
                     ELSE
                         NULL
                END                   AS "KeyName"
         FROM   getIndexes                   AS gi
             JOIN INFORMATION_SCHEMA.COLUMNS AS c
                 ON gi.SchemaName    = c.TABLE_SCHEMA
                    AND gi.TableName = c.TABLE_NAME
                    AND gi.columns   = c.COLUMN_NAME
             LEFT OUTER JOIN getPKs          AS pk
                 ON gi.SchemaName    = pk.SchemaName
                    AND gi.TableName = pk.TableName
                    AND gi.columns   = pk.Columns
             LEFT OUTER JOIN getFKs          AS fk
                 ON gi.SchemaName    = fk.SchemaName
                    AND gi.TableName = fk.TableName
                    AND gi.columns   = fk.ColumnName)
SELECT  pkfk.IndexName
      , pkfk.SchemaName
      , pkfk.TableName
      , pkfk.ColumnsInvolved
      , pkfk.DataType
      , pkfk.PKName
      , pkfk.FKName
      , pkfk.KeyName
	  , CONCAT ('ALTER INDEX ', QUOTENAME(pkfk.IndexName), ' ON ', CONCAT(QUOTENAME(pkfk.SchemaName), '.',   QUOTENAME(pkfk.TableName)), ' ', 'REBUILD WITH (FILLFACTOR = 95);')
FROM    getPKsFKs AS pkfk
WHERE   pkfk.DataType IN ( 'nvarchar', 'varchar', 'char', 'nchar', 'text' );