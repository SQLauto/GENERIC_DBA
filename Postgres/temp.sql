SELECT DISTINCT
    data_type
FROM
    information_schema.columns
WHERE
    table_schema <> 'pg_catalog'
    AND (data_type ILIKE 'unknown'
        OR data_type = 'abstime');

WITH funcs AS (
    SELECT
        P.proname
        , p.pronamespace::regnamespace::text AS func_schema
        , obj_description(p.oid)
        , pg_catalog.pg_get_function_arguments(p.oid) AS args
        , pg_get_function_result(p.oid) AS rettype
    FROM
        pg_proc P
)
SELECT
    *
FROM
    funcs
WHERE (args ~~ '%abstime%'
    OR rettype = 'abstime')
AND func_schema <> 'pg_catalog';

SELECT
    count(*)
FROM
    pg_catalog.pg_class c
    , pg_catalog.pg_namespace n
    , pg_catalog.pg_attribute a
WHERE
    c.oid = a.attrelid
    AND NOT a.attisdropped
    AND a.atttypid IN ('pg_catalog.regproc'::pg_catalog.regtype ,
	'pg_catalog.regprocedure'::pg_catalog.regtype , 'pg_catalog.regoper'::pg_catalog.regtype ,
	'pg_catalog.regoperator'::pg_catalog.regtype , 'pg_catalog.regconfig'::pg_catalog.regtype ,
	'pg_catalog.regdictionary'::pg_catalog.regtype)
    AND c.relnamespace = n.oid
    AND n.nspname NOT IN ('pg_catalog' , 'information_schema');

SELECT
    count(*)
FROM
    pg_catalog.pg_prepared_xacts;

SELECT
    *
FROM
    pg_extension;
