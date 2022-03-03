;WITH pe
AS (
	SELECT TABLE_NAME
		, COLUMN_NAME
		, CASE 
			WHEN DATA_TYPE = 'nvarchar'
				THEN 'varchar'
			ELSE DATA_TYPE
			END AS [DATA_TYPE]
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE lower(COLUMN_NAME) LIKE '%pathelect%'
		OR lower(COLUMN_NAME) LIKE '%path_elect%'
	)
	, emppl
AS (
	SELECT TABLE_NAME
		, COLUMN_NAME
		, CASE 
			WHEN DATA_TYPE = 'nvarchar'
				THEN 'varchar'
			ELSE DATA_TYPE
			END AS [DATA_TYPE]
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE lower(COLUMN_NAME) LIKE '%employeep%'
		OR lower(COLUMN_NAME) LIKE '%employee_p%'
	)
SELECT COUNT(*)
	, pe.TABLE_NAME
	, pe.COLUMN_NAME
	, emppl.COLUMN_NAME
FROM pe
INNER JOIN emppl
	ON pe.TABLE_NAME = emppl.TABLE_NAME
		AND pe.DATA_TYPE = emppl.DATA_TYPE
GROUP BY GROUPING SETS((pe.TABLE_NAME
                        , pe.COLUMN_NAME
                        , emppl.COLUMN_NAME));
--THE TWO PARENTHESIS CREATS A GROUPED SET OF A GROUPED SET.  SO NO NULLS