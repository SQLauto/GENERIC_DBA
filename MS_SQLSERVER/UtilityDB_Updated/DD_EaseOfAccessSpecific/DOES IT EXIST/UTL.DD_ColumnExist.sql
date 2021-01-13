-- ==========================================================================================
-- Author:		    Dave Babler
-- Create date:     08/25/2020
-- Last Modified:   11/23/2020
-- Description:	    Checks to see if column in table exists 
--                  use output boolean for logic flow in other procedures
-- 					This will work just fine for Views without further modifciation.
-- ==========================================================================================
CREATE
	OR

ALTER PROCEDURE UTL.DD_ColumnExist @ustrTableName NVARCHAR(64)
	, @ustrColumnName NVARCHAR(64)
	, @ustrDBName NVARCHAR(64) --SHOULD BE PASSED IN FROM ANOTHER PROC
	, @ustrSchemaName NVARCHAR(64) --SHOULD BE PASSED IN FROM ANOTHER PROC
	, @boolSuccessFlag BIT OUTPUT
	, @ustrMessageOut NVARCHAR(400) = NULL OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	/** If the table doesn't exist we're going to output a message and throw a false flag,
     *  ELSE we'll throw a true flag so external operations can commence
     * Dave Babler 2020-08-26  */
	DECLARE @ustrQuotedDB NVARCHAR(128) = N'' + QUOTENAME(@ustrDBName) + '';
	DECLARE @intRowCount INT;
	DECLARE @SQLCheckForTable NVARCHAR(1000) = 'SELECT 1 
                               FROM ' + @ustrQuotedDB + 
		'.INFORMATION_SCHEMA.COLUMNS 
                               WHERE TABLE_NAME = @ustrTable 
                                    AND TABLE_SCHEMA = @ustrSchema
                                    	AND COLUMN_NAME = @ustrColumn'
		;




	EXECUTE sp_executesql @SQLCheckForTable
		, N'@ustrTable NVARCHAR(64), 
            @ustrSchema NVARCHAR(64),
            @ustrColumn NVARCHAR(64)'
		, @ustrTable = @ustrTableName
		, @ustrSchema = @ustrSchemaName
        , @ustrColumn = @ustrColumnName;




    IF @intRowCount <> 1
	BEGIN
		SET @boolSuccessFlag = 0;
		SET @ustrMessageOut = @ustrColumnName + ' of ' + @ustrTableName + ' does not exist, check spelling, try again?';
	END
	ELSE
	BEGIN
		SET @boolSuccessFlag = 1;
		SET @ustrMessageOut = NULL;
	END

	SET NOCOUNT OFF;
END TRY

BEGIN CATCH
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
END CATCH;
