/*Surgically Targeting Indexes: 
	Instructions: Fill your TableVariable 
	Make sure you have the corresponding script.
	Make sure that script has an INT that matches the variable here for the tracking table
	also make sure it has the string char so you can build that list of tables and stuff
	PRINT TO FILE OR TEXT DO NOT PRINT TO GRID */
DECLARE @strOnlineOnOrOff CHAR(3) = 'OFF';
DECLARE @ustrTableList NVARCHAR(2160);
DECLARE @ustrInsertStatement NVARCHAR(MAX);
DECLARE @ustrUpdateStatement NVARCHAR(MAX);
DECLARE @intMaxIndexStatmentsBuilt INT = 0;
DROP TABLE IF EXISTS ##LOADTEST;

CREATE TABLE ##LOADTEST
(
    EventID            INT IDENTITY(1, 1) PRIMARY KEY NOT NULL
  , SysObjTypeTested   NVARCHAR(80)
  , NameOfObjectTested NVARCHAR(80)
  , CursorLoopCount    INT
  , IsControlTest      BIT
  , NotesOrInformation NVARCHAR(800)
);


SELECT  @ustrInsertStatement = CONCAT(
                                         N'INSERT INTO ##LOADTEST
           ([SysObjTypeTested]
           ,[NameOfObjectTested]
           ,[CursorLoopCount]
           ,[IsControlTest]
           ,[NotesOrInformation])
     VALUES
           (''IX''
           ,''Various Indexes See Notes''
           ,NULL
           ,0
           ,'''
                                       , @ustrTableList
                                       , N''')'
                                       , CONCAT(CHAR(13), CHAR(10))
                                       , CONCAT(CHAR(13), CHAR(10))
                                       , 'SELECT @intEventID =  SCOPE_IDENTITY();'
                                       , CHAR(13)
                                     );

