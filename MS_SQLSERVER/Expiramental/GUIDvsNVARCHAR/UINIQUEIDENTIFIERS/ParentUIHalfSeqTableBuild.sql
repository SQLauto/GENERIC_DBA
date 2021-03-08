/*This table will hold the Parent for testing the following.
 1. Will a UNIQUEIDENTIIER column on a child table hold a parent key without having to have a default setting
 2. Will it be faster for joins as a UINQUEIDENTIFIER rather than with NVARCHAR(36)
 */
CREATE TABLE ParentUIHalfSequential (
	ParentUIHalfSequential UNIQUEIDENTIFIER PRIMARY KEY 
	, SomeGarbage VARCHAR(80)
	)
ALTER TABLE ParentUIHalfSequential 
ADD CONSTRAINT DF_ParentUIHalfSequential_NON DEFAULT NEWID() FOR ParentUIHalfSequential;


DECLARE @lcv INT = 0;
DECLARE @strGarbageText VARCHAR(MAX) = 'Shoes';
DECLARE @strGarbageTextPrepend VARCHAR(8) = 'Shoes';

WHILE @lcv < 100000
BEGIN
	INSERT INTO ParentUIHalfSequential (SomeGarbage)
	VALUES (LEFT(TRIM(@strGarbageText), 80));

	SET @strGarbageText = @strGarbageTextPrepend + CAST(@lcv AS VARCHAR(8)) + @strGarbageText;
	SET @lcv = @lcv + 1;
END


ALTER TABLE ParentUIHalfSequential 
DROP CONSTRAINT DF_ParentUIHalfSequential_NON;

ALTER TABLE ParentUIHalfSequential 
ADD CONSTRAINT DF_ParentUIHalfSequential_SEQ DEFAULT NEWSEQUENTIALID() FOR ParentUIHalfSequential;


WHILE @lcv < 200000
BEGIN
	INSERT INTO ParentUIHalfSequential (SomeGarbage)
	VALUES (LEFT(TRIM(@strGarbageText), 80));

	SET @strGarbageText = @strGarbageTextPrepend + CAST(@lcv AS VARCHAR(8)) + @strGarbageText;
	SET @lcv = @lcv + 1;
END