;WITH RoleMembers
   (member_principal_id, role_principal_id)
  AS (   SELECT rm1.member_principal_id
              , rm1.role_principal_id
         FROM   sys.database_role_members rm1 (NOLOCK)
         UNION ALL
         SELECT d.member_principal_id
              , rm.role_principal_id
         FROM   sys.database_role_members rm (NOLOCK)
             INNER JOIN
             RoleMembers AS d
                ON rm.member_principal_id = d.role_principal_id)
SELECT  DISTINCT
        rp.name AS "database_role"
      , mp.name AS "database_userl"
FROM    RoleMembers drm
    JOIN
    sys.database_principals rp
      ON (drm.role_principal_id = rp.principal_id)
    JOIN
    sys.database_principals mp
      ON (drm.member_principal_id = mp.principal_id)
--WHERE   rp.name = ''
ORDER BY rp.name;