WITH all_tables AS (
    SELECT
        *
    FROM (
        SELECT
            'all'::text AS table_name
            , Sum((Coalesce(heap_blks_read
                    , 0) + Coalesce(idx_blks_read
                    , 0) + Coalesce(toast_blks_read
                    , 0) + Coalesce(tidx_blks_read
                    , 0))) AS from_disk
        , Sum((Coalesce(heap_blks_hit
                , 0) + Coalesce(idx_blks_hit
                , 0) + Coalesce(toast_blks_hit
                , 0) + Coalesce(tidx_blks_hit
                , 0))) AS from_cache
    FROM
        pg_statio_all_tables
        --> change to pg_statio_USER_tables if you want to check only user tables (excluding postgres's own tables)
) a
    WHERE (from_disk + from_cache) > 0
    -- discard tables without hits
)
, TABLES AS (
    SELECT
        *
    FROM (
        SELECT
            relname AS table_name
            , ((Coalesce(heap_blks_read
                    , 0) + Coalesce(idx_blks_read
                    , 0) + Coalesce(toast_blks_read
                    , 0) + Coalesce(tidx_blks_read
                    , 0))) AS from_disk
        , ((Coalesce(heap_blks_hit
                , 0) + Coalesce(idx_blks_hit
                , 0) + Coalesce(toast_blks_hit
                , 0) + Coalesce(tidx_blks_hit
                , 0))) AS from_cache
    FROM
        pg_statio_all_tables
        --> change to pg_statio_USER_tables if you want to check only user tables (excluding postgres's own tables)
) a
    WHERE (from_disk + from_cache) > 0
    -- discard tables without hits
)
SELECT
    table_name AS "table name"
    , from_disk AS "disk hits"
    , Round((from_disk::numeric / (from_disk + from_cache)::numeric) * 100.0 ,
	2) AS "% disk hits"
    , Round((from_cache::numeric / (from_disk + from_cache)::numeric) * 100.0 ,
	2) AS "% cache hits"
    , (from_disk + from_cache) AS "total hits"
FROM (
    SELECT
        *
    FROM
        all_tables
    UNION ALL
    SELECT
        *
    FROM
        TABLES) a
ORDER BY
    (
        CASE WHEN table_name = 'all' THEN
            0
        ELSE
            1
        END) a.
    , from_disk DESC
