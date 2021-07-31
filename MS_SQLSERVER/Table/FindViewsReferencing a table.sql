SELECT	referencing_object_name = o.name
	  , referencing_object_type_desc = o.type_desc
	  , referenced_object_name = referenced_entity_name
	  , referenced_object_type_desc = so1.type_desc
	  , mods.is_schema_bound
      , idx.index_id
FROM	sys.sql_expression_dependencies sed
INNER JOIN sys.views o
		ON sed.referencing_id = o.object_id
LEFT OUTER JOIN sys.views so1
			 ON sed.referenced_id = so1.object_id
JOIN sys.sql_modules mods
  ON mods.object_id = o.object_id
LEFT OUTER JOIN sys.indexes idx
			 ON idx.object_id = o.object_id
WHERE	referenced_entity_name = 'CustomerServiceScriptInstruction'