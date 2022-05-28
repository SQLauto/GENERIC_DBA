SELECT  CASE princ.[type]
             WHEN 'S' THEN
                 princ.[name]
             WHEN 'U' THEN
                 ulogin.[name] COLLATE Latin1_General_CI_AI
        END AS "UserName"
      , CASE princ.[type]
             WHEN 'S' THEN
                 'SQL User'
             WHEN 'U' THEN
                 'Windows User'
        END AS "UserType"
      , princ.[name] AS "DatabaseUserName"
      , NULL AS "Role"
      , perm.[permission_name] AS "PermissionType"
      , perm.[state_desc] AS "PermissionState"
      , obj.type_desc AS "ObjectType"   --perm.[class_desc],       
      , OBJECT_NAME(perm.major_id) AS "ObjectName"
      , col.[name] AS "ColumnName"
FROM
    --database user
    sys.database_principals princ
    LEFT JOIN
    --Login accounts
    sys.user_token AS ulogin
      ON princ.[sid] = ulogin.[sid]
    LEFT JOIN
    --Permissions
    sys.database_permissions perm
      ON perm.[grantee_principal_id] = princ.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col
      ON col.[object_id] = perm.major_id
         AND col.[column_id] = perm.[minor_id]
    LEFT JOIN
    sys.objects obj
      ON perm.[major_id] = obj.[object_id]
WHERE   princ.[type] IN ( 'S', 'U' )
UNION
--List all access provisioned to a sql user or windows user/group through a database or application role
SELECT  CASE memberprinc.[type]
             WHEN 'S' THEN
                 memberprinc.[name]
             WHEN 'U' THEN
                 ulogin.[name] COLLATE Latin1_General_CI_AI
        END AS "UserName"
      , CASE memberprinc.[type]
             WHEN 'S' THEN
                 'SQL User'
             WHEN 'U' THEN
                 'Windows User'
        END AS "UserType"
      , memberprinc.[name] AS "DatabaseUserName"
      , roleprinc.[name] AS "Role"
      , perm.[permission_name] AS "PermissionType"
      , perm.[state_desc] AS "PermissionState"
      , obj.type_desc AS "ObjectType"   --perm.[class_desc],   
      , OBJECT_NAME(perm.major_id) AS "ObjectName"
      , col.[name] AS "ColumnName"
FROM
    --Role/member associations
    sys.database_role_members members
    JOIN
    --Roles
    sys.database_principals roleprinc
      ON roleprinc.[principal_id] = members.[role_principal_id]
    JOIN
    --Role members (database users)
    sys.database_principals memberprinc
      ON memberprinc.[principal_id] = members.[member_principal_id]
    LEFT JOIN
    --Login accounts
    sys.user_token ulogin
      ON memberprinc.[sid] = ulogin.[sid]
    LEFT JOIN
    --Permissions
    sys.database_permissions perm
      ON perm.[grantee_principal_id] = roleprinc.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col
      ON col.[object_id] = perm.major_id
         AND col.[column_id] = perm.[minor_id]
    LEFT JOIN
    sys.objects obj
      ON perm.[major_id] = obj.[object_id]
UNION
--List all access provisioned to the public role, which everyone gets by default
SELECT  '{All Users}' AS "UserName"
      , '{All Users}' AS "UserType"
      , '{All Users}' AS "DatabaseUserName"
      , roleprinc.[name] AS "Role"
      , perm.[permission_name] AS "PermissionType"
      , perm.[state_desc] AS "PermissionState"
      , obj.type_desc AS "ObjectType"   --perm.[class_desc],  
      , OBJECT_NAME(perm.major_id) AS "ObjectName"
      , col.[name] AS "ColumnName"
FROM
    --Roles
    sys.database_principals roleprinc
    LEFT JOIN
    --Role permissions
    sys.database_permissions perm
      ON perm.[grantee_principal_id] = roleprinc.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col
      ON col.[object_id] = perm.major_id
         AND col.[column_id] = perm.[minor_id]
    JOIN
    --All objects   
    sys.objects obj
      ON obj.[object_id] = perm.[major_id]
WHERE
    --Only roles
    roleprinc.[type] = 'R'
    AND
    --Only public role
    roleprinc.[name] = 'public'
    AND
    --Only objects of ours, not the MS objects
    obj.is_ms_shipped = 0
ORDER BY princ.[name]
       , OBJECT_NAME(perm.major_id)
       , col.[name]
       , perm.[permission_name]
       , perm.[state_desc]
       , obj.type_desc; --perm.[class_desc] 