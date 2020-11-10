-- =============================================
-- Author:		Dave Babler
-- Create date: 11/09/2020
-- Description:	This procedure determines which database schema and object are being called, 
--              and will output those to the correct calling procedure.
-- =============================================
CREATE PROCEDURE UTL_prc_DBSchemaObjectAssignment
	-- Add the parameters for the stored procedure here
	@strQualifiedObjectBeingCalled NVARCHAR(200)  --64*3+UP TO 2 PERIODS TO NEXT OCTET
	, @strDatabaseName NVARCHAR(64)  = NULL OUTPUT
	, @strSchemaName NVARCHAR(64) = NULL OUTPUT
	, @strObjectName NVARCHAR(64) = NULL OUTPUT
AS
BEGIN
    DECLARE @intDelimCountChecker INT = 0;
    DECLARE @strDefaultSchema NVARCHAR(64) = 'dbo'; --WE WOULD FILL THIS IN.
    DECLARE @strDefaultDatabase NVARCHAR(64) = 'AdventureWorks2012';
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
    --GET MAX COUNT OF ROWID USE THAT TO DETERMINE LOGIC  IF NO PERIODS SKIP LOGIC USE DEFAULTS
    SET @intDelimCountChecker = CHARINDEX(@strQualifiedObjectBeingCalled, '.');
    IF @intDelimCountChecker > 0
        BEGIN 
            PRINT 'Proceed with logic';

            --check info schema to make sure the schmea and the db actually exist.
        END
    ELSE 
        BEGIN
        PRINT 'AssumeDefaultDatabase';
            SET @strSchemaName = @strDefaultSchema;
            SET @strDatabaseName = @strDefaultDatabase; 
        END
END
GO


/*

DECLARE	 @strDatabaseName NVARCHAR(64) 
	, @strSchemaName NVARCHAR(64) 
	, @strObjectName NVARCHAR(64);
*/