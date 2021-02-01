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
	, @bitIsThisAView BIT
	, @ustrViewOrTable NVARCHAR(8)
	;
--still consider removing this conversion from production and just leaving good code comments.

DECLARE @boolCatchFlag BIT = 0;  -- for catching and throwing a specific error. 
	--set and internally cast the VARIANT, I know it's dumb, but it's what we have to do.
SET @vrtComment = CAST(@strComment AS SQL_VARIANT);   --have to convert this to variant type as that's what the built in sp asks for.
DECLARE @ustrVariantConv NVARCHAR(MAX) = CAST(@vrtComment AS NVARCHAR(MAX)); -- leaving this conversion instead of just declaring as nvarchar. Technically it IS stored as variant, people should be aware of this.



BEGIN TRY
	SET NOCOUNT ON;
	--break apart the fully qualified object name
	EXEC Utility.UTL.prc_DBSchemaObjectAssignment @strTableName
												, @ustrDatabaseName OUTPUT
												, @ustrSchemaName OUTPUT
												, @ustrObjectName OUTPUT;

PRINT 'BELOW SHOULD BE databaseschemaobject';

PRINT  @ustrDatabaseName + @ustrSchemaName + @ustrObjectName;


			/**Check to see if the column or table actually exists -- Babler*/
		
		EXEC Utility.UTL.DD_TableExist @ustrObjectName
			, @ustrDatabaseName
			, @ustrSchemaName
			, @boolExistFlag OUTPUT
			, @ustrMessageOut OUTPUT;
			print 'bool exist flag is below';
			print @boolExistFlag;
	

		/** Next Check to see if the name is for a view instead of a table, alter the function to fit your agency's naming conventions
		 * Not necissary to check this beforehand as the previous calls will work for views and tables due to how
		 * INFORMATION_SCHEMA is set up.  Unfortunately from this point on we'll be playing with Microsoft's sys tables
		  */
		SET @bitIsThisAView = Utility.UTL.fn_IsThisTheNameOfAView(@ustrObjectName);

		IF @bitIsThisAView = 0
			SET @ustrViewOrTable = 'TABLE';
		ELSE
			SET @ustrViewOrTable = 'VIEW';

	IF @boolExistFlag = 0
	BEGIN

		SET @boolCatchFlag = 1;

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
		--future DBA's reading this...I can already hear your wailing and gnashing of teeth about SQL Injection. Stow it, only DBA's and devs will use this, it won't be customer facing.
		SET @dSQLNotExistCheckProperties = N' SELECT NULL
											  FROM 	'
											  + QUOTENAME(@ustrDatabaseName)
											  + '.sys.extended_properties'
											  + ' WHERE [major_id] = OBJECT_ID('
											  + ''''
											  + @ustrDatabaseName

											  + '.'
											  + @ustrSchemaName

											  + '.'

											  + @ustrObjectName
											  + ''''
											  + ')'
											  +	' AND [name] = N''MS_Description''
					AND [minor_id] = 0';
		PRINT 'Existance check SQL below';
		PRINT @dSQLNotExistCheckProperties;

		EXEC sp_executesql @dSQLNotExistCheckProperties;

		SET @intRowCount = @@ROWCOUNT;
		PRINT 'Rowcount Below';
		PRINT @intRowCount;

		/* do an if rowcount = 0 next */
		IF @intRowCount = 0 
			BEGIN
				PRINT 'IN IF STATEMENT!';
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
										+ ', @level1type = N'
										+ ''''
										+ 	@ustrViewOrTable
										+ ''''										
										+ ', @level1name = '
										+ ''''
										+	@ustrObjectName
										+ '''';


			PRINT CAST(@dSQLApplyComment AS VARCHAR(MAX));
			END
		ELSE
			BEGIN 
				--DYNAMIC SQL FOR UPDATE EXTENDED PROPERTY GOES HERE.
								SET @dSQLApplyComment = N'EXEC ' 
										+ @ustrDatabaseName 
										+ '.'
										+ 'sys.sp_updateextendedproperty  '
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
										+ ', @level1type = N'
										+ ''''
										+ 	@ustrViewOrTable
										+ ''''										
										+ ', @level1name = '
										+ ''''
										+	@ustrObjectName
										+ '''';

			END
				PRINT 'Apply sql comment is below';
				PRINT @dSQLApplyComment;
				EXEC sp_executesql @dSQLApplyComment


	SET NOCOUNT OFF
END TRY

BEGIN CATCH
	IF @boolCatchFlag = 1
	BEGIN

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
	END
	ELSE
	BEGIN

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
	END

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
END CATCH;
	/*Dynamic Queries
		-- properties if not exists

					SELECT NULL
					FROM QUOTENAME(@ustrDatabaseName).SYS.EXTENDED_PROPERTIES
					WHERE [major_id] = OBJECT_ID(@ustrObjectName)
						AND [name] = N'MS_Description'
						AND [minor_id] = 0

        -- add the properties  if they don't exist
                --be advised trying to run this without dynamic sql call will not work.
            
		      EXECUTE @ustrDatabaseName.sp_addextendedproperty @name = N'MS_Description'
		          , @value = @vrtComment
		          , @level0type = N'SCHEMA'
		          , @level0name = @ustrSchemaName
		          , @level1type = N'TABLE'
		          , @level1name = @strTableName;

        -- replace the properties  if they already exist
                --be advised trying to run this without dynamic sql call will not work.
              EXECUTE @ustrDatabaseName.sp_updateextendedproperty @name = N'MS_Description'
		          , @value = @vrtComment
		          , @level0type = N'SCHEMA'
		          , @level0name = N'dbo'
		          , @level1type = N'TABLE'
		          , @level1name = @strTableName;
            
		*/

	--Bibliography
	--   https://stackoverflow.com/questions/20757804/execute-stored-procedure-from-stored-procedure-w-dynamic-sql-capturing-output 
