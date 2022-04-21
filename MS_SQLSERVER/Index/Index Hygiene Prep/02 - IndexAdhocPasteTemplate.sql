BEGIN TRY
	DECLARE @intEventID INT


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
				, ' Index Maint '
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

	THROW

    PRINT 'PROBLEMS? Try SELECT TOP 50 (*) FROM CustomLog.ERR.DB_EXCEPTION_TANK ORDER BY ErrorID DESC'
END CATCH;

