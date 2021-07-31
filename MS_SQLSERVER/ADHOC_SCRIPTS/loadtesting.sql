BEGIN
	DECLARE @intLCV INT = 0;
	DECLARE @intEventID INT;

	INSERT INTO LOADTEST.EventTracker
		(
			SysObjTypeTested
		  , NameOfObjectTested
		  , CursorLoopCount
		  , IsControlTest
		  , LocationOfCodeTested
		)
	VALUES
		(
			'P'
		  , 'Pain.dbo.sp_QA2Grid'
		  , 100
		  , 1
		  , 'Original Code, prior to the upates to indexes and such'
		);

	

	PRINT @intEventID;

	WHILE @intLCV < 100
	BEGIN
		PRINT @intLCV;

		IF @intLCV % 2 = 0
		BEGIN
			EXEC Pain.dbo.sp_QA2Grid @FacilityID = 1;	-- int
		END;
		ELSE
		BEGIN
			EXEC Pain.dbo.sp_QA2Grid @FacilityID = 3;	-- int
		END;

		SET @intLCV += 1;
	END;

	UPDATE	CustomLog.LOADTEST.EventTracker
	SET EventEndingDateTime = GETDATE()
	WHERE	EventID = @intEventID;
END;
GO

PRINT 'Start Next Test';

BEGIN
	DECLARE @intLCV INT = 0;
	DECLARE @intEventID INT;

	INSERT INTO LOADTEST.EventTracker
		(
			SysObjTypeTested
		  , NameOfObjectTested
		  , CursorLoopCount
		  , IsControlTest
		  , LocationOfCodeTested
		)
	VALUES
		(
			'P'
		  , 'Pain.dbo.sp_AHPMS_frmqa3list_populategrid8'
		  , 100
		  , 1
		  , 'Original Code, prior to the upates to indexes and such'
		);

	SELECT @intEventID =  SCOPE_IDENTITY();

	PRINT @intEventID;

	WHILE @intLCV < 100
	BEGIN
		PRINT @intLCV;

		IF @intLCV % 2 = 0
		BEGIN
			EXEC Pain.dbo.sp_AHPMS_frmqa3list_populategrid8 @StartDate = NULL
														  , @EndDate = NULL
														  , @FacilityID = 1
														  , @OTCDisplayEnabled = 1
														  , @QA3DisplayEnabled = 1
														  , @IceDisplayEnabled = 1
														  , @Order797DisplayEnabled = 1
														  , @OfficeUseOrRxDisplayEnabled = 1;
		END;
		ELSE
		BEGIN
			EXEC Pain.dbo.sp_AHPMS_frmqa3list_populategrid8 @StartDate = NULL
														  , @EndDate = NULL
														  , @FacilityID = 3
														  , @OTCDisplayEnabled = 1
														  , @QA3DisplayEnabled = 1
														  , @IceDisplayEnabled = 1
														  , @Order797DisplayEnabled = 1
														  , @OfficeUseOrRxDisplayEnabled = 1;
		END;

		SET @intLCV += 1;
	END;

	UPDATE	CustomLog.LOADTEST.EventTracker
	SET EventEndingDateTime = GETDATE()
	WHERE	EventID = @intEventID;
END;
GO

