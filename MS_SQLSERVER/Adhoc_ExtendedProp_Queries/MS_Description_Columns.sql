SELECT SysTbls.name AS [Table Name]
	, SysCols.name AS [Column Name]
	, ExtProp.value AS [Extended Property]
	, Systyp.name AS [Data Type]
	, CASE 
		WHEN Systyp.name IN ('nvarchar', 'nchar')
			THEN (SysCols.max_length / 2)
		WHEN Systyp.name IN ('char')
			THEN SysCols.max_length
		ELSE NULL
		END AS 'Length of Column'
	, CASE 
		WHEN SysCols.is_nullable = 0
			THEN 'No'
		WHEN SysCols.is_nullable = 1
			THEN 'Yes'
		ELSE NULL
		END AS 'Column is Nullable'
	, SysObj.create_date AS [Table Create Date]
	, SysObj.modify_date AS [Table Modify Date]
FROM sys.tables AS SysTbls
LEFT JOIN sys.extended_properties AS ExtProp
	ON ExtProp.major_id = SysTbls.[object_id]
LEFT JOIN sys.columns AS SysCols
	ON ExtProp.major_id = SysCols.[object_id]
		AND ExtProp.minor_id = SysCols.column_id
LEFT JOIN sys.objects AS SysObj
	ON SysTbls.[object_id] = SysObj.[object_id]
INNER JOIN sys.types AS SysTyp
	ON SysCols.user_type_id = SysTyp.user_type_id
WHERE class = 1 --Object or column
	AND SysTbls.name IS NOT NULL
	AND SysCols.name IS NOT NULL


--or



SELECT [Table Name] = i_s.TABLE_NAME
	, [Column Name] = i_s.COLUMN_NAME
	, [Description] = s.value
FROM INFORMATION_SCHEMA.COLUMNS i_s
LEFT JOIN sys.extended_properties s
	ON s.major_id = OBJECT_ID(i_s.TABLE_SCHEMA + '.' + i_s.TABLE_NAME)
		AND s.minor_id = i_s.ORDINAL_POSITION
		AND s.name = 'MS_Description'
WHERE OBJECTPROPERTY(OBJECT_ID(i_s.TABLE_SCHEMA + '.' + i_s.TABLE_NAME), 'IsMsShipped') = 0
	-- AND i_s.TABLE_NAME = 'table_name' 
	AND convert(VARCHAR(800), s.value) LIKE '%depre%'
ORDER BY i_s.TABLE_NAME
	, i_s.ORDINAL_POSITION

