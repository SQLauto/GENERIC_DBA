SELECT SysTbls.name AS [Table Name]
	, ExtProp.value AS [Extended Property]
	, SysObj.create_date AS [Table Create Date]
	, SysObj.modify_date AS [Table Modify Date]
FROM sys.tables AS SysTbls
LEFT JOIN sys.extended_properties AS ExtProp
	ON ExtProp.major_id = SysTbls.[object_id]
LEFT JOIN sys.objects AS SysObj
	ON SysTbls.[object_id] = SysObj.[object_id]
WHERE class = 1 --Object or column
	AND SysTbls.name IS  NOT NULL
    AND ExtProp.minor_id = 0

--or below 
SELECT [Table Name] = i_t.TABLE_NAME
	, [Description] = s.value
    FROM INFORMATION_SCHEMA.TABLES i_t
LEFT JOIN sys.extended_properties s
	ON s.major_id = OBJECT_ID(i_t.TABLE_SCHEMA + '.' + i_t.TABLE_NAME)
		AND s.name = 'MS_Description'
WHERE OBJECTPROPERTY(OBJECT_ID(i_t.TABLE_SCHEMA + '.' + i_t.TABLE_NAME), 'IsMsShipped') = 0
	-- AND i_t.TABLE_NAME = 'table_name' 
    AND s.minor_id = 0 -- prevents the showing of columns
	AND convert(VARCHAR(800), s.value) LIKE '%depre%'
ORDER BY i_t.TABLE_NAME
