SELECT rug.grantor,
        rug.grantee,
        rug.object_catalog,
        rug.object_schema,
        rug.object_name,
        rug.object_type,
        rug.privilege_type,
        rug.is_grantable,
        null::text AS with_hierarchy
    FROM information_schema.role_usage_grants rug
    WHERE rug.object_schema NOT IN ( 'pg_catalog', 'information_schema' )
        AND grantor <> grantee
UNION
SELECT rtg.grantor,
        rtg.grantee,
        rtg.table_catalog,
        rtg.table_schema,
        rtg.table_name,
        tab.table_type,
        rtg.privilege_type,
        rtg.is_grantable,
        rtg.with_hierarchy
    FROM information_schema.role_table_grants rtg
    LEFT JOIN information_schema.tables tab
        ON ( tab.table_catalog = rtg.table_catalog
            AND tab.table_schema = rtg.table_schema
            AND tab.table_name = rtg.table_name )
    WHERE rtg.table_schema NOT IN ( 'pg_catalog', 'information_schema' )
        AND grantor <> grantee
UNION
SELECT rrg.grantor,
        rrg.grantee,
        rrg.routine_catalog,
        rrg.routine_schema,
        rrg.routine_name,
        fcn.routine_type,
        rrg.privilege_type,
        rrg.is_grantable,
        null::text AS with_hierarchy
    FROM information_schema.role_routine_grants rrg
    LEFT JOIN information_schema.routines fcn
        ON ( fcn.routine_catalog = rrg.routine_catalog
            AND fcn.routine_schema = rrg.routine_schema
            AND fcn.routine_name = rrg.routine_name )
    WHERE rrg.specific_schema NOT IN ( 'pg_catalog', 'information_schema' )
        AND grantor <> grantee
UNION
SELECT rug.grantor,
        rug.grantee,
        rug.udt_catalog,
        rug.udt_schema,
        rug.udt_name,
        ''::text AS udt_type,
        rug.privilege_type,
        rug.is_grantable,
        null::text AS with_hierarchy
    FROM information_schema.role_udt_grants rug
    WHERE rug.udt_schema NOT IN ( 'pg_catalog', 'information_schema' )
        AND substr ( rug.udt_schema, 1, 3 ) <> 'pg_'
        AND grantor <> grantee ;