USE [Utility]
GO

/****** Object:  StoredProcedure [UTL].[prc_GetPrimaryKeyColumnName]    Script Date: 5/3/2021 10:21:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Dave Babler
-- Create date: 2021-03-04
-- Description:	This procedure takes a fully qualified database object name and returns it's primary key as an output parameter
-- =============================================
CREATE OR ALTER PROCEDURE [UTL].[prc_GetPrimaryKeyColumnName]
	-- Add the parameters for the stored procedure here
	@ustrFullTableName NVARCHAR(192)
	, @ustrPrimaryKeyColumnName NVARCHAR(64) OUTPUT
AS
DECLARE @ustrDatabaseName NVARCHAR(64)
	, @ustrSchemaName NVARCHAR(64)
	, @ustrObjectName NVARCHAR(64)
	, @tsqlStatment NVARCHAR(MAX);

BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC Utility.UTL.prc_DBSchemaObjectAssignment @ustrFullTableName
		, @ustrDatabaseName OUTPUT
		, @ustrSchemaName OUTPUT
		, @ustrObjectName OUTPUT;

	SET @tsqlStatment = 
		N'
                        SELECT @ustrPrimaryKeyColumnName = COLUMN_NAME
                        FROM ' + 
		@ustrDatabaseName + 
		'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                        WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + ''.'' + QUOTENAME(CONSTRAINT_NAME)), ''IsPrimaryKey'') = 1
                        AND TABLE_NAME = ''' 
		+ @ustrObjectName + '''  AND TABLE_SCHEMA = ''' + @ustrSchemaName + '''';

	PRINT @tsqlStatment

	EXEC sp_executesql @tsqlStatment
		, N'@ustrPrimaryKeyColumnName NVARCHAR(64) OUTPUT'
		, @ustrPrimaryKeyColumnName OUTPUT;

	PRINT @ustrPrimaryKeyColumnName;
END TRY

BEGIN CATCH
	INSERT INTO CustomLog.ERR.DB_EXCEPTION_TANK (
		[DatabaseName]
		, [UserName]
		, [ErrorNumber]
		, [ErrorState]
		, [ErrorSeverity]
		, [ErrorLine]
		, [ErrorProcedure]
		, [ErrorMessage]
		, [ErrorDateTime]
		)
	VALUES (
		DB_NAME()
		, SUSER_SNAME()
		, ERROR_NUMBER()
		, ERROR_STATE()
		, ERROR_SEVERITY()
		, ERROR_LINE()
		, ERROR_PROCEDURE()
		, ERROR_MESSAGE()
		, GETDATE()
		);
END CATCH;
