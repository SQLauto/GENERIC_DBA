SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Dave Babler
-- Create date: 08/26/2020
-- Description:	This makes adding comments to columns in SQLServer far more accessible than before.
-- =============================================
CREATE
	OR

ALTER PROCEDURE DD_AddColumnComment
	-- Add the parameters for the stored procedure here
	@strTableName NVARCHAR(64)
	, @strColumnName NVARCHAR(64)
	, @strComment NVARCHAR(360)
AS
/**Note: vrt is for Variant, which is the absurd way SQL Server stores it's Strings in the data dictionary
* supposedly for 'security' --Dave Babler*/
DECLARE @vrtComment SQL_VARIANT
	, @strErrorMessage VARCHAR(MAX)
	, @ustrDatabaseName NVARCHAR(64)
	, @ustrSchemaName NVARCHAR(64)
	, @ustrObjectName NVARCHAR(64)
	, @dSQLNotExistCheck NVARCHAR(MAX)
	, @dSQLNotExistCheckProperties NVARCHAR(MAX) -- could recycle previous var, don't want to
	, @dSQLApplyComment NVARCHAR(MAX) -- will use the same  dynamic sql variable name regardless of wether or not we add or update hence 'apply'
	, @intRowCount INT
	, @boolExistFlag BIT
	, @ustrMessageOut NVARCHAR(400)
	, @bitIsThisAView BIT
	, @ustrViewOrTable NVARCHAR(8)
	;

DECLARE @boolCatchFlag BIT = 0;  -- for catching and throwing a specific error. 
	--set and internally cast the VARIANT, I know it's dumb, but it's what we have to do.
SET @vrtComment = CAST(@strComment AS SQL_VARIANT);   --have to convert this to variant type as that's what the built in sp asks for.

DECLARE @ustrVariantConv NVARCHAR(MAX) = REPLACE(CAST(@vrtComment AS NVARCHAR(MAX)),'''',''''''); 
/** Explanation of the conversion above.
 *	1. 	I wanted to leave this conversion instead of just declaring as NVARCHAR. 
 *		Technically it IS stored as variant, people should be aware of this.
 *	2.	We need to deal with quotes passed in for Contractions such as "can't" which would be passed in as "can''t"
 */

BEGIN TRY
	SET NOCOUNT ON;

	IF NOT EXISTS (
			/**Check to see if the column or table actually exists -- Babler*/
			SELECT 1
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = @strTableName
				AND COLUMN_NAME = @strColumnName
			)
	BEGIN
		--if it does not exist raise error and send to the exception tank
		SET @boolCatchFlag = 1;
		SET @strErrorMessage = 'Attempt to add comment on column ' + @strColumnName + ' of ' + @strTableName + ';however, either ' + 
			@strColumnName + ' or ' + @strTableName + ' does not exist, check spelling, try again?';

		RAISERROR (
				@strErrorMessage
				, 11
				, 1
				);
	END
	ELSE
	BEGIN
				/**Here we have to first check to see if a MS_Description Exists
                * If the MS_Description does not exist will will use the ADD procedure to add the comment
                * If the MS_Description tag does exist then we will use the UPDATE procedure to add the comment
                * Normally it's just a simple matter of ALTER TABLE/ALTER COLUMN ADD COMMENT, literally every other system
                * however, Microsoft Has decided to use this sort of registry style of documentation 
                * -- Dave Babler 2020-08-26*/
		IF NOT EXISTS (
				SELECT NULL
				FROM SYS.EXTENDED_PROPERTIES
				WHERE [major_id] = OBJECT_ID(@strTableName)
					AND [name] = N'MS_Description'
					AND [minor_id] = (
						SELECT [column_id]
						FROM SYS.COLUMNS
						WHERE [name] = @strColumnName
							AND [object_id] = OBJECT_ID(@strTableName)
						)
				)
			EXECUTE sp_addextendedproperty @name = N'MS_Description'
				, @value = @vrtComment
				, @level0type = N'SCHEMA'
				, @level0name = N'dbo'
				, @level1type = N'TABLE'
				, @level1name = @strTableName
				, @level2type = N'COLUMN'
				, @level2name = @strColumnName;
		ELSE
			EXECUTE sp_updateextendedproperty @name = N'MS_Description'
				, @value = @vrtComment
				, @level0type = N'SCHEMA'
				, @level0name = N'dbo'
				, @level1type = N'TABLE'
				, @level1name = @strTableName
				, @level2type = N'COLUMN'
				, @level2name = @strColumnName;
	END
END TRY

BEGIN CATCH
	IF @boolCatchFlag = 1
	BEGIN
		INSERT INTO dbo.DB_EXCEPTION_TANK (
			UserName
			, ErrorState
			, ErrorSeverity
			, ErrorProcedure
			, ErrorMessage
			, ErrorDateTime
			)
		VALUES (
			SUSER_SNAME()
			, ERROR_STATE()
			, ERROR_SEVERITY()
			, ERROR_PROCEDURE()
			, ERROR_MESSAGE()
			, GETDATE()
			);
	END
	ELSE
	BEGIN
		INSERT INTO dbo.DB_EXCEPTION_TANK
		VALUES (
			SUSER_SNAME()
			, ERROR_NUMBER()
			, ERROR_STATE()
			, ERROR_SEVERITY()
			, ERROR_PROCEDURE()
			, ERROR_LINE()
			, ERROR_MESSAGE()
			, GETDATE()
			);
	END

	PRINT 
		'Please check the DB_EXCEPTION_TANK an error has been raised. 
		The query between the lines below will likely get you what you need.

		_____________________________


		WITH mxe
		AS (
			SELECT MAX(ErrorID) AS MaxError
			FROM DB_EXCEPTION_TANK
			)
		SELECT ErrorID
			, UserName
			, ErrorNumber
			, ErrorState
			, ErrorLine
			, ErrorProcedure
			, ErrorMessage
			, ErrorDateTime
		FROM DB_EXCEPTION_TANK et
		INNER JOIN mxe
			ON et.ErrorID = mxe.MaxError

		_____________________________

'
END CATCH;
