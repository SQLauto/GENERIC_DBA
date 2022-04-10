/*PRINT to File or PRINT  to SCREEN, do not use grid, it will not work!
    step 1: grab the bad queries from the query store from the primary DBs stuff them in an excel file, just in case.
    step 2: replace the dbname and run this script 01-IndexHygienePrep  RUN ONLY AS PRINT TO SCREEN OR FILE
    step 3: Cut and paste results INTO 02 - IndexAdhocPasteTemplate
    step 4: replace the dbname and run the script 03 - FlushProces Etc.
this accompanies two other scripts 
they are IndexAdhocPasteTemplate << paste the results of this script in this */

DECLARE @strOnlineOnOrOff CHAR(3) = 'OFF';

;WITH GetIndexList
   AS (   SELECT    CAST(i.name AS NVARCHAR(80))                                                AS "index_name"
                  , SUBSTRING(D.column_names, 1, LEN(D.column_names) - 1)                       AS "columns"
                  , CASE --MAINT SCRIPT NOT PRODUCTION CUSTOMER SCRIPT more important for DBA to know what's up than speed
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
                    END                                                                         AS "index_type"
                  , CASE
                         WHEN i.is_unique = 1 THEN
                             'Unique'
                         ELSE
                             'Not unique'
                    END                                                                         AS "unique"
                  , CONCAT('[', SCHEMA_NAME(t.schema_id), ']') + '.' + CONCAT('[', t.name, ']') AS "table_view"
                  , CASE
                         WHEN t.type = 'U' THEN
                             'Table'
                         WHEN t.type = 'V' THEN
                             'View'
                    END                                                                         AS "object_type"
          FROM  REPLACEWITHDBNAME.sys.objects          AS t
              INNER JOIN REPLACEWITHDBNAME.sys.indexes AS i
                  ON t.object_id = i.object_id
              CROSS APPLY
          (
              SELECT    CONCAT(col.name, ' Type: ', st.name) + ', '
              FROM  REPLACEWITHDBNAME.sys.index_columns    AS ic
                  INNER JOIN REPLACEWITHDBNAME.sys.columns AS col
                      ON ic.object_id       = col.object_id
                         AND ic.column_id   = col.column_id
                  INNER JOIN REPLACEWITHDBNAME.sys.types   AS st
                      ON col.system_type_id = st.system_type_id
              WHERE ic.object_id    = t.object_id
                    AND ic.index_id = i.index_id
              ORDER BY key_ordinal
              FOR XML PATH('')
          )                                      AS D(column_names)
          WHERE i.index_id                          > 0
                AND OBJECT_SCHEMA_NAME(t.object_id) <> 'sys'
                AND t.type                          <> 'TF'  /*yes! Table Value Functions have indexes, but you can't rebuild them!*/
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
          WHERE GetIndexList.index_type IN ( 'Clustered columnstore index', 'Nonclustered columnstore index' ))
    , GetFillFactorIndexes
   AS (   SELECT    CONCAT('[', GetIndexList.index_name, ']') AS "YesFFIndexName"
                  , GetIndexList.columns                      AS "YesFFColumns"
                  , GetIndexList.index_type                   AS "YesFFIndexType"
                  , GetIndexList.[unique]                     AS "YesFFUnique"
                  , GetIndexList.table_view                   AS "YesFFTableOrViewName"
                  , GetIndexList.object_type                  AS "YesFFObjectType"
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
                                     , 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ', FILLFACTOR = 80, MAXDOP=1);'    ---fill factor goes here 
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
                                     , 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ', FILLFACTOR = 100, MAXDOP=1);'   /*Maximum degree of parallellism must be set to 1 or the whole thing implodes*/
                                     , CHAR(13)
                                   )
                    END                                       AS "YesFFRebuildCommand"
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
SELECT  IIF(gur.IdxCommand LIKE '%PK%'
          , REPLACE(gur.IdxCommand, 'ONLINE=ON', 'ONLINE=OFF')  --SWITCH if we need to leave tables online during rebuild
          , gur.IdxCommand)
FROM    GetUnionAndRows AS gur;
