USE DATABASE_NAME;
GO

SELECT	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS "IndexInfoID"
	  , OBJECT_NAME(IPS.object_id) AS "TableName"
	  , SI.is_disabled AS "IndexID"
	  , SI.name AS "IndexName"
	  , IPS.index_type_desc AS "IndexTypeDescription"
	  , IPS.avg_fragmentation_in_percent AS "AverageFratmentationPercent"
	  , IPS.avg_fragment_size_in_pages AS "AverageFragmentSizeInPages"
	  , IPS.avg_page_space_used_in_percent AS "AveragePageSpaceUsedInPercent"
	  , IPS.record_count AS "RecordCount"
	  , IPS.ghost_record_count AS "GhostRecordCount"
	  , IPS.fragment_count AS "FragmentCount"
	  , CAST(GETDATE() AS DATE) AS "DateIndexInfoCollected"
INTO	Utility.IDXFRAG.DATABASE_NAME_Detailed
FROM	sys.dm_db_index_physical_stats(DB_ID(N'DATABASE_NAME'), NULL, NULL, NULL, 'DETAILED') AS IPS
JOIN sys.tables AS ST WITH (NOLOCK)
  ON IPS.object_id = ST.object_id
JOIN sys.indexes AS SI WITH (NOLOCK)
  ON IPS.object_id = SI.object_id
	  AND	IPS.index_id = SI.index_id
WHERE	ST.is_ms_shipped = 0
ORDER BY
	avg_fragmentation_in_percent DESC
  , TableName ASC;
GO

ALTER TABLE Utility.IDXFRAG.DATABASE_NAME_Detailed
ALTER COLUMN IndexInfoID INT NOT NULL;
GO

ALTER TABLE Utility.IDXFRAG.DATABASE_NAME_Detailed
ADD CONSTRAINT PK_DATABASE_NAME_Detailed PRIMARY KEY (IndexInfoID);