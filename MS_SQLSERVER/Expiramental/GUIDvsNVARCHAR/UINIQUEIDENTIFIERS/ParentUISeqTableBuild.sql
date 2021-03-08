/*This table will hold the Parent for testing the following.
 1. Will a UNIQUEIDENTIIER column on a child table hold a parent key without having to have a default setting
 2. Will it be faster for joins as a UINQUEIDENTIFIER rather than with NVARCHAR(36)
 */
CREATE TABLE ParentUIFullSequential (
	ParentUIFullSequentialID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID()
	, SomeGarbage VARCHAR(80)
	)

DECLARE @lcv INT = 0;
DECLARE @strGarbageText VARCHAR(MAX) = 'Shoes';
DECLARE @strGarbageTextPrepend VARCHAR(8) = 'Shoes';

WHILE @lcv < 200000
BEGIN
	INSERT INTO ParentUIFullSequential (SomeGarbage)
	VALUES (LEFT(TRIM(@strGarbageText), 80));

	SET @strGarbageText = @strGarbageTextPrepend + CAST(@lcv AS VARCHAR(8)) + @strGarbageText;
	SET @lcv = @lcv + 1;
END