;WITH GetIndexList
   AS (   SELECT    CAST(i.name AS NVARCHAR(80))                          AS "index_name"
                  , SUBSTRING(D.column_names, 1, LEN(D.column_names) - 1) AS "columns"
                  , CASE  --MAINT SCRIPT NOT PRODUCTION CUSTOMER SCRIPT more important for DBA to know what's up than speed
                         WHEN i.type = 1 THEN
                             'Clustered index'
                         WHEN i.type = 2 THEN
                             'Nonclustered unique index'
                         WHEN i.type = 3 THEN
                             'XML index'
                         WHEN i.type = 4 THEN
                             'Spatial index'
                         WHEN i.type = 5 THEN
                             'Clustered columnstore index'
                         WHEN i.type = 6 THEN
                             'Nonclustered columnstore index'
                         WHEN i.type = 7 THEN
                             'Nonclustered hash index'
                    END                                                   AS "index_type"
                  , CASE
                         WHEN i.is_unique = 1 THEN
                             'Unique'
                         ELSE
                             'Not unique'
                    END                                                   AS "unique"
                  , CONCAT('[', SCHEMA_NAME(t.schema_id) , ']') + '.' + CONCAT('[', t.name, ']')               AS "table_view"
                  , CASE
                         WHEN t.type = 'U' THEN
                             'Table'
                         WHEN t.type = 'V' THEN
                             'View'
                    END                                                   AS "object_type"
          FROM  mapbenefits.sys.objects          AS t
              INNER JOIN mapbenefits.sys.indexes AS i
                  ON t.object_id = i.object_id
              CROSS APPLY
          (
              SELECT    CONCAT(col.name, ' Type: ', st.name) + ', '
              FROM  mapbenefits.sys.index_columns    AS ic
                  INNER JOIN mapbenefits.sys.columns AS col
                      ON ic.object_id       = col.object_id
                         AND ic.column_id   = col.column_id
                  INNER JOIN mapbenefits.sys.types   AS st
                      ON col.system_type_id = st.system_type_id
              WHERE ic.object_id    = t.object_id
                    AND ic.index_id = i.index_id
              ORDER BY key_ordinal
              FOR XML PATH('')
          )                                      AS D(column_names)
          WHERE i.index_id > 0
		  AND OBJECT_SCHEMA_NAME(t.object_id) <> 'sys'
          AND t.type <> 'TF'
 )
       
    , GetNoFillFactorIdxs
   AS (   SELECT    GetIndexList.index_name  AS "NoFFIndexName"
                  , GetIndexList.columns     AS "NoFFColumns"
                  , GetIndexList.index_type  AS "NoFFIndexType"
                  , GetIndexList.[unique]    AS "NoFFUnique"
                  , GetIndexList.table_view  AS "NoFFTableorViewName"
                  , GetIndexList.object_type AS "NoFFObjectType"
                  , CONCAT(
                              'ALTER INDEX '
                            , CONCAT('[', GetIndexList.index_name, ']')
                            , ' ON '
                            , CHAR(13)
                            , GetIndexList.table_view
                            , CHAR(32)
                            , 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ' , MAXDOP=1);'
                          )                  AS "NoFFRebuildCommand"
          FROM  GetIndexList
          WHERE (
                    GetIndexList.columns LIKE '%int'
                    OR  GetIndexList.columns LIKE '%date%'
                )
                AND LEN(GetIndexList.columns) < 64
            UNION 
            /*The ColumnStores cannot have a fill factor, so it's best to just grab them right here as their
                own relational set and union them to the  other non Fill Factors*/
     SELECT    GetIndexList.index_name  AS "NoFFIndexName"
                  , GetIndexList.columns     AS "NoFFColumns"
                  , GetIndexList.index_type  AS "NoFFIndexType"
                  , GetIndexList.[unique]    AS "NoFFUnique"
                  , GetIndexList.table_view  AS "NoFFTableorViewName"
                  , GetIndexList.object_type AS "NoFFObjectType"
                  , CONCAT(
                              'ALTER INDEX '
                            , CONCAT('[', GetIndexList.index_name, ']')
                            , ' ON '
                            , CHAR(13)
                            , GetIndexList.table_view
                            , CHAR(32)
                            , 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ' , MAXDOP=1);'
                          )                  AS "NoFFRebuildCommand"
          FROM  GetIndexList
    WHERE index_type IN ('Clustered columnstore index', 'Nonclustered columnstore index')
			)
    , GetFillFactorIndexes
   AS (   SELECT    CONCAT('[', GetIndexList.index_name, ']') AS "YesFFIndexName"
                  , GetIndexList.columns     AS "YesFFColumns"
                  , GetIndexList.index_type  AS "YesFFIndexType"
                  , GetIndexList.[unique]    AS "YesFFUnique"
                  , GetIndexList.table_view  AS "YesFFTableOrViewName"
                  , GetIndexList.object_type AS "YesFFObjectType"
                  , CASE
                         WHEN GetIndexList.index_type = 'Clustered Index'
                              OR   GetIndexList.[unique] = 'Unique' THEN
                             CONCAT(
                                       'ALTER INDEX '
                                     , CONCAT('[', GetIndexList.index_name, ']')
                                     , ' ON '
                                     , CHAR(13)
                                     , GetIndexList.table_view
                                     , CHAR(32)
                                     , 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ', FILLFACTOR = 80, MAXDOP=1);'  ---fill factor goes here 
                                     , CHAR(13)
                                   )
                         ELSE
                             CONCAT(
                                       'ALTER INDEX '
                                     , CONCAT('[', GetIndexList.index_name, ']')
                                     , ' ON '
                                     , CHAR(13)
                                     , GetIndexList.table_view
                                     , CHAR(32)
                                     , 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ', FILLFACTOR = 100, MAXDOP=1);'  /*Maximum degree of parallellism must be set to 1 or the whole thing implodes*/
                                     , CHAR(13)
                                   )
                    END                      AS "YesFFRebuildCommand"
          FROM  GetIndexList
          WHERE NOT EXISTS
          (
              SELECT    1
              FROM  GetNoFillFactorIdxs
              WHERE GetNoFillFactorIdxs.NoFFIndexName = GetIndexList.index_name
          ))
    , GetUnionAndRows
   AS (   SELECT    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS "RowCounter"
                  , UI.IdxCommand
          FROM
            (
                SELECT  nfi.NoFFRebuildCommand AS "IdxCommand"
                FROM    GetNoFillFactorIdxs AS nfi
                UNION
                SELECT  yfi.YesFFRebuildCommand AS "IdxCommand"
                FROM    GetFillFactorIndexes AS yfi
            ) AS UI /* Breaking apart this to a CTE would be overkill, maybe.  */)
    , FinalEdits
   AS (   SELECT    CASE
                         WHEN gur.RowCounter % 10 = 0
                              OR   gur.RowCounter = 1 THEN
                             CONCAT(
                                       CONCAT(CHAR(10), CHAR(13))
                                     , @ustrInsertStatement
                                     , CONCAT(CHAR(10), CHAR(13))
                                     , gur.IdxCommand
                                   )
                         WHEN CAST(RIGHT(CAST(gur.RowCounter AS NVARCHAR(16)), 1) AS INT) = 9
                              OR   gur.RowCounter =
                              (
                                  SELECT    MAX(maxgur.RowCounter)FROM  GetUnionAndRows AS maxgur
                              ) THEN
                             CONCAT(
                                       gur.IdxCommand
                                     , CONCAT(CHAR(10), CHAR(13), @ustrUpdateStatement, CONCAT(CHAR(10), CHAR(13)))
                                   )
                         ELSE
                             IIF(gur.IdxCommand LIKE '%PK%'
                              , REPLACE(gur.IdxCommand, 'ONLINE=ON', 'ONLINE=OFF') --SWITCH if we need to leave tables online during rebuild
                              , gur.IdxCommand)
                    END AS "Commands"
          FROM  GetUnionAndRows AS gur)
SELECT  FinalEdits.Commands
FROM    FinalEdits;



SELECT  l.EventID
      , l.SysObjTypeTested
      , l.NameOfObjectTested
      , l.CursorLoopCount
      , l.IsControlTest
      , l.NotesOrInformation
FROM    ##LOADTEST AS l;