--all database
SELECT
   DB_NAME() AS DatabaseName,
   p.name AS ExtendedPropertyName,
   p.value AS ExtendedPropertyValue
FROM
   sys.extended_properties AS p
WHERE
   p.major_id=0 
   AND p.minor_id=0 
   AND p.class=0
ORDER BY
   [Name] ASC


--all tables
SELECT
   SCHEMA_NAME(tbl.schema_id) AS SchemaName,	
   tbl.name AS TableName, 
   p.name AS ExtendedPropertyName,
   CAST(p.value AS sql_variant) AS ExtendedPropertyValue
FROM
   sys.tables AS tbl
   INNER JOIN sys.extended_properties AS p ON p.major_id=tbl.object_id AND p.minor_id=0 AND p.class=1


--all columns

SELECT
   SCHEMA_NAME(tbl.schema_id) AS SchemaName,	
   tbl.name AS TableName, 
   clmns.name AS ColumnName,
   p.name AS ExtendedPropertyName,
   CAST(p.value AS sql_variant) AS ExtendedPropertyValue
FROM
   sys.tables AS tbl
   INNER JOIN sys.all_columns AS clmns ON clmns.object_id=tbl.object_id
   INNER JOIN sys.extended_properties AS p ON p.major_id=tbl.object_id AND p.minor_id=clmns.column_id AND p.class=1

--all stored procedures
SELECT
   SCHEMA_NAME(sp.schema_id) AS SchemaName,	
   sp.name AS SPName, 
   p.name AS ExtendedPropertyName,
   CAST(p.value AS sql_variant) AS ExtendedPropertyValue
FROM
   sys.all_objects AS sp
   INNER JOIN sys.extended_properties AS p ON p.major_id=sp.object_id AND p.minor_id=0 AND p.class=1
WHERE
   sp.type = 'P' OR sp.type = 'RF' OR sp.type= 'PC'