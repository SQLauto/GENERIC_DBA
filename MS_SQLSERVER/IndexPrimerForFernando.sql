--find indexes that are badly fragmented WARNING TAKES FOREVER!
SELECT S.name AS 'Schema'
	, T.name AS 'Table'
	, I.name AS 'Index'
	, DDIPS.avg_fragmentation_in_percent
	, DDIPS.page_count
FROM sys.dm_db_index_physical_stats(DB_ID([yourdatabaseforINDEXES]), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T
	ON T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S
	ON T.schema_id = S.schema_id
INNER JOIN sys.indexes I
	ON I.object_id = DDIPS.object_id
		AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
	AND I.name IS NOT NULL
	AND DDIPS.avg_fragmentation_in_percent > 0
ORDER BY DDIPS.avg_fragmentation_in_percent DESC

SET STATISTICS TIME ON;

SELECT fbc.*
FROM [dbo].[Fund_Balance__c] fbc
LEFT JOIN PayoutPathElection ppe
	ON fbc.Payout_Path_Election__c = ppe.Id;

SET STATISTICS TIME OFF;

---
ALTER INDEX IX_Fund_Balance__c_Payout_Path_Election__c ON Fund_Balance__c REBUILD -- REBUILD TAKES TABLES OFFLINE

/* --Basic Rebuild Command
ALTER INDEX Index_Name ON Table_Name REBUILD
 
--REBUILD Index with ONLINE OPTION
ALTER INDEX Index_Name ON Table_Name REORGANIZE WITH ( LOB_COMPACTION = ON )
GO

--- */
SET STATISTICS TIME ON;

SELECT fbc.*
FROM [dbo].[Fund_Balance__c] fbc
LEFT JOIN PayoutPathElection ppe
	ON fbc.Payout_Path_Election__c = ppe.Id
OPTION (RECOMPILE);

SET STATISTICS TIME OFF;
----

DBCC FREESYSTEMCACHE('ALL');
DBCC FREEPROCCACHE;
EXEC sp_updatestats;

----
SET STATISTICS TIME ON;

SELECT fbc.*
FROM [dbo].[Fund_Balance__c] fbc WITH (INDEX (IX_Fund_Balance__c_Payout_Path_Election__c))
LEFT JOIN PayoutPathElection ppe
	ON fbc.Payout_Path_Election__c = ppe.Id
OPTION (RECOMPILE);

SET STATISTICS TIME OFF;


---AND THIS IS WHY WE ARE CAREFUL ABOUT REBUILDING INDEXES!
--REUBILDS ALL INDEXES ON DB OR TABLE DO NOT USE
DBCC DBREINDEX ('DatabaseName', 'TableName'); ---do not use!  try manual targets first!

--REORGANIZES ALL INDEXES ON DB OR TABLE
DBCC INDEXDEFRAG('DatabaseName', 'TableName'); --probably don't use?!  



--ALWAYS CLEAR YOUR CACHES AND UPDATE STATS AFTER INDEX MANIPULATION