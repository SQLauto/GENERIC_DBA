--the bottom one is code I assimilated and merged with my own code to make better.
-- I am Babler, I am SQL of BORG
-- your shitty code will be assimilated and made superior.
;

WITH recursedProcs
(code_database, ancestorName, OBJECT, Recursion, procpath)
  AS (   SELECT isr.SPECIFIC_CATALOG AS "code_database"
              , isr.[SPECIFIC_NAME] AS "ancestorName"
              , CAST(isr.SPECIFIC_NAME AS VARCHAR(200)) AS "OBJECT"
              , 1 AS "Recursion"
              , CAST(isr.SPECIFIC_NAME AS VARCHAR(200)) AS "procpath"
         FROM   INFORMATION_SCHEMA.ROUTINES isr WITH (NOLOCK)
         UNION ALL
         SELECT p.code_database
              , p.ancestorName
              , CAST(d.referenced_entity_name AS VARCHAR(200))
              , p.Recursion + 1
              , CAST(p.procpath + '/' + CAST(d.referenced_entity_name AS VARCHAR(200)) AS VARCHAR(200))
         FROM   recursedProcs p
             INNER JOIN
             sys.sql_expression_dependencies d
                ON d.referencing_id = OBJECT_ID(p.OBJECT)
         WHERE  p.Recursion < 20
                AND d.referenced_id <> OBJECT_ID(p.OBJECT))
SELECT  recursedProcs.code_database
      , recursedProcs.ancestorName
      , recursedProcs.OBJECT
      , recursedProcs.Recursion
      , recursedProcs.procpath
FROM    recursedProcs
WHERE   LOWER(procpath) LIKE '%asset%';
;

WITH recurDDProcs
(ReferencingObjectType, ReferencingObject, RecursionLevel, ReferencedObjectType, Pathing)
  AS (   SELECT o1.type AS "ReferencingObjectType"
              , SCHEMA_NAME(o1.schema_id) + '.' + o1.name AS "ReferencingObject"
              , 1 AS "RecursionLevel"
              , o2.type AS "ReferencedObjectType"
              , CAST(ed.referenced_entity_name AS VARCHAR(800)) AS "Pathing"
         FROM   sys.sql_expression_dependencies ed
             INNER JOIN
             sys.objects o1
                ON ed.referencing_id = o1.object_id
             INNER JOIN
             sys.objects o2
                ON ed.referenced_id = o2.object_id
         WHERE  o1.type IN ( 'P', 'TR', 'TF', 'FN' )
                AND (   LOWER(o1.name) LIKE '%asset[_]lia%'
                        OR  LOWER(o1.name) LIKE '%assetlia%')
                AND o2.type IN ( 'P', 'TR', 'TF', 'FN' )
         UNION ALL
         SELECT o1.type
              , SCHEMA_NAME(o1.schema_id) + '.' + o1.name
              , rp.RecursionLevel + 1
              , o2.type
              , CAST(rp.Pathing + '/' + CAST(ed.referenced_entity_name AS VARCHAR(800)) AS VARCHAR(800))
         FROM   recurDDProcs rp
             INNER JOIN
             sys.sql_expression_dependencies ed
                ON OBJECT_ID(rp.ReferencingObject) = ed.referencing_id
             INNER JOIN
             sys.objects o1
                ON ed.referencing_id = o1.object_id
             INNER JOIN
             sys.objects o2
                ON ed.referenced_id = o2.object_id
         WHERE  rp.RecursionLevel < 6
                AND ed.referenced_id <> OBJECT_ID(rp.ReferencingObject)
                AND o1.type IN ( 'P', 'TR', 'TF', 'FN' )
                AND o2.type IN ( 'P', 'TR', 'TF', 'FN' ))
   , reducer
  AS (   SELECT DISTINCT
                ir.ROUTINE_NAME
              , ReferencingObjectType
              , ReferencingObject
              , RecursionLevel
              , ReferencedObjectType
              , Pathing
              , RANK() OVER (PARTITION BY ReferencingObject ORDER BY Pathing DESC) AS "RANKER"
         FROM   recurDDProcs AS rd
             RIGHT JOIN
             INFORMATION_SCHEMA.ROUTINES ir
                ON rd.ReferencingObject = ir.ROUTINE_SCHEMA + '.' + ROUTINE_NAME)
SELECT  reducer.ROUTINE_NAME
      , reducer.ReferencingObjectType
      , reducer.ReferencingObject
      , reducer.RecursionLevel
      , reducer.ReferencedObjectType
      , reducer.Pathing
      , reducer.RANKER
FROM    reducer
WHERE   RANKER = 1;