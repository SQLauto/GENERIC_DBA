BEGIN TRY 


DECLARE @sqlString NVARCHAR(800)
, @sqlStringForNulls NVARCHAR(800)
, @strTable NVARCHAR(64)
, @strColumn NVARCHAR(64);

SET @strColumn = N'Account_Mangement_Category__c';
SET @strTable = N'SF1_TASK';

SET @sqlStringForNulls = N' SELECT COUNT(DISTINCT ' + QUOTENAME(TRIM(@strColumn)) + ')  AS "CountedUniqueNonNullValues"'+
                        'FROM ' + QUOTENAME(@strTable)  + 
                        'WHERE ' + QUOTENAME(@strColumn)  + 'IS NOT NULL';

SET @sqlString = N' SELECT DISTINCT ' + QUOTENAME(TRIM(@strColumn)) + ' AS "UniqueValues"
                    FROM ' + QUOTENAME(TRIM(@strTable)) ;

                    


EXEC sp_executeSQL @sqlStringForNulls, N'@strTable NVARCHAR(64), @strColumn NVARCHAR(64)', @strTable=@strTable, @strColumn=@strColumn;
EXEC sp_executeSQL @sqlString, N'@strTable NVARCHAR(64), @strColumn NVARCHAR(64)', @strTable=@strTable, @strColumn=@strColumn;



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
		, ISNULL(ERROR_PROCEDURE(), CONCAT (
				ERROR_PROCEDURE()
				, ' '
				, CONCAT (
					DB_NAME()
					, '.'
					, SCHEMA_NAME()
					, '.'
					, OBJECT_NAME(@@PROCID)
					)
				))
		, ERROR_MESSAGE()
		, GETDATE()
		);

	--dddddddddddddddddddddddddddddddddddddddddddd--DynamicSQLAsRegularBlock--dddddddddddddddddddddddddddddddddddddddddddddd
		/*

            SELECT DISTINCT Column
            FROM WhateverTable;


            SELECT DISTINCT Column
            FROM WhateverTable
            WHERE WhateverTable IS NOT NULL;
            
				
		*/
	--DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	THROW
END CATCH;
