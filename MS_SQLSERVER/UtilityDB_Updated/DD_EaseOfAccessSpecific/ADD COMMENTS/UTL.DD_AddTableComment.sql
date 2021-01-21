-- =============================================
-- Author:			DaveBabler
-- Create date: 	04/25/2020
-- Description:		This will either add or wipe and update the comments on a table
-- SubProcedures:	1.	Utility.UTL.prc_DBSchemaObjectAssignment
--					2.  Utility.UTL.DD_TableExist
-- =============================================
CREATE OR ALTER PROCEDURE UTL.DD_AddTableComment
	-- Add the parameters for the stored procedure here
	@strTableName NVARCHAR(64)
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
	;
DECLARE @ustrVariantConv NVARCHAR(MAX) = CAST(@vrtComment AS NVARCHAR(MAX)); -- leaving this conversion instead of just declaring as nvarchar. Technically it IS stored as variant, people should be aware of this.
--still consider removing this conversion from production and just leaving good code comments.

DECLARE @boolCatchFlag BIT = 0;  -- for catching and throwing a specific error. 

SET @vrtComment = CAST(@strComment AS SQL_VARIANT);   --have to convert this to variant type as that's what the built in sp asks for.



BEGIN TRY
	SET NOCOUNT ON;
	--break apart the fully qualified object name
	EXEC Utility.UTL.prc_DBSchemaObjectAssignment @strTableName
												, @ustrDatabaseName OUTPUT
												, @ustrSchemaName OUTPUT
												, @ustrObjectName OUTPUT;

			/**Check to see if the column or table actually exists -- Babler*/
		
		EXEC Utility.UTL.DD_TableExist @ustrObjectName
			, @ustrDatabaseName
			, @ustrSchemaName
			, @boolExistFlag OUTPUT
			, @ustrMessageOut OUTPUT;
			print 'bool exist flag is below';
			print @boolExistFlag;
	
	
	IF @boolExistFlag = 0
	BEGIN
		--if it does not exist raise error and send to the exception tank
		SET @boolCatchFlag = 1;
/* 		SET @strErrorMessage = CONCAT('Attempt to add comment on table '
										, @ustrDatabaseName
										, '.'
										, @ustrSchemaName
										, '.'
										, @ustrObjectName
										, ';however  at least one part of the fully qualified name '
										, @ustrDatabaseName
										, '.'
										, @ustrSchemaName
										, '.'
										, @ustrObjectName
										, ' does not exist, check spelling, try again?'); */

		PRINT @strErrorMessage;

		RAISERROR (
				@ustrMessageOut
				, 11
				, 1
				);
	END
ELSE
				/**Here we have to first check to see if a MS_Description Exists
                        * If the MS_Description does not exist will will use the ADD procedure to add the comment
                        * If the MS_Description tag does exist then we will use the UPDATE procedure to add the comment
                        * Normally it's just a simple matter of ALTER TABLE/ALTER COLUMN ADD COMMENT, literally every other system
                        * however, Microsoft Has decided to use this sort of registry style of documentation 
                        * -- Dave Babler 2020-08-26*/
		SET @intRowCount = NULL;
		--future DBA's reading this...I can already hear your wailing and gnashing of teeth about SQL Injection. Stow it, on only DBA's and devs will use this, it won't be customer facing.
		SET @dSQLNotExistCheckProperties = N' SELECT NULL
											  FROM 	'
											  + QUOTENAME(@ustrDatabaseName)
											  + '.sys.extended_properties'
											  + ' WHERE [major_id] = OBJECT_ID('
											  + ''''
											  + @ustrSchemaName

											  + '.'

											  + @ustrObjectName
											  + ''''
											  + ')'
											  +	' AND [name] = N''MS_Description''
					AND [minor_id] = 0';
		PRINT @dSQLNotExistCheckProperties;

		EXEC sp_executesql @dSQLNotExistCheckProperties;

		SET @intRowCount = @@ROWCOUNT;

		PRINT @intRowCount;

		/* do an if rowcount = 0 next */
		IF @intRowCount = 0 
			BEGIN
				SET @dSQLApplyComment = N'EXEC ' 
										+ @ustrDatabaseName 
										+ '.'
										+ 'sys.sp_addextendedproperty '
										+ '@name = N''MS_Description'' '
										+ ', @value = '
										+ ''''
										+  @ustrVariantConv
										+ ''''
										+ ', @level0type = N''SCHEMA'' '
										+ ', @level0name = '
										+ ''''
										+ 	@ustrSchemaName
										+ ''''
										+ ', @level1type = N''TABLE'' '
										+ ', @level1name = '
										+ ''''
										+	@ustrObjectName
										+ '''';
				PRINT @dSQLApplyComment;
				EXEC sp_executesql @dSQLApplyComment
	
			END


			---WARNING will need to add a 'viw' looker to see if we need to do a view instead of a table
	-- 	IF NOT EXISTS (
	-- 			SELECT NULL
	-- 			FROM SYS.EXTENDED_PROPERTIES
	-- 			WHERE [major_id] = OBJECT_ID(@ustrObjectName)
	-- 				AND [name] = N'MS_Description'
	-- 				AND [minor_id] = 0
	-- 			)
    --             /** Need to execute dynamically see here
    --              https://stackoverflow.com/questions/20757804/execute-stored-procedure-from-stored-procedure-w-dynamic-sql-capturing-output 
    --               also will need to call it as [DBNAME].sys.sp_addextendedproperty*/

	-- 		EXECUTE sp_addextendedproperty @name = N'MS_Description'
	-- 			, @value = @vrtComment
	-- 			, @level0type = N'SCHEMA'
	-- 			, @level0name = @ustrSchemaName
	-- 			, @level1type = N'TABLE'
	-- 			, @level1name = @strTableName;
	-- 	ELSE
	-- 		EXECUTE sp_updateextendedproperty @name = N'MS_Description'
	-- 			, @value = @vrtComment
	-- 			, @level0type = N'SCHEMA'
	-- 			, @level0name = N'dbo'
	-- 			, @level1type = N'TABLE'
	-- 			, @level1name = @strTableName;
	-- END

	
	SET NOCOUNT OFF
END TRY

BEGIN CATCH
	IF @boolCatchFlag = 1
	BEGIN
		INSERT INTO  Utility.UTL.DB_EXCEPTION_TANK (
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
		INSERT INTO Utility.UTL.DB_EXCEPTION_TANK
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
			FROM Utility.UTL.DB_EXCEPTION_TANK
			)
		SELECT ErrorID
			, UserName
			, ErrorNumber
			, ErrorState
			, ErrorLine
			, ErrorProcedure
			, ErrorMessage
			, ErrorDateTime
		FROM Utility.UTL.DB_EXCEPTION_TANK et
		INNER JOIN mxe
			ON et.ErrorID = mxe.MaxError

		_____________________________

'
END CATCH;
/*Dynamic Queries
	-- if not exists

	-- properties if not exists

				SELECT NULL
				FROM QUOTENAME(@ustrDatabaseName).SYS.EXTENDED_PROPERTIES
				WHERE [major_id] = OBJECT_ID(@ustrObjectName)
					AND [name] = N'MS_Description'
					AND [minor_id] = 0


	*/
