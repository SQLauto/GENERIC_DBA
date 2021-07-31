;WITH ind
AS (SELECT	a.object_id
		  , a.index_id
		  , CAST(col_list.list AS VARCHAR(MAX)) AS "list"
	FROM
		(SELECT DISTINCT object_id, index_id FROM sys  .index_columns) AS a
	CROSS APPLY
		(
			SELECT	CAST(column_id AS VARCHAR(16)) + ',' AS "text()"
			FROM	sys.index_columns AS b
			WHERE
				a.object_id = b.object_id
				AND a.index_id = b.index_id
			FOR XML PATH(''), TYPE
		) AS col_list(list) )
SELECT	OBJECT_NAME(a.object_id) AS "TableName"
	  , asi.name AS "FatherIndex"
	  , bsi.name AS "RedundantIndex"
FROM	ind AS a
JOIN sys.sysindexes AS asi
  ON asi.id = a.object_id
	  AND	asi.indid = a.index_id
JOIN ind AS b
  ON a.object_id = b.object_id
	  AND	a.object_id = b.object_id
	  AND	LEN(a.list) > LEN(b.list)
	  AND	LEFT(a.list, LEN(b.list)) = b.list
JOIN sys.sysindexes AS bsi
  ON bsi.id = b.object_id
	  AND	bsi.indid = b.index_id
WHERE	OBJECT_NAME(a.object_id) = 'CustomerServiceScriptInstruction';