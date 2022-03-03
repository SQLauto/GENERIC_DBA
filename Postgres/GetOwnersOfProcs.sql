SELECT
    n.nspname AS schema_name
    , p.proname AS specific_name
    , l.lanname AS
    LANGUAGE
    , CASE WHEN l.lanname = 'internal' THEN
        p.prosrc
    ELSE
        Pg_get_functiondef(p.oid)
    END AS definition
    , Pg_get_function_arguments(p.oid) AS arguments
FROM
    pg_proc p
    LEFT JOIN pg_namespace n ON p.pronamespace = n.oid
    LEFT JOIN pg_language l ON p.prolang = l.oid
    LEFT JOIN pg_type t ON t.oid = p.prorettype
WHERE
    n.nspname NOT IN ('pg_catalog' , 'information_schema')
    AND p.prokind = 'p'
ORDER BY
    schema_name
    , specific_name;

SELECT
    n.nspname AS schema_name
    , p.proname AS specific_name
    , l.lanname AS
    LANGUAGE
    , CASE WHEN l.lanname = 'internal' THEN
        p.prosrc
    ELSE
        Pg_get_functiondef(p.oid)
    END AS definition
    , Pg_get_function_arguments(p.oid) AS arguments
FROM
    pg_proc p
    LEFT JOIN pg_namespace n ON p.pronamespace = n.oid
    LEFT JOIN pg_language l ON p.prolang = l.oid
    LEFT JOIN pg_type t ON t.oid = p.prorettype
WHERE
    n.nspname NOT IN ('pg_catalog' , 'information_schema')
    AND p.prokind = 'f'
ORDER BY
    schema_name
    , specific_name;

SELECT
    Pg_get_userbyid(p.proowner)
    , n.nspname AS schema_name
    , p.proname AS specific_name
    , CASE p.prokind
    WHEN 'f' THEN
        'FUNCTION'
    WHEN 'p' THEN
        'PROCEDURE'
    WHEN 'a' THEN
        'AGGREGATE'
    WHEN 'w' THEN
        'WINDOW'
    END AS kind
    , l.lanname AS
    LANGUAGE
    , CASE WHEN l.lanname = 'internal' THEN
        p.prosrc
    ELSE
        Pg_get_functiondef(p.oid)
    END AS definition
    , Pg_get_function_arguments(p.oid) AS arguments
    , t.typname AS return_type
FROM
    pg_proc p
    LEFT JOIN pg_namespace n ON p.pronamespace = n.oid
    LEFT JOIN pg_language l ON p.prolang = l.oid
    LEFT JOIN pg_type t ON t.oid = p.prorettype
WHERE
    n.nspname NOT IN ('pg_catalog' , 'information_schema')
    AND Pg_get_userbyid(p.proowner)
    NOT LIKE '%rds%'
    AND Pg_get_userbyid(p.proowner)
    NOT LIKE '%pg%'
ORDER BY
    schema_name
    , specific_name;
