DECLARE @strLoopCommand VARCHAR (2000);

SET @strLoopCommand = '    USE ?
    SELECT DISTINCT 
		DB_NAME()
		,  rp.name
        , ObjectType = rp.type_desc
        , PermissionType = pm.class_desc
        , pm.permission_name
        , pm.state_desc
        , ObjectType = CASE 
            WHEN obj.type_desc IS NULL
                OR obj.type_desc = ''SYSEM_TABLE''
                THEN pm.class_desc
            ELSE obj.type_desc
            END
        , s.Name AS SchemaName
        , [ObjectName] = Isnull(ss.name, Object_name(pm.major_id))
    FROM sys.database_principals rp
    INNER JOIN sys.database_permissions pm
        ON pm.grantee_principal_id = rp.principal_id
    LEFT JOIN sys.schemas ss
        ON pm.major_id = ss.schema_id
    LEFT JOIN sys.objects obj
        ON pm.[major_id] = obj.[object_id]
    LEFT JOIN sys.schemas s
        ON s.schema_id = obj.schema_id
    WHERE rp.type_desc = ''DATABASE_ROLE''
        AND pm.class_desc <> ''DATABASE''
        AND rp.name <> ''public''
    ORDER BY rp.name
        , ObjectName';

EXEC sp_MSforeachdb @strLoopCommand;




-------


SELECT state_desc
    ,permission_name
    ,'ON' [ON]
    ,class_desc
    ,SCHEMA_NAME(major_id) [SchemaName]
    ,'TO' [TO]
    ,USER_NAME(grantee_principal_id) [RoleName]
FROM sys.database_permissions AS PERM
JOIN sys.database_principals AS Prin
    ON PERM.major_ID = Prin.principal_id
        AND class_desc = 'SCHEMA'
ORDER BY RoleName

----

SELECT DISTINCT rp.name, 
                ObjectType = rp.type_desc, 
                PermissionType = pm.class_desc, 
                pm.permission_name, 
                pm.state_desc, 
                ObjectType = CASE 
                               WHEN obj.type_desc IS NULL 
                                     OR obj.type_desc = 'SYSTEM_TABLE' THEN 
                               pm.class_desc 
                               ELSE obj.type_desc 
                             END, 
                s.Name as SchemaName,
                [ObjectName] = Isnull(ss.name, Object_name(pm.major_id)) 
FROM   sys.database_principals rp 
       INNER JOIN sys.database_permissions pm 
               ON pm.grantee_principal_id = rp.principal_id 
       LEFT JOIN sys.schemas ss 
              ON pm.major_id = ss.schema_id 
       LEFT JOIN sys.objects obj 
              ON pm.[major_id] = obj.[object_id] 
       LEFT JOIN sys.schemas s
              ON s.schema_id = obj.schema_id
WHERE  rp.type_desc = 'DATABASE_ROLE' 
       AND pm.class_desc <> 'DATABASE' 
	   AND rp.name <> 'public'
ORDER  BY rp.name
, ObjectName

