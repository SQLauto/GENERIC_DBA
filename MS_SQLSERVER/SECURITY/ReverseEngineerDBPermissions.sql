/****** Object: StoredProcedure [dbo].[usp_get_object_permissions] Script Date: 10/07/2011 14:28:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- run this script from the user database
--exec usp_get_object_permissions
--drop proc usp_get_object_permissions
--go
CREATE PROCEDURE [dbo].[usp_get_object_permissions]
AS
SET NOCOUNT ON
SET QUOTED_IDENTIFIER OFF

DECLARE @as_ObjectName SYSNAME

SET @as_ObjectName = NULL

--database owner info
SELECT 'alter authorization on database::[' + db_name() + '] to [' + suser_sname(owner_sid) + ']' AS 
	'--owner of database when script was created'
FROM master.sys.databases
WHERE name = db_name()

--drop and recreate users
SELECT 
	'-- It is not always necessary to drop and recreate the users it will depend on the circumstances under which you need to run this script'

SELECT 'drop user [' + name + ']'
FROM sys.database_principals
WHERE principal_id > 4
	AND owning_principal_id IS NULL
	AND type != 'A'
ORDER BY name

SELECT 'CREATE USER [' + dp.name collate database_default + '] FOR LOGIN [' + sp.name + ']' + CASE dp.type
		WHEN 'G'
			THEN ' '
		ELSE ' WITH DEFAULT_SCHEMA=[' + dp.default_schema_name + ']'
		END AS '-- by default Orphaned users will not be recreated'
FROM sys.server_principals sp
INNER JOIN sys.database_principals dp
	ON dp.sid = sp.sid
WHERE dp.principal_id > 4
	AND dp.owning_principal_id IS NULL
	AND sp.name <> ''
ORDER BY dp.name

-- Recreate the User defined roles
SELECT '-- server created roles should be added by the correct processes'

SELECT 'CREATE ROLE [' + name + '] AUTHORIZATION [' + USER_NAME(owning_principal_id) + ']'
FROM     sys.database_principals     where name != 'public'
	AND type = 'R'
	AND is_fixed_role = 0

-- recreate application roles
SELECT 'CREATE APPLICATION ROLE [' + name + '] with password = ' + QUOTENAME('insertpwdhere', '''') + ' ,default_schema = [' + 
	default_schema_name + ']'
FROM     sys.database_principals     where type = 'A'

-- ADD ROLE MEMBERS
SELECT 'EXEC sp_addrolemember [' + dp.name + '], [' + USER_NAME(drm.member_principal_id) + '] ' AS [-- AddRolemembers]
FROM sys.database_role_members drm
INNER JOIN sys.database_principals dp
	ON dp.principal_id = drm.role_principal_id
WHERE USER_NAME(drm.member_principal_id) != 'dbo'
ORDER BY drm.role_principal_id

-- CREATE GRANT Object PERMISSIONS SCRIPT
SELECT replace(state_desc, '_with_grant_option', '') + ' ' + permission_name + ' ON [' + OBJECT_SCHEMA_NAME(major_id) + '].[' + 
	OBJECT_NAME(major_id) + ']' + CASE minor_id
		WHEN 0
			THEN ' '
		ELSE ' ([' + col_name(sys.database_permissions.major_Id, sys.database_permissions.minor_id) + '])'
		END + ' TO [' + USER_NAME(grantee_principal_id) + ']' + CASE 
		WHEN state_desc LIKE '%with_grant_option'
			THEN ' with grant option'
		ELSE ' '
		END AS '-- object/column permissions'
FROM sys.database_permissions(NOLOCK)
WHERE class NOT IN (0, 3)
	AND major_id = ISNULL(OBJECT_ID(@as_ObjectName), major_id)
--AND OBJECT_SCHEMA_NAME(major_id) != 'SYS'
ORDER BY USER_NAME(grantee_principal_id)
	, OBJECT_SCHEMA_NAME(major_id)
	, OBJECT_NAME(major_id)

--SCHEMA permissions
SELECT replace(state_desc, '_with_grant_option', '') + ' ' + permission_name + ' ON SCHEMA::[' + SCHEMA_NAME(major_id) + ']' + + ' TO [' 
	+ USER_NAME(grantee_principal_id) + ']' + CASE 
		WHEN state_desc LIKE '%with_grant_option'
			THEN ' with grant option'
		ELSE ' '
		END AS '-- Schema permissions'
FROM sys.database_permissions(NOLOCK)
WHERE class_desc = 'SCHEMA'
ORDER BY USER_NAME(grantee_principal_id)
	, SCHEMA_NAME(major_id)

SELECT replace(state_desc, '_with_grant_option', '') + ' ' + permission_name + ' TO [' + USER_NAME(grantee_principal_id) + ']' + CASE 
		WHEN state_desc LIKE '%with_grant_option'
			THEN ' with grant option'
		ELSE ' '
		END
FROM sys.database_permissions(NOLOCK)
WHERE permission_name = 'VIEW DEFINITION'
	AND class_desc = 'database'
ORDER BY USER_NAME(grantee_principal_id)
