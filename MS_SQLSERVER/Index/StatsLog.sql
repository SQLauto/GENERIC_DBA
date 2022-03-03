USE DATABASE_NAME;

SELECT	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS "StatisticsInfoID"
	  , obj.name AS "TableName"
	  , obj.object_id AS "ObjectID"
	  , stat.stats_id AS "StatisticsID"
	  , stat.name AS "StatisticsName"
	  , last_updated AS "LastTimeStatistcsWereUpdated"
	  , modification_counter AS "NumberOfModificationsToTableSinceLastStatsUpdate"
INTO	Utility.IDXFRAG.DATABASE_NAME_Stats
FROM	sys.objects AS obj
INNER JOIN sys.stats AS stat
		ON stat.object_id = obj.object_id
CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
WHERE	modification_counter > 100;

ALTER TABLE Utility.IDXFRAG.DATABASE_NAME_Stats
ALTER COLUMN StatisticsInfoID INT NOT NULL;
GO

ALTER TABLE Utility.IDXFRAG.DATABASE_NAME_Stats
ADD CONSTRAINT PK_DATABASE_NAMEStats PRIMARY KEY (StatisticsInfoID);