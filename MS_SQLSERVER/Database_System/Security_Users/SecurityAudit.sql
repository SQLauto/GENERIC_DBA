/*
Security Audit Report
1) List all access provisioned to a sql user or windows user/group directly 
2) List all access provisioned to a sql user or windows user/group through a database or application role
3) List all access provisioned to the public role

Columns Returned:
UserName        : SQL or Windows/Active Directory user account.  This could also be an Active Directory group.
UserType        : Value will be either 'SQL User' or 'Windows User'.  This reflects the type of user defined for the 
                  SQL Server user account.
DatabaseUserName: Name of the associated user as defined in the database user account.  The database user may not be the
                  same as the server user.
Role            : The role name.  This will be null if the associated permissions to the object are defined at directly
                  on the user account, otherwise this will be the name of the role that the user is a member of.
PermissionType  : Type of permissions the user/role has on an object. Examples could include CONNECT, EXECUTE, SELECT
                  DELETE, INSERT, ALTER, CONTROL, TAKE OWNERSHIP, VIEW DEFINITION, etc.
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
PermissionState : Reflects the state of the permission type, examples could include GRANT, DENY, etc.
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
ObjectType      : Type of object the user/role is assigned permissions on.  Examples could include USER_TABLE, 
                  SQL_SCALAR_FUNCTION, SQL_INLINE_TABLE_VALUED_FUNCTION, SQL_STORED_PROCEDURE, VIEW, etc.   
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.          
ObjectName      : Name of the object that the user/role is assigned permissions on.  
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
ColumnName      : Name of the column of the object that the user/role is assigned permissions on. This value
                  is only populated if the object is a table, view or a table value function.                 
*/
--List all access provisioned to a sql user or windows user/group directly 
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
      , PERM.[permission_name] AS "PermissionType"
      , PERM.[state_desc] AS "PermissionState"
      , obj.type_desc AS "ObjectType"
--perm.[class_desc],       
      , OBJECT_NAME(PERM.major_id) AS "ObjectName"
      , col.[name] AS "ColumnName"
FROM
    --database user
    sys.database_principals princ
    LEFT JOIN
    --Login accounts
    sys.login_token ulogin
      ON princ.[sid] = ulogin.[sid]
    LEFT JOIN
    --Permissions
    sys.database_permissions PERM
      ON PERM.[grantee_principal_id] = princ.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col
      ON col.[object_id] = PERM.major_id
         AND col.[column_id] = PERM.[minor_id]
    LEFT JOIN
    sys.objects obj
      ON PERM.[major_id] = obj.[object_id]
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
      , PERM.[permission_name] AS "PermissionType"
      , PERM.[state_desc] AS "PermissionState"
      , obj.type_desc AS "ObjectType"
--perm.[class_desc],   
      , OBJECT_NAME(PERM.major_id) AS "ObjectName"
      , col.[name] AS "ColumnName"
FROM
    --Role/member associations
    sys.database_role_members members
    INNER JOIN
    --Roles
    sys.database_principals roleprinc
       ON roleprinc.[principal_id] = members.[role_principal_id]
    INNER JOIN
    --Role members (database users)
    sys.database_principals memberprinc
       ON memberprinc.[principal_id] = members.[member_principal_id]
    LEFT JOIN
    --Login accounts
    sys.login_token ulogin
      ON memberprinc.[sid] = ulogin.[sid]
    LEFT JOIN
    --Permissions
    sys.database_permissions PERM
      ON PERM.[grantee_principal_id] = roleprinc.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col
      ON col.[object_id] = PERM.major_id
         AND col.[column_id] = PERM.[minor_id]
    LEFT JOIN
    sys.objects obj
      ON PERM.[major_id] = obj.[object_id]
UNION

--List all access provisioned to the public role, which everyone gets by default
SELECT  '{All Users}' AS "UserName"
      , '{All Users}' AS "UserType"
      , '{All Users}' AS "DatabaseUserName"
      , roleprinc.[name] AS "Role"
      , PERM.[permission_name] AS "PermissionType"
      , PERM.[state_desc] AS "PermissionState"
      , obj.type_desc AS "ObjectType"
--perm.[class_desc],  
      , OBJECT_NAME(PERM.major_id) AS "ObjectName"
      , col.[name] AS "ColumnName"
FROM
    --Roles
    sys.database_principals roleprinc
    LEFT JOIN
    --Role permissions
    sys.database_permissions PERM
      ON PERM.[grantee_principal_id] = roleprinc.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col
      ON col.[object_id] = PERM.major_id
         AND col.[column_id] = PERM.[minor_id]
    INNER JOIN
    --All objects   
    sys.objects obj
       ON obj.[object_id] = PERM.[major_id]
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
       , OBJECT_NAME(PERM.major_id)
       , col.[name]
       , PERM.[permission_name]
       , PERM.[state_desc]
       , obj.type_desc; --perm.[class_desc] 
