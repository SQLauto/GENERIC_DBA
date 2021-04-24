-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Author:			Dave Babler
-- Create date: 	2020-08-25
-- Last Edited By:	Dave Babler
-- Last Updated:	2021-04-24
-- Description:		Checks to see if table comments exist
-- Subprocedures: 	1. [Utility].[UTL].[fn_SuppressOutput]
-- 					2. [Utility].[DD].[prc_DBSchemaObjectAssignment]
-- 					3. 
-- ==========================================================================================
CREATE
	OR

ALTER PROCEDURE DD.ShowTableComment @strTableName NVARCHAR(64)
	, @boolOptionalSuccessFlag BIT = NULL OUTPUT
	, @strOptionalMessageOut NVARCHAR(320) = NULL OUTPUT
	/** The success flag will be used when passing this to other procedures to see if table comments exist.
	 * The optional message out will be used when passing from proc to proc to make things more proceduralized.
	 * --Dave Babler 08/26/2020  */
AS
DECLARE @strMessageOut NVARCHAR(320)
	, @bitSuppressVisualOutput BIT
	, @bitIsThisAView BIT
	, @ustrDatabaseName NVARCHAR(64)
	, @ustrSchemaName NVARCHAR(64)
	, @ustrObjectName NVARCHAR(64)
	, @sqlCheckForComment NVARCHAR(8000)
	, @sqlPullComment NVARCHAR(8000);

BEGIN TRY
	/**First with procedures that are stand alone/embedded hybrids, determine if we need to suppress output by 
  * populating the data for that variable 
  * --Dave Babler */
	SELECT @bitSuppressVisualOutput = [Utility].[UTL].[fn_SuppressOutput]();

	--first blow apart the fully qualified object name
	EXEC [Utility].[DD].[prc_DBSchemaObjectAssignment] @strTableName
		, @ustrDatabaseName OUTPUT
		, @ustrSchemaName OUTPUT
		, @ustrObjectName OUTPUT;

		
		/** Next Check to see if the name is for a view instead of a table, alter the function to fit your agency's naming conventions
		 * Not necessary to check this beforehand as the previous calls will work for views and tables due to how
		 * INFORMATION_SCHEMA is set up.  Unfortunately from this point on we'll be playing with Microsoft's sys tables
		  */
		SET @bitIsThisAView = [Utility].[DD].[fn_IsThisTheNameOfAView](@ustrObjectName);

		IF @bitIsThisAView = 0
			SET @ustrViewOrTable = 'TABLE';
		ELSE
			SET @ustrViewOrTable = 'VIEW';


	IF EXISTS (
			/**Check to see if the table exists, if it does not we will output an Error Message
        * however since we are not writing anything to the DD we won't go through the whole RAISEEROR 
        * or THROW and CATCH process, a simple output is sufficient. -- Babler
        */
			SELECT 1
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = @ustrObjectName
				AND TABLE_SCHEMA = @ustrSchemaName
				AND TABLE_CATALOG = @ustrDataBaseName
			)
	BEGIN
		IF EXISTS (
				/**Check to see if the table has the extened properties on it.
                        *If it does not  will ultimately ask someone to please create 
                        * the comment on the table -- Babler */
				SELECT NULL
				FROM SYS.EXTENDED_PROPERTIES
				WHERE [major_id] = OBJECT_ID(CONCAT (
							@ustrDataBaseName
							, '.'
							, @ustrSchemaName
							, '.'
							, @ustrObjectName
							))
					AND [name] = N'MS_Description'
					AND [minor_id] = 0
				)
		BEGIN
			WITH tp (
				epTableName
				, epExtendedProperty
				)
			AS (
				SELECT OBJECT_NAME(ep.major_id) AS [epTableName]
					, ep.Value AS [epExtendedProperty]
				FROM sys.extended_properties ep
				WHERE ep.name = N'MS_Description' --sql server							 absurdly complex version of COMMENT
					AND ep.minor_id = 0 --prevents showing column comments
				)
			SELECT TOP 1 @strMessageOut = CAST(tp.epExtendedProperty AS NVARCHAR(320))
			FROM INFORMATION_SCHEMA.TABLES AS t
			INNER JOIN tp
				ON t.TABLE_NAME = tp.epTableName
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND tp.epTableName = @ustrObjectName;

			SET @boolOptionalSuccessFlag = 1;--Let any calling procedures know that there is in fact
			SET @strOptionalMessageOut = @strMessageOut;
		END
		ELSE
		BEGIN
			SET @boolOptionalSuccessFlag = 0;--let any proc calling know that there is no table comments yet.
			SET @strMessageOut = @ustrDataBaseName + '.' + @ustrSchemaName + '.' @ustrObjectName + 
				N' currently has no comments please use DD_AddTableComment to add comments!';
			SET @strOptionalMessageOut = @strMessageOut;
		END

		IF @bitSuppressVisualOutput = 0
		BEGIN
			SELECT @ustrObjectName AS 'Table Name'
				, @strMessageOut AS 'TableComment';
		END
	END
	ELSE
	BEGIN
		SET @strMessageOut = ' The table you typed in: ' + @ustrObjectName + ' ' + 'is invalid, check spelling, try again? ';

		SELECT @strMessageOut AS 'NON_LOGGED_ERROR_MESSAGE'
	END
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
END CATCH

PRINT 
	'Please check the DB_EXCEPTION_TANK an error has been raised. 
		The query between the lines below will likely get you what you need.

		_____________________________


		WITH mxe
		AS (
			SELECT MAX(ErrorID) AS MaxError
			FROM CustomLog.ERR.DB_EXCEPTION_TANK
			)
		SELECT ErrorID
			, DatabaseName
			, UserName
			, ErrorNumber
			, ErrorState
			, ErrorLine
			, ErrorProcedure
			, ErrorMessage
			, ErrorDateTime
		FROM CustomLog.ERR.DB_EXCEPTION_TANK et
		INNER JOIN mxe
			ON et.ErrorID = mxe.MaxError

		_____________________________

'
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^TESTING BLOCK^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	/* 
	DECLARE @ustrFullyQualifiedTable NVARCHAR(64) = N'';
	DECLARE @boolOptionalSuccessFlag BIT = NULL;
	DECLARE @strOptionalMessageOut NVARCHAR(320) = NULL;

	EXEC Utility.DD.ShowTableComment @ustrFullyQualifiedTable
		, @boolOptionalSuccessFlag OUTPUT
		, @strOptionalMessageOut OUTPUT;

	SELECT @boolOptionalSuccessFlag AS N'Success 🚩'
		, @strOptionalMessageOut AS 'Optional Output Message';

*/
	--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
