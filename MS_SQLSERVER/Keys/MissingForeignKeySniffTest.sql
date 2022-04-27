DECLARE @tblColumnList AS TABLE (TableName     VARCHAR(255) NOT NULL
                               , ColumnName    VARCHAR(255) NOT NULL
                               , PKTableName   VARCHAR(255)
                               , PKColumnName  VARCHAR(255)
                               , HasForeignKey BIT          NOT NULL);

-- Find all column names that occur more than once. 
-- Exclude archive and staging tables. 
INSERT INTO @tblColumnList (TableName
                          , ColumnName
                          , PKTableName
                          , PKColumnName
                          , HasForeignKey)
SELECT  t.name AS "TableName"
      , c.name AS "ColumnName"
      , t2.name AS "PKTableName"
      , c2.name AS "PKColumnName"
      , CASE
             WHEN f1.parent_object_id IS NOT NULL THEN
                 1
             WHEN f2.referenced_object_id IS NOT NULL THEN
                 1
             ELSE
                 0
        END AS "HasForeignKey"
FROM    sys.tables AS t
    JOIN
    sys.columns AS c
      ON c.object_id = t.object_id
    JOIN
    sys.types AS y
      ON c.system_type_id = y.system_type_id
    LEFT JOIN
    sys.columns c2
      ON (c.name = c2.name)
    JOIN
    sys.tables t2
      ON (   c2.object_id = t2.object_id
             AND t.object_id <> t2.object_id)
    LEFT JOIN
    sys.foreign_key_columns AS f1
      ON f1.parent_object_id = t.object_id
         AND f1.parent_column_id = c.column_id
    LEFT JOIN
    sys.foreign_key_columns AS f2
      ON f2.referenced_object_id = t.object_id
         AND f2.referenced_column_id = c.column_id
WHERE   t.is_ms_shipped = 0
        AND y.name IN ( 'bigint', 'int', 'smallint', 'tinyint', 'uniqueidentifier' );

SELECT  TableName
      , ColumnName
      , PKTableName
      , PKColumnName
FROM    @tblColumnList
WHERE   HasForeignKey = 0
        AND ColumnName IN (   SELECT    ColumnName
                              FROM  @tblColumnList
                              GROUP BY ColumnName
                              HAVING COUNT(*) > 1 )
ORDER BY ColumnName
       , TableName;