-- =============================================
-- Author:		Dave Babler
-- Create date: 9/11/2020
-- Description:	Used for quickly making comparisons when determining foreign keys on non-defined-relations
-- Subprocedures: 1. DD_ColumnCompare
-- WARNING: will not work with tables that have been defined as a keyword (looking at you 'plan')
-- =============================================
CREATE
	OR

ALTER PROCEDURE DD_ParentToChildComparison
	-- Add the parameters for the stored procedure here
	@strParentTable VARCHAR(64)
	, @strParentColumn VARCHAR(64)
	, @strChildTable VARCHAR(64)
	, @strChildColumn VARCHAR(64)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @intChildTableSAFE INT --pay attention to this Fernando
		, @intParentTableSAFE INT -- again LOOK AT ME Fernando, I'm very important!!!!
		, @SQLUnion NVARCHAR(max)
		, @TSQLParameterDefinitionsFull NVARCHAR(500)
		, @TSQLParameterDefinitionsCount NVARCHAR(500)
		, @TSQLParameterDefinitions1to1 NVARCHAR(500)
		, @SQLOrphans NVARCHAR(MAX)
		, @SQLOrphanCheck NVARCHAR(MAX)
		, @SQL1to1Check NVARCHAR(MAX)
		, @intRowCount INT;

	SET @TSQLParameterDefinitionsFull = 
		N'@strChildColumn_ph VARCHAR(64)
                                        , @strParentColumn_ph VARCHAR(64)';
	SET @TSQLParameterDefinitionsCount = N' @intRowCount_ph INT OUTPUT';
	SET @TSQLParameterDefinitions1to1 = N'@strChildColumn_ph VARCHAR(64)';
	SET @intChildTableSAFE = OBJECT_ID(@strChildTable);--will not parse if malformed or injected --Dave Babler
	SET @intParentTableSAFE = OBJECT_ID(@strParentTable) -- same as above; tables are DANGEROUS if not protected in dynamic 

	EXEC DD_ColumnCompare @strChildTable
		, @strChildColumn
		, @strParentTable
		, @strParentColumn;

	--ph for placeholder
	SET @SQLUnion = 
		N'SELECT MAX(LEN(QUOTENAME(@strChildColumn_ph)))	AS Length , QUOTENAME(@strChildColumn_ph) AS ColumnName FROM ' + 
		QUOTENAME(OBJECT_NAME(@intChildTableSAFE)) + 
		' UNION ALL

        SELECT MAX(LEN(@strParentColumn_ph))
            , @strParentColumn_ph
        FROM ' + 
		QUOTENAME(OBJECT_NAME(@intParentTableSAFE)) + '';

	PRINT @SQLUnion

	EXEC sp_executesql @SQLUnion
		, @TSQLParameterDefinitionsFull
		, @strChildColumn_ph = @strChildColumn
		, @strParentColumn_ph = @strParentColumn;

	SET @SQL1to1Check = N' 
            SELECT  TOP 25 PERCENT COUNT(*) AS CountFK ,' + QUOTENAME(@strChildColumn) + 
		' 
            FROM  ' + OBJECT_NAME(@intChildTableSAFE) + ' ' + '  GROUP BY ' + QUOTENAME(@strChildColumn) + 
		'
            ORDER BY CountFK DESC
        ';

	/**WHY? because it's important for us to see if the table has a one to many relationship or a 1 to 1 
            * relation ship.  If most of the DESC counts are very low, such as 3 or less check to make sure there's not 
            * an error in a 1 to 1 relationship. --- Dave Babler  */
	PRINT @SQL1to1Check;

	EXEC sp_executesql @SQL1to1Check;

	SET @SQLOrphanCheck = N'
            SELECT @intRowCount_ph = COUNT(QUOTENAME(' + @strChildColumn + 
		'))  
            FROM ' + OBJECT_NAME(@intChildTableSAFE) + '
            WHERE ' + @strChildColumn + 
		'  NOT IN  (
                                                SELECT ' + @strParentColumn + 
		'
                                                FROM ' + QUOTENAME(OBJECT_NAME(@intParentTableSAFE)) + 
		'                                                     
                                            )';

	EXEC sp_executesql @SQLOrphanCheck
		, @TSQLParameterDefinitionsCount
		, @intRowCount OUTPUT

	IF @intRowCount > 0
	BEGIN
		PRINT CAST(@intRowCount AS VARCHAR(16)) + ' orphans have been found';

		SET @SQLOrphans = N'
                SELECT * 
                FROM ' + OBJECT_NAME(@intChildTableSAFE) + 
			'
                WHERE QUOTENAME(' + @strChildColumn + 
			')  NOT IN  (
                                                    SELECT QUOTENAME(' + @strParentColumn + 
			')
                                                    FROM ' + QUOTENAME(OBJECT_NAME(@intParentTableSAFE)) + 
			'                                                     
                                                )';

		EXEC sp_executesql @SQLOrphans;--GETS THE OUTPUT OF THE FULL ORPHAN DATA FOR QUICK EXCEL EXPORT

		--Resetting the value for print to copy into different documentation if needed that doesn't need a SELECT *
		SET @SQLOrphans = N'
                SELECT QUOTENAME(' + @strChildColumn + ') [Orphans]
                FROM ' + 
			OBJECT_NAME(@intChildTableSAFE) + '
                WHERE QUOTENAME(' + @strChildColumn + 
			')  NOT IN  (
                                                    SELECT ' + @strParentColumn + 
			'
                                                    FROM ' + QUOTENAME(OBJECT_NAME(@intParentTableSAFE)) + 
			'                                                     
                                                )';

		PRINT @SQLOrphans;
	END
	ELSE
	BEGIN
		PRINT 'No Orphans Found';
	END;
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
	--Testing block
	/* 
        
            DECLARE @strParentTable VARCHAR(64) = ''; 
            DECLARE @strParentColumn VARCHAR(64) = '';
            DECLARE @strChildTable VARCHAR(64) = ''; 
            DECLARE @strChildColumn VARCHAR(64) = '';
        
        
         */
