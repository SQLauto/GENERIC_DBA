SELECT r.rolname, r.rolsuper, r.rolinherit,
  r.rolcreaterole, r.rolcreatedb, r.rolcanlogin,
  r.rolconnlimit, r.rolvaliduntil,
  ARRAY(SELECT b.rolname
        FROM pg_catalog.pg_auth_members m
        JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
        WHERE m.member = r.oid) as memberof
, r.rolreplication
, r.rolbypassrls
FROM pg_catalog.pg_roles r
WHERE r.rolname !~ '^pg_'
ORDER BY 1;


SELECT * FROM pg_user;

WITH RECURSIVE cte AS (
   SELECT oid FROM pg_roles WHERE rolname = 'SECAdmin'

   UNION ALL
   SELECT m.roleid
   FROM   cte
   JOIN   pg_auth_members m ON m.member = cte.oid
   )
SELECT oid, oid::regrole::text AS rolename FROM cte;  -- oid & name


SELECT *
FROM ERR.db_exception_tank det 