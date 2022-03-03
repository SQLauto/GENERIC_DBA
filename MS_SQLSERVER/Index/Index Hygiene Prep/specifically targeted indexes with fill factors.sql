:SETVAR DBNAME "Pain"

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

USE [$(DBNAME)];
GO

USE [$(DBNAME)];
GO

ALTER INDEX CIX_PhysicianMain_FullName
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CIX_PhysicianMain_IDBillingNameDEALicNumber
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CVI_ClinicMain_API_Password_NN
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CVIX_ClinicMain_ID_API_Full_NN
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CVIX_PhysicianMain_Email_NN
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CVIX_PhysicianMain_Pass_NN
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CVIX_StaffMain_Email_NN
	ON dbo.StaffMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX CVIX_StaffMain_Pass_NN
	ON dbo.StaffMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_AHC_10_9_PatientMain
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_AHC_2470_2469_PatientMain
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

PRINT 'Just Rebuilt IX_AHC_2470_2469_PatientMain';

ALTER INDEX IX_AHC_593_592_ClinicMain
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_AHC_820_819_ClinicMain
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_AHC_822_821_PatientMain
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_ClinicName
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_DOB
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF);
GO

ALTER INDEX IX_Email
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_FacilityID
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF);
GO

ALTER INDEX IX_FirstName
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_LastName
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

PRINT 'JustRebuild IX_LastNane';

ALTER INDEX IX_MarkupType_IncIDBillingIDNameDOBEmailSpecies
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_PhysicianMain_DEA_Number
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_PhysicianMain_Email
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_Solomon
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_SolomonID
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_Source
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF);
GO

ALTER INDEX IX_StaffMain
	ON dbo.StaffMain
	REBUILD
	WITH (ONLINE = OFF);
GO

ALTER INDEX IX_StaffMain_Email
	ON dbo.StaffMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_StandingPO
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_TaxID
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX IX_UCF
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX missing_index_481_480_PatientMain
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX PK_ClinicMain
	ON dbo.ClinicMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX PK_Facility
	ON dbo.Facility
	REBUILD
	WITH (ONLINE = OFF);
GO

ALTER INDEX PK_PatientMain
	ON dbo.PatientMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX PK_PhysicianMain
	ON dbo.PhysicianMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

ALTER INDEX PK_StaffMain_PK_StaffID
	ON dbo.StaffMain
	REBUILD
	WITH (ONLINE = OFF, FILLFACTOR = 80);
GO

GO

ALTER DATABASE $(DBNAME)
	SET QUERY_STORE CLEAR;

ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);

PRINT 'Index Rebuilds done first clears done, moving on to refreshing views....mmmmmmmsooooo refreshing!';

USE [$(DBNAME)];
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT	@sql += N'EXEC sp_refreshview ''' + [name] + N'''' + CHAR(10)
FROM	sys.objects
WHERE
	[type] IN ( 'V' );

EXEC (@sql);

USE [$(DBNAME)];
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT	@sql += N'EXEC sp_recompile ''' + [name] + N'''' + CHAR(10)
FROM	sys.objects
WHERE
	[type] IN ( 'P', 'FN', 'IF' );

EXEC (@sql);


EXEC sp_MSForEachTable 'UPDATE STATISTICS ? WITH FULLSCAN;'

PRINT 'I am done with the statistics!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

USE $(DBNAME);
GO

ALTER DATABASE $(DBNAME)
	SET QUERY_STORE CLEAR;

USE $(DBNAME);
GO

ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;

DECLARE @intDBID INT = DB_ID(); /*I straight up do not feel like doing find and replace to build these scripts. So I will be lazy -Babler*/
DECLARE @ustrDBNAME NVARCHAR(80) = DB_NAME();

DBCC FREESYSTEMCACHE(@ustrDBNAME);

DBCC FLUSHPROCINDB(@intDBID);
