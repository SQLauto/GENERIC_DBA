DECLARE @dbname sysname;

SET @dbname = QUOTENAME(DB_NAME());

WITH XMLNAMESPACES
	(
		DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
	)
INSERT INTO CustomLog.PLANDUMPS.NON_SARGEABLE_PLANS
	(
		DatabaseName
	  , SchemaName
	  , TableName
	  , ColumnName
	  , Query
	  , QueryPlan
	  , ScanType
	  , ScalarString
	)
SELECT	DB_NAME()
	  , CONVERT(NVARCHAR(128), sc.value('(.//Identifier/ColumnReference/@Schema)[1]', 'varchar(128)')) AS "Schema"
	  , CONVERT(NVARCHAR(128), (sc.value('(.//Identifier/ColumnReference/@Table)[1]', 'varchar(128)'))) AS "Table"
	  , CONVERT(NVARCHAR(128), (sc.value('(.//Identifier/ColumnReference/@Column)[1]', 'varchar(128)'))) AS "Column"
	  , CONVERT(NVARCHAR(128), (stmt.value('(@StatementText)[1]', 'varchar(max)'))) AS "Query"
	  , qp.query_plan AS "QueryPlan"
	  , CASE
			WHEN s.exist('.//TableScan') = 1 THEN 'TableScan'
			ELSE 'IndexScan'
		END AS "ScanType"
	  , CONVERT(NVARCHAR(128), (sc.value('(@ScalarString)[1]', 'varchar(128)'))) AS "ScalarString"
FROM	sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS batch(stmt)
CROSS APPLY stmt.nodes('.//RelOp[TableScan or IndexScan]') AS scan(s)
CROSS APPLY s.nodes('.//ScalarOperator') AS scalar(sc)
WHERE
	s.exist('.//ScalarOperator[@ScalarString]!=""') = 1
	AND sc.exist('.//Identifier/ColumnReference[@Database=sql:variable("@dbname")][@Schema!="[sys]"]') = 1
	AND sc.value('(@ScalarString)[1]', 'varchar(128)') IS NOT NULL;

