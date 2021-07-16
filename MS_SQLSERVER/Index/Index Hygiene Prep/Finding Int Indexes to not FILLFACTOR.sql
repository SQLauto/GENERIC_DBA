/*Surgically Targeting Indexes: 
	Instructions: Fill your TableVariable 
	Make sure you have the corresponding script.
	Make sure that script has an INT that matches the variable here for the tracking table
	also make sure it has the string char so you can build that list of tables and stuff */

DECLARE @strOnlineOnOrOff CHAR(3) = 'O';
DECLARE @ustrTableList NVARCHAR(2160);
DECLARE @ustrInsertStatement NVARCHAR(MAX);
DECLARE @ustrUpdateStatement NVARCHAR(MAX);

DECLARE @tblTBlNamesToTarget TABLE
(
	TargetTableName NVARCHAR(64) NOT NULL PRIMARY KEY
);

/*Just do one schema and one database at a time for now.  Thanks!  ~Babler */
INSERT INTO @tblTBlNamesToTarget (TargetTableName)
VALUES
	('CustomerServiceScriptInstruction')
  , ('Script')
  , ('ScriptStatus')
  , ('OrderMain')
  , ('DispenseType')
  , ('Department')
  , ('PhysicianMain')
  , ('PatientMain')
  , ('PrepClass');

SET @ustrUpdateStatement = N'UPDATE [LOADTEST].[EventTracker]
   SET [EventEndingDateTime] = GETDATE()
   WHERE EventID =  @intEventID ;';

;WITH GetTables
AS (SELECT
		(
			SELECT	CONCAT(TargetTableName, ', ')
			FROM	@tblTBlNamesToTarget
			ORDER BY TargetTableName
			FOR XML PATH('')
		) AS "TableLister")
	, PrepTheNoteVariable
AS (SELECT	CONCAT(
					  N'⚠AGGRESSIVE Index Hygiene was done on one of the following tables: '
					, SUBSTRING(TableLister, 0, LEN(TableLister) - 0)
					, '.'
				  ) AS "PreppedInfo"
	FROM	GetTables)
SELECT @ustrTableList  = PreppedInfo FROM PrepTheNoteVariable  ;

SELECT	@ustrInsertStatement = CONCAT(
										 N'INSERT INTO [LOADTEST].[EventTracker]
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

WITH GetIndexList
AS (SELECT	CAST(i.name AS NVARCHAR(80)) AS "index_name"
		  , SUBSTRING(column_names, 1, LEN(column_names) - 1) AS "columns"
		  , CASE
				WHEN i.type = 1 THEN 'Clustered index'
				WHEN i.type = 2 THEN 'Nonclustered unique index'
				WHEN i.type = 3 THEN 'XML index'
				WHEN i.type = 4 THEN 'Spatial index'
				WHEN i.type = 5 THEN 'Clustered columnstore index'
				WHEN i.type = 6 THEN 'Nonclustered columnstore index'
				WHEN i.type = 7 THEN 'Nonclustered hash index'
			END AS "index_type"
		  , CASE WHEN i.is_unique = 1 THEN 'Unique' ELSE 'Not unique' END AS "unique"
		  , SCHEMA_NAME(t.schema_id) + '.' + t.name AS "table_view"
		  , CASE WHEN t.type = 'U' THEN 'Table' WHEN t.type = 'V' THEN 'View' END AS "object_type"
	FROM	Pain.sys.objects AS t
	INNER JOIN Pain.sys.indexes AS i
			ON t.object_id = i.object_id
	CROSS APPLY
		(
			SELECT	CONCAT(col.name, ' Type: ', st.name) + ', '
			FROM	Pain.sys.index_columns AS ic
			INNER JOIN Pain.sys.columns AS col
					ON ic.object_id = col.object_id
						AND ic.column_id = col.column_id
			INNER JOIN Pain.sys.types AS st
					ON col.system_type_id = st.system_type_id
			WHERE
				ic.object_id = t.object_id
				AND ic.index_id = i.index_id
			ORDER BY key_ordinal
			FOR XML PATH('')
		) AS D(column_names)
	WHERE
		t.name IN
			(
				SELECT TargetTableName FROM		@tblTBlNamesToTarget
			)
		AND index_id > 0)
   , GetNoFillFactorIdxs
AS (SELECT	GetIndexList.index_name AS "NoFFIndexName"
		  , GetIndexList.columns AS "NoFFColumns"
		  , GetIndexList.index_type AS "NoFFIndexType"
		  , GetIndexList.[unique] AS "NoFFUnique"
		  , GetIndexList.table_view AS "NoFFTableorViewName"
		  , GetIndexList.object_type AS "NoFFObjectType"
		  , CONCAT(
					  'ALTER INDEX '
					, GetIndexList.index_name
					, ' ON '
					, CHAR(13)
					, GetIndexList.table_view
					, CHAR(32)
					, 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ');'
				  ) AS "NoFFRebuildCommand"
	FROM	GetIndexList
	WHERE
		(
			GetIndexList.columns LIKE '%int'
			OR	GetIndexList.columns LIKE '%date%'
		)
		AND LEN(GetIndexList.columns) < 64)
   , GetFillFactorIndexes
AS (SELECT	GetIndexList.index_name AS "YesFFIndexName"
		  , GetIndexList.columns AS "YesFFColumns"
		  , GetIndexList.index_type AS "YesFFIndexType"
		  , GetIndexList.[unique] AS "YesFFUnique"
		  , GetIndexList.table_view AS "YesFFTableOrViewName"
		  , GetIndexList.object_type AS "YesFFObjectType"
		  , CONCAT(
					  'ALTER INDEX '
					, GetIndexList.index_name
					, ' ON '
					, CHAR(13)
					, GetIndexList.table_view
					, CHAR(32)
					, 'REBUILD WITH (ONLINE=' + @strOnlineOnOrOff + ', FILLFACTOR = 80);'
					, CHAR(13)
				  ) AS "YesFFRebuildCommand"
	FROM	GetIndexList
	WHERE	NOT EXISTS
		(
			SELECT	1
			FROM	GetNoFillFactorIdxs
			WHERE	GetNoFillFactorIdxs.NoFFIndexName = GetIndexList.index_name
		))
   , GetUnionAndRows
AS (SELECT	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS "RowCounter"
		  , IdxCommand
	FROM
		(
			SELECT	nfi.NoFFRebuildCommand AS "IdxCommand"
			FROM	GetNoFillFactorIdxs AS nfi
			UNION
			SELECT	yfi.YesFFRebuildCommand AS "IdxCommand"
			FROM	GetFillFactorIndexes AS yfi
		) AS UI /* Breaking apart this to a CTE would be overkill, maybe.  */)
   , FinalEdits
AS (SELECT	CASE
				WHEN gur.RowCounter % 10 = 0
					OR	gur.RowCounter = 1 THEN
				CONCAT(CONCAT(CHAR(10), CHAR(13)), @ustrInsertStatement, CONCAT(CHAR(10), CHAR(13)), gur.IdxCommand)
				WHEN CAST(RIGHT(CAST(gur.RowCounter AS NVARCHAR(16)), 1) AS INT) = 9 THEN
				CONCAT(gur.IdxCommand, CONCAT(CHAR(10), CHAR(13), @ustrUpdateStatement, CONCAT(CHAR(10), CHAR(13))))
				ELSE gur.IdxCommand
			END AS "Commands"
	FROM	GetUnionAndRows AS gur)
SELECT FinalEdits.Commands FROM		FinalEdits;