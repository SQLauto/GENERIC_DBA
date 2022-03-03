SET
enable_seqscan = OFF;

DROP TABLE IF EXISTS BIGGERTHAN500TABLES;

CREATE TEMPORARY TABLE BIGGERTHAN500TABLES(
    TableName VARCHAR(200)
    , TableSize VARCHAR(40)
);

INSERT
    INTO
    BIGGERTHAN500TABLES
SELECT
    table_schema || '.' || table_name AS table_full_name
    ,
    pg_size_pretty(
        pg_total_relation_size(
            '"' || table_schema || '"."' || table_name || '"'
        )
    ) AS SIZE
FROM
    information_schema.TABLES
WHERE
    table_schema = 'public'
    AND 500000000 < pg_total_relation_size(
        '"' || table_schema || '"."' || table_name || '"'
    );

WITH VacuumBig AS (
    SELECT
        'VACUUM VERBOSE ANALYZE '
|| TableName
|| ';' AS VacuumCommand
    FROM
        BIGGERTHAN500TABLES
)
, VacuumSmall AS (
    SELECT
        'VACUUM FULL VERBOSE ANALYZE '
    || table_schema 
    || '.'
       || table_name
       || ';' AS VacuumCommand
    FROM
        information_schema.tables
    WHERE
        table_schema = 'public'
        AND (
            table_schema || '.' || table_name
        ) NOT IN (
            SELECT
                TableName
            FROM
                BIGGERTHAN500TABLES
        )
)
SELECT
    vb.VacuumCommand
FROM
    VacuumBig AS vb     
    WHERE vb.VacuumCommand NOT ILIKE '%visitor_text%'
UNION ALL
SELECT
    vs.VacuumCommand
FROM
    VacuumSmall AS vs;

DISCARD PLANS;

REINDEX DATABASE effective;

DISCARD PLANS;
SET enable_seqscan = ON


