WITH txt (id, text)  
AS  
(  
	SELECT o.id, o.text FROM
	(
		SELECT m.object_id as id, m.definition as text, o.type from sys.sql_modules as m 
			JOIN sys.objects as o on m.object_id = o.object_id
		UNION
		SELECT c.object_id, c.definition, o.type from sys.check_constraints as c 
			JOIN sys.objects as o on c.object_id = o.object_id
		UNION
		SELECT d.object_id, d.definition, o.type from sys.default_constraints as d 
			JOIN sys.objects as o on d.object_id = o.object_id
	) o
) 
SELECT o.object_id, o.type, s.name AS 'schema_name', o.name, txt.text
FROM sys.objects AS o
JOIN sys.schemas AS s ON o.schema_id = s.schema_id
LEFT JOIN txt ON txt.id = o.object_id
WHERE o.is_ms_shipped = 0 AND o.type != 'U'
