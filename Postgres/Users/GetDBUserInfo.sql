SELECT d.datname ,

    ( SELECT string_agg(u.usename, ','
                        ORDER BY u.usename)
     FROM pg_user u
     WHERE has_database_privilege(u.usename, d.datname, 'CONNECT')) AS allowed_users
FROM pg_database d
ORDER BY d.datname;


SELECT r.rolname ,
       r.rolsuper ,
       r.rolinherit ,
       r.rolcreaterole ,
       r.rolcreatedb ,
       r.rolcanlogin ,
       r.rolconnlimit ,
       r.rolvaliduntil ,
       ARRAY
    ( SELECT b.rolname
     FROM pg_catalog.pg_auth_members m
     JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
     WHERE m.member = r.oid) AS memberof ,
       r.rolreplication
FROM pg_catalog.pg_roles r
ORDER BY 1;


SELECT usename AS role_name ,
       CASE
           WHEN usesuper
                AND usecreatedb THEN CAST('superuser, create database' AS pg_catalog.text)
           WHEN usesuper THEN CAST('superuser' AS pg_catalog.text)
           WHEN usecreatedb THEN CAST('create database' AS pg_catalog.text)
           ELSE CAST('' AS pg_catalog.text)
       END role_attributes
FROM pg_catalog.pg_user
ORDER BY role_name DESC;


SELECT u.usename AS "User Name"
FROM pg_catalog.pg_user u



