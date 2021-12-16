WITH getConstraints AS (
    SELECT
        pgc.contype AS constraint_type
        , pgc.conname AS constraint_name
        , ccu.table_schema AS table_schema
        , kcu.table_name AS table_name
        , CASE WHEN (pgc.contype = 'f') THEN
            kcu.COLUMN_NAME
        ELSE
            ccu.COLUMN_NAME
        END AS column_name
        , CASE WHEN (pgc.contype = 'f') THEN
            ccu.TABLE_NAME
        ELSE
            (NULL)
        END AS reference_table
        , CASE WHEN (pgc.contype = 'f') THEN
            ccu.COLUMN_NAME
        ELSE
            (NULL)
        END AS reference_col
        , CASE WHEN (pgc.contype = 'p') THEN
            'yes'
        ELSE
            'no'
        END AS auto_inc
        , CASE WHEN (pgc.contype = 'p') THEN
            'NO'
        ELSE
            'YES'
        END AS is_nullable
        , 'integer' AS data_type
        , '0' AS numeric_scale
        , '32' AS numeric_precision
    FROM
        pg_constraint AS pgc
        JOIN pg_namespace nsp ON nsp.oid = pgc.connamespace
        JOIN pg_class cls ON pgc.conrelid = cls.oid
        JOIN information_schema.key_column_usage kcu ON kcu.constraint_name = pgc.conname
	LEFT JOIN information_schema.constraint_column_usage ccu ON pgc.conname
	    = ccu.CONSTRAINT_NAME
            AND nsp.nspname = ccu.CONSTRAINT_SCHEMA
        UNION
        SELECT
            NULL AS constraint_type
            , NULL AS constraint_name
            , 'public' AS "table_schema"
            , table_name
            , column_name
            , NULL AS refrence_table
            , NULL AS refrence_col
            , 'no' AS auto_inc
            , is_nullable
            , data_type
            , numeric_scale
            , numeric_precision
        FROM
            information_schema.columns cols
    WHERE
        1 = 1
        AND table_schema = 'public'
        AND column_name NOT IN (
            SELECT
                CASE WHEN (pgc.contype = 'f') THEN
                    kcu.COLUMN_NAME
                ELSE
                    kcu.COLUMN_NAME
                END
            FROM
                pg_constraint AS pgc
                JOIN pg_namespace nsp ON nsp.oid = pgc.connamespace
                JOIN pg_class cls ON pgc.conrelid = cls.oid
                JOIN information_schema.key_column_usage kcu ON kcu.constraint_name = pgc.conname
		LEFT JOIN information_schema.constraint_column_usage ccu ON
		    pgc.conname = ccu.CONSTRAINT_NAME
                    AND nsp.nspname = ccu.CONSTRAINT_SCHEMA))
    SELECT
        gc.*
    FROM
        getConstraints gc
WHERE
    table_name = 'users'
ORDER BY
    table_name DESC;


