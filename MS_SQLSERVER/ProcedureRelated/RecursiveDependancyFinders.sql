--the bottom one is code I assimilated and merged with my own code to make better.
-- I am Babler, I am SQL of BORG
-- your shitty code will be assimilated and made superior.
	;

WITH recursedProcs (
	code_database
	, ancestorName
	, OBJECT
	, Recursion
	, procpath
	)
AS (
	SELECT isr.specific_catalog AS code_database
		, isr.[specific_name] AS ancestorName
		, cast(isr.specific_name AS VARCHAR(200)) AS OBJECT
		, 1 AS Recursion
		, cast(isr.specific_name AS VARCHAR(200)) AS procpath
	FROM information_schema.routines isr WITH (NOLOCK)
	
	UNION ALL
	
	SELECT p.code_database
		, p.ancestorName
		, cast(d.referenced_entity_name AS VARCHAR(200))
		, p.recursion + 1
		, cast(p.procpath + '/' + cast(d.referenced_entity_name AS VARCHAR(200)) AS VARCHAR(200))
	FROM recursedProcs p
	INNER JOIN sys.sql_expression_dependencies d
		ON d.referencing_id = OBJECT_ID(p.OBJECT)
	WHERE p.recursion < 20
		AND d.referenced_id <> object_id(p.OBJECT)
	)
SELECT *
FROM recursedProcs
WHERE lower(procpath) LIKE '%asset%';
;

WITH recurDDProcs (
	ReferencingObjectType
	, ReferencingObject
	, RecursionLevel
	, ReferencedObjectType
	, Pathing
	)
AS (
	SELECT ReferencingObjectType = o1.type
		, ReferencingObject = SCHEMA_NAME(o1.schema_id) + '.' + o1.name
		, RecursionLevel = 1
		, ReferencedObjectType = o2.type
		, Pathing = CAST(ed.referenced_entity_name AS VARCHAR(800))
	FROM mapbenefits.sys.sql_expression_dependencies ed
	INNER JOIN mapbenefits.sys.objects o1
		ON ed.referencing_id = o1.object_id
	INNER JOIN mapbenefits.sys.objects o2
		ON ed.referenced_id = o2.object_id
	WHERE o1.type IN ('P', 'TR', 'TF', 'FN')
		AND (
			lower(o1.name) LIKE '%asset[_]lia%'
			OR lower(o1.name) LIKE '%assetlia%'
			)
		AND o2.type IN ('P', 'TR', 'TF', 'FN')
	
	UNION ALL
	
	SELECT o1.type
		, SCHEMA_NAME(o1.schema_id) + '.' + o1.name
		, rp.RecursionLevel + 1
		, o2.type
		, CAST(rp.Pathing + '/' + CAST(ed.referenced_entity_name AS VARCHAR(800)) AS VARCHAR(800))
	FROM recurDDProcs rp
	INNER JOIN mapbenefits.sys.sql_expression_dependencies ed
		ON OBJECT_ID(rp.ReferencingObject) = ed.referencing_id
	INNER JOIN mapbenefits.sys.objects o1
		ON ed.referencing_id = o1.object_id
	INNER JOIN mapbenefits.sys.objects o2
		ON ed.referenced_id = o2.object_id
	WHERE rp.RecursionLevel < 6
		AND ed.referenced_id <> object_id(rp.ReferencingObject)
		AND o1.type IN ('P', 'TR', 'TF', 'FN')
		AND o2.type IN ('P', 'TR', 'TF', 'FN')
	)
	, reducer
AS (
	SELECT DISTINCT ir.ROUTINE_NAME
		, ReferencingObjectType
		, ReferencingObject
		, RecursionLevel
		, ReferencedObjectType
		, Pathing
		, RANK() OVER (
			PARTITION BY ReferencingObject ORDER BY Pathing DESC
			) AS RANKER
	FROM recurDDProcs AS rd
	RIGHT JOIN INFORMATION_SCHEMA.ROUTINES ir
		ON rd.ReferencingObject = ir.ROUTINE_SCHEMA + '.' + ROUTINE_NAME
	WHERE (
			lower(ir.ROUTINE_NAME) LIKE '%asset[_]lia%'
			OR lower(ir.ROUTINE_NAME) LIKE '%lia%'
			)
	)
SELECT *
FROM reducer
WHERE RANKER = 1
;