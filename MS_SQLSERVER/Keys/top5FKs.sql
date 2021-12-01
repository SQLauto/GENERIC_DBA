WITH GetFKs AS (   SELECT SCHEMA_NAME(FK_TAB.schema_id) + '.' + FK_TAB.name AS "foreign_table"
                        , SCHEMA_NAME(PK_TAB.schema_id) + '.' + PK_TAB.name AS "primary_table"
                        , SUBSTRING(column_names, 1, LEN(column_names) - 1) AS "fk_columns"
                        , FK.name                                           AS "fk_constraint_name"
                   FROM sys.foreign_keys     FK
                       INNER JOIN sys.tables FK_TAB
                           ON FK_TAB.object_id = FK.parent_object_id
                       INNER JOIN sys.tables PK_TAB
                           ON PK_TAB.object_id = FK.referenced_object_id
                       CROSS APPLY
                   (
                       SELECT COL.[name] + ', '
                       FROM sys.foreign_key_columns FK_C
                           INNER JOIN sys.columns   COL
                               ON FK_C.parent_object_id     = COL.object_id
                                  AND FK_C.parent_column_id = COL.column_id
                       WHERE FK_C.parent_object_id         = FK_TAB.object_id
                             AND FK_C.constraint_object_id = FK.object_id
                       ORDER BY COL.column_id
                       FOR XML PATH('')
                   )                         D(column_names) )
   , Parents AS (   SELECT COUNT(*) AS "CountedParents"
                         , gf.primary_table
                    FROM GetFKs gf
                    GROUP BY gf.primary_table)
   , Children AS (   SELECT COUNT(*) AS "CountedChildren"
                          , gf.foreign_table
                     FROM GetFKs gf
                     GROUP BY gf.foreign_table)
   , Top5KeyInfo AS (   SELECT TOP (5)
                               ROW_NUMBER() OVER (ORDER BY p.CountedParents DESC) AS "WindowingRowNumberForOrder"
                             , N'Parent Table (🔑 Generator)'                     AS "TableType"
                             , p.CountedParents                                   AS "CountedKeys"
                             , p.primary_table                                    AS "TableName"
                        FROM Parents p
                        UNION ALL
                        SELECT TOP (5)
                               ROW_NUMBER() OVER (ORDER BY c.CountedChildren DESC) AS "WindowingRowNumberForOrder"
                             , N'Child Table (F🔑)'                                AS "TableType"
                             , c.CountedChildren                                   AS "CountedKeys"
                             , c.foreign_table                                     AS "TableName"
                        FROM Children c)
SELECT t5k.WindowingRowNumberForOrder
     , t5k.TableType
     , t5k.CountedKeys
     , t5k.TableName
FROM Top5KeyInfo t5k;

