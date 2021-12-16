SELECT
    idx.relname AS IndexName
    , pgi.indisunique AS IsIndexUnique
    , tnsp.nspname AS TableSchema
    , tbl.relname AS TableName
FROM
    pg_index pgi
    JOIN pg_class idx ON idx.oid = pgi.indexrelid
    JOIN pg_namespace insp ON insp.oid = idx.relnamespace
    JOIN pg_class tbl ON tbl.oid = pgi.indrelid
    JOIN pg_namespace tnsp ON tnsp.oid = tbl.relnamespace
WHERE
    tnsp.nspname = 'public'
    AND tbl.relname = 'users';


