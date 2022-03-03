DROP TABLE IF EXISTS #DESCRIBE 

DECLARE @dSQLTest NVARCHAR(MAX)
	, @dSQLTestParams NVARCHAR(MAX)
	, @ustrDatabaseName NVARCHAR(64)
	, @ustrSchemaName NVARCHAR(64)
	, @ustrObjectName NVARCHAR(64)

SET @ustrDatabaseName = 'AdventureWorks2016';
SET @ustrSchemaName = 'Sales';
SET @ustrObjectName = 'BusinessEntityContact';
SET @dSQLTest = 
                    N'WITH fkeys
                    AS (
                        SELECT col.name AS NameofFKColumn
                            , schema_name(pk_tab.schema_id) + ''.'' + pk_tab.name AS ReferencedTable
                            , pk_col.name AS PrimaryKeyColumnName
                            , delete_referential_action_desc AS ReferentialDeleteAction
                            , update_referential_action_desc AS ReferentialUpdateAction
                        FROM ' + @ustrDatabaseName + '.sys.tables tab
                        INNER JOIN ' + @ustrDatabaseName + '.sys.columns col
                            ON col.object_id = tab.object_id
                        LEFT JOIN ' + @ustrDatabaseName + '.sys.foreign_key_columns fk_cols
                            ON fk_cols.parent_object_id = tab.object_id
                                AND fk_cols.parent_column_id = col.column_id
                        LEFT JOIN ' + @ustrDatabaseName + '.sys.foreign_keys fk
                            ON fk.object_id = fk_cols.constraint_object_id
                        LEFT JOIN ' + @ustrDatabaseName + '.sys.tables pk_tab
                            ON pk_tab.object_id = fk_cols.referenced_object_id
                        LEFT JOIN ' + @ustrDatabaseName + '.sys.columns pk_col
                            ON pk_col.column_id = fk_cols.referenced_column_id
                            AND pk_col.column_id = fk_cols.referenced_object_id
                        WHERE fk.name IS NOT NULL
                            AND tab.name = @ustrTableName_d
                            AND pk_tab.schema_id = SCHEMA_ID(@ustrSchemaName_d)
                        )
                        , pk
                    AS (
                        SELECT SCHEMA_NAME(o.schema_id) AS TABLE_SCHEMA
                            , o.name AS TABLE_NAME
                            , c.name AS COLUMN_NAME
                            , i.is_primary_key
                        FROM ' + @ustrDatabaseName + '.sys.indexes AS i
                        INNER JOIN ' + @ustrDatabaseName + '.sys.index_columns AS ic
                            ON i.object_id = ic.object_id
                                AND i.index_id = ic.index_id
                        INNER JOIN ' + @ustrDatabaseName + '.sys.objects AS o
                            ON i.object_id = o.object_id
                        LEFT JOIN ' + @ustrDatabaseName + '.sys.columns AS c
                            ON ic.object_id = c.object_id
                                AND c.column_id = ic.column_id
                        WHERE i.is_primary_key = 1
                        )
                        , indStart
                    AS (
                        SELECT TableName = t.name
                            , IndexName = ind.name
                            , IndexId = ind.index_id
                            , ColumnId = ic.index_column_id
                            , ColumnName = col.name
                        FROM ' + @ustrDatabaseName + '.sys.indexes ind
                        INNER JOIN ' + @ustrDatabaseName + '.sys.index_columns ic
                            ON ind.object_id = ic.object_id
                                AND ind.index_id = ic.index_id
                        INNER JOIN ' + @ustrDatabaseName + '.sys.columns col
                            ON ic.object_id = col.object_id
                                AND ic.column_id = col.column_id
                        INNER JOIN ' + @ustrDatabaseName + '.sys.tables t
                            ON ind.object_id = t.object_id
                        WHERE ind.is_primary_key = 0
                            AND ind.is_unique = 0
                            AND ind.is_unique_constraint = 0
                            AND t.is_ms_shipped = 0
                            AND t.Name = @ustrTableName_d
                        )
                        , indexList
                    AS (
                        SELECT i2.TableName
                            , i2.IndexName
                            , i2.IndexID
                            , i2.ColumnId
                            , i2.ColumnName
                            , (
                                SELECT SUBSTRING((
                                            SELECT ''
                                                , '' + IndexName
                                            FROM indStart i1
                                            WHERE i1.ColumnName = i2.ColumnName
                                            FOR XML PATH('''')
                                            ), 2, 200000)
                                ) AS IndexesRowIsInvolvedIn
                            , ROW_NUMBER() OVER (
                                PARTITION BY LOWER(ColumnName) ORDER BY ColumnId
                                ) AS RowNum
                        FROM indStart i2
                        )
                    SELECT col.COLUMN_NAME AS ColumnName
                        , col.ORDINAL_POSITION AS OrdinalPosition
                        , col.DATA_TYPE AS DataType
                        , col.CHARACTER_MAXIMUM_LENGTH AS MaxLength
                        , col.NUMERIC_PRECISION AS NumericPrecision
                        , col.NUMERIC_SCALE AS NumericScale
                        , col.DATETIME_PRECISION AS DatePrecision
                        , col.COLUMN_DEFAULT AS DefaultSetting
                        , CAST(CASE col.IS_NULLABLE
                                WHEN '' NO ''
                                    THEN 0
                                ELSE 1
                                END AS BIT) AS IsNullable
                        , COLUMNPROPERTY(OBJECT_ID('' ['' + col.TABLE_SCHEMA + ''].['' + col.TABLE_NAME + ''] ''), col.COLUMN_NAME, '' IsComputed 
                            '') AS IsComputed
                        , COLUMNPROPERTY(OBJECT_ID('' ['' + col.TABLE_SCHEMA + ''].['' + col.TABLE_NAME + ''] ''), col.COLUMN_NAME, '' IsIdentity 
                            '') AS IsIdentity
                        , CAST(ISNULL(pk.is_primary_key, 0) AS BIT) AS IsPrimaryKey
                        , '' FK

                    of: '' + fkeys.ReferencedTable + ''.'' + fkeys.PrimaryKeyColumnName AS ReferencedTablePrimaryKey
                        , col.COLLATION_NAME AS CollationName
                        , s.value AS Description
                        , indexList.IndexesRowIsInvolvedIn
                    INTO ##DESCRIBE --GLOBAL TEMP 
                    FROM ' + @ustrDatabaseName +'.INFORMATION_SCHEMA.COLUMNS AS col
                    LEFT JOIN pk
                        ON col.TABLE_NAME = pk.TABLE_NAME
                            AND col.TABLE_SCHEMA = pk.TABLE_SCHEMA
                            AND col.COLUMN_NAME = pk.COLUMN_NAME
                    LEFT JOIN ' + @ustrDatabaseName + '.sys.extended_properties s
                        ON s.major_id = OBJECT_ID(col.TABLE_SCHEMA + ''.'' + col.TABLE_NAME)
                            AND s.minor_id = col.ORDINAL_POSITION
                            AND s.name = '' MS_Description ''
                            AND s.class = 1
                    LEFT JOIN fkeys AS fkeys
                        ON col.COLUMN_NAME = fkeys.NameofFKColumn
                    LEFT JOIN indexList
                        ON col.COLUMN_NAME = indexList.ColumnName
                            AND indexList.RowNum = 1
                    WHERE col.TABLE_NAME = @ustrTableName_d
                        AND col.TABLE_SCHEMA = @ustrSchemaName_d

'
	;

    SELECT CAST('<root><![CDATA[' + @dSQLTestParams + ']]></root>' AS XML)

SET @dSQLTestParams = '@ustrDatabaseName_d NVARCHAR(64)
, @ustrSchemaName_d NVARCHAR(64)
, @ustrTableName_d NVARCHAR(64)';

EXEC sp_executesql @dSQLTest
, @dSQLTestParams
, @ustrDatabaseName_d = @ustrDatabaseName
, @ustrSchemaName_d = @ustrSchemaName
, @ustrTableName_d = @ustrObjectName;
