-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Dave Babler
-- Create date: 08/31/2020
-- Description:	This returns a list of tables and comments based on a guessed name
-- Subprocedures: 1. Utility.UTL.prc_DBSchemaObjectAssignment
-- =============================================
CREATE OR ALTER PROCEDURE UTL.DD_TableNameLike
	-- Add the parameters for the stored procedure here
	@strTableGuess NVARCHAR(194) --64*3+2periods 
AS
BEGIN
	SET NOCOUNT ON;

	/** Always lowercase fuzzy paramaters 
 *  You do not know the name; therefore,
 *  you cannot be sure of the case! -- Dave Babler */
	-- DECLARE @strTableNameLower NVARCHAR(64) = lower(@strTableGuess);--System Funcs always ALL CAPS except lower because its 'lower'
	-- DECLARE @strTableNameLowerFuzzy NVARCHAR(80) = '%' + @strTableNameLower + '%';  --split to to declare to show work, can be done one line
	DECLARE @strTableNameLowerFuzzy NVARCHAR(80)
		, @ustrDatabaseName NVARCHAR(64)
		, @ustrSchemaName NVARCHAR(64)
		, @ustrObjectName NVARCHAR(64)
		, @SQLStatementFindTables NVARCHAR(1000)
		, @SQLStatementSetDB NVARCHAR(120)
		, @ustrQuotedDB NVARCHAR(128);

	EXEC UTL.prc_DBSchemaObjectAssignment @strTableGuess
		, @ustrDatabaseName OUTPUT
		, @ustrSchemaName OUTPUT
		, @ustrObjectName OUTPUT;

	PRINT 'IN DD_TableNameLike' + @ustrSchemaName + ' ' + @ustrDatabaseName + ' ' + @ustrObjectName;

	SET @ustrQuotedDB = N'' + QUOTENAME(@ustrDatabaseName) + '';
	SET @SQLStatementSetDB = N'USE ' + QUOTENAME(@ustrDatabaseName) + '';

	PRINT @SQLStatementSetDB;

	EXECUTE (@SQLStatementSetDB);

	SET @strTableNameLowerFuzzy = '%' + lower(@ustrObjectName) + '%';
	/**When creating dynamic SQL leave one fully working example with filled in paramaters
* This way when the next person to come along to debug it sees it they know exactly what you are looking for
* I recommend putting it at the end of the code commented out with it's variable name so it doesn't create 
* code clutter. --Dave Babler */
	SET @SQLStatementFindTables = 
		'  
                                SELECT 	sysObj.name AS "TableName"
	                            , ep.value AS "TableDescription" 
                                FROM ' + @ustrQuotedDB + '.sys.objects sysObj
                                INNER JOIN ' + @ustrQuotedDB + '.sys.tables sysTbl
                                    ON sysTbl.object_id = sysObj.object_id
								INNER JOIN ' + @ustrQuotedDB + '.sys.schemas ss
									on 	sysObj.schema_id = ss.schema_id
                                LEFT JOIN ' + @ustrQuotedDB + '.sys.extended_properties ep
                                    ON ep.major_id = sysObj.object_id
                                        AND ep.name = ''MS_Description''
                                        AND ep.minor_id = 0
                                WHERE lower(sysObj.name) LIKE  @strTbl
								AND ss.name = @strSchema'
		;

	EXECUTE sp_executesql @SQLStatementFindTables
		, N'@ustrQtDB NVARCHAR(80), @strTbl NVARCHAR(80), @strSchema NVARCHAR(64)'
		, @ustrQtDB = @ustrQuotedDB
		, @strTbl = @strTableNameLowerFuzzy
		, @strSchema = @ustrSchemaName;

	SET NOCOUNT OFF;
		--@SQLStatementFindTables working example is below.
		-- SELECT --t.id                        as  "object_id",
		-- 	sysObj.name AS "TableName"
		-- 	, ep.value AS "TableDescription"
		-- FROM sysobjects sysObj
		-- INNER JOIN ' + @ustrQuotedDB + '.sys..tables sysTbl
		-- 	ON sysTbl.object_id = sysObj.id
		-- LEFT JOIN ' + @ustrQuotedDB + '.sys..extended_properties ep
		-- 	ON ep.major_id = sysObj.id
		-- 		AND ep.name = 'MS_Description'
		-- 		AND ep.minor_id = 0
		-- WHERE lower(sysObj.name) LIKE '%tank%'
END
