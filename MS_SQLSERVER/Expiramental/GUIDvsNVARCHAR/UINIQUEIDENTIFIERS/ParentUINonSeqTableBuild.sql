/*This table will hold the Parent for testing the following.
 1. Will a UNIQUEIDENTIIER column on a child table hold a parent key without having to have a default setting
 2. Will it be faster for joins as a UINQUEIDENTIFIER rather than with NVARCHAR(36)
 */
CREATE TABLE ParentUINonSequential (
	ParentUINonSequentialID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID()
	, SomeGarbage VARCHAR(80)
	)

DECLARE @lcv INT = 0;
DECLARE @strGarbageText VARCHAR(MAX) = 'Shoes';
DECLARE @strGarbageTextPrepend VARCHAR(8) = 'Shoes';

WHILE @lcv < 200000
BEGIN
	INSERT INTO ParentUINonSequential (SomeGarbage)
	VALUES (LEFT(TRIM(@strGarbageText), 80));

	SET @strGarbageText = @strGarbageTextPrepend + CAST(@lcv AS VARCHAR(8)) + @strGarbageText;
	SET @lcv = @lcv + 1;
END









;WITH CTE_BuildInts AS(
select top 2000000 row_number() over(order by t1.number) as GeneratedInt
, 'HitCol' AS HitCol
from   master..spt_values t1 
       cross join master..spt_values t2
)
, CTE_BuildStrings AS (
	SELECT CAST('' AS VARCHAR(MAX)) AS HitCol
	, GeneratedInt
	, CAST('' AS VARCHAR(80)) AS FakeString
	FROM CTE_BuildInts

	UNION ALL

	SELECT CAST('HitCol' AS VARCHAR(MAX)) AS strCategory
	, NULL 
	,   CAST(LEFT(TRIM('Shoes' + CAST(bi.GeneratedInt AS VARCHAR(8))), 80) AS VARCHAR(80))
	FROM CTE_BuildInts bi
		JOIN CTE_BuildStrings bs
		ON bi.HitCol = bs.HitCol

)
INSERT INTO [dbo].[TestinShit]( [SomeShit])
SELECT  CAST(LEFT(TRIM('Shoes' + CAST(GeneratedInt AS VARCHAR(8))), 80) AS VARCHAR(80))
FROM CTE_BuildStrings;
