SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Dave Babler
-- Create date: 	2020-08-25
-- Last Edited By:	Dave Babler
-- Last Updated:	2021-04-24
-- Description:	    This procedure makes viewing comments on a single column much more accessible.
-- Subprocedures: 	1. [Utility].[UTL].[fn_SuppressOutput]
-- 					2. [Utility].[DD].[prc_DBSchemaObjectAssignment]
-- 					3. [Utility].[DD].[prc_ColumnExist]
--  				4. [Utility].[DD].[fn_IsThisTheNameOfAView]
-- ==========================================================================================
CREATE or alter  PROCEDURE [DD].[ShowColumnComment] 
	-- Add the parameters for the stored procedure here
	@strTableName NVARCHAR(64)
	, @ustrColumnName NVARCHAR(64)
AS


DECLARE @ustrMessageOut NVARCHAR(320)
, @ustrDatabaseName NVARCHAR(64) 
, @ustrSchemaName NVARCHAR(64)
, @ustrObjectName  NVARCHAR(64)
, @intRowCount INT
, @boolExistFlag BIT
, @dSQLCheckForComment NVARCHAR(MAX)
, @dSQLPullComment NVARCHAR(MAX)
, @dSQLPullCommentParameters NVARCHAR(MAX); 
DROP TABLE IF EXISTS #__SuppressOutputColumnComment
CREATE TABLE #__SuppressOutputColumnComment(
	SuppressedOutput VARCHAR(MAX)
)
BEGIN TRY
EXEC [Utility].[DD].[prc_DBSchemaObjectAssignment] @strTableName
	, @ustrDatabaseName OUTPUT
	, @ustrSchemaName OUTPUT
	, @ustrObjectName OUTPUT;

EXEC [Utility].[DD].[prc_ColumnExist] @ustrObjectName
	, @ustrColumnName
	, @ustrDatabaseName
	, @ustrSchemaName
	, @boolExistFlag OUTPUT
	, @ustrMessageOut OUTPUT;

    IF @boolExistFlag = 1
       BEGIN 
    
                /**Check to see if the column has the extened properties on it.
                 *If it does not  will ultimately ask someone to please create 
                 * the comment on the column -- Babler */
                SET @intRowCount = 0;
                SET @dSQLCheckForComment = N'
                    SELECT 1
                    FROM ' + QUOTENAME(@ustrDatabaseName) + '.sys.extended_properties
                    WHERE [major_id] = OBJECT_ID('  
                    	                      + ''''
											  + @ustrDatabaseName
											  + '.'
											  + @ustrSchemaName
											  + '.'
											  + @ustrObjectName
											  + ''''
                                         + ')
                        AND [name] = N''MS_Description''
                        AND [minor_id] = (
                            SELECT [column_id]
                            FROM ' + QUOTENAME(@ustrDatabaseName) + '.sys.columns
                            WHERE [name] = ' 
                            + ''''
                            + @ustrColumnName 
                            + ''''
                            +'
                                AND [object_id] = OBJECT_ID('  
                    	                      + ''''
											  + @ustrDatabaseName
											  + '.'
											  + @ustrSchemaName
											  + '.'
											  + @ustrObjectName
											  + ''''
                                         + ')
                            )
                    ';
                                    PRINT @intRowCount
                PRINT @dSQLCheckForComment
                INSERT INTO #__SuppressOutputColumnComment
                EXEC sp_executesql @dSQLCheckForComment;
                
                SET @intRowCount = @@ROWCOUNT
                PRINT @intRowCount;
        IF @intRowCount = 1
            BEGIN
            SET @dSQLPullComment = N'
                SELECT TOP 1 @ustrMessageOutTemp = CAST(ep.value AS  NVARCHAR(320))
                FROM '
                + QUOTENAME(@ustrDataBaseName)
                + '.sys.extended_properties AS ep
                INNER JOIN '
                + QUOTENAME(@ustrDataBaseName)
                + '.sys.all_objects AS ob
                    ON ep.major_id = ob.object_id
                INNER JOIN '
                + QUOTENAME(@ustrDataBaseName)
                +'.sys.tables AS st
                    ON ob.object_id = st.object_id
                INNER JOIN '
                + QUOTENAME(@ustrDataBaseName)
                +'.sys.columns AS c	
                    ON ep.major_id = c.object_id
                        AND ep.minor_id = c.column_id
                WHERE st.name = @strTableName
                    AND c.name = @ustrColumnName';
            SET
            END
            ELSE
            BEGIN
                SET @ustrMessageOut = @strTableName + ' ' + @ustrColumnName + 
                    N' currently has no comments please use DD_AddColumnComment to add a comment!';
            END

            SELECT @ustrColumnName AS 'ColumnName'
                , @ustrMessageOut AS 'ColumnComment';
        END
    ELSE 
        BEGIN
         SET @ustrMessageOut = 'Either the column you typed in: ' + @ustrColumnName + ' or, '
                            + ' the table you typed in: ' + @strTableName + ' '
                            + 'is invalid, check spelling, try again? ';
         SELECT @ustrMessageOut AS 'NON_LOGGED_ERROR_MESSAGE'
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
';
END CATCH
               

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DYNAMIC SQL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT NULL
FROM SYS.EXTENDED_PROPERTIES
WHERE [major_id] = OBJECT_ID(@strTableName)
	AND [name] = N'MS_Description'
	AND [minor_id] = (
		SELECT [column_id]
		FROM SYS.COLUMNS
		WHERE [name] = @ustrColumnName
			AND [object_id] = OBJECT_ID(@strTableName)
		);

SELECT TOP 1 @ustrMessageOutTemp = CAST(ep.value AS NVARCHAR(320))
FROM [DatabaseName].sys.extended_properties AS ep
INNER JOIN [DatabaseName].sys.all_objects AS ob
	ON ep.major_id = ob.object_id
INNER JOIN [DatabaseName].sys.tables AS st
	ON ob.object_id = st.object_id
INNER JOIN [DatabaseName].sys.columns AS c
	ON ep.major_id = c.object_id
		AND ep.minor_id = c.column_id
WHERE st.name = @strTableName
	AND c.name = @ustrColumnName

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                    