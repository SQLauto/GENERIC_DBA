--shove this in to a foralldb loop
;WITH ROLE_MEMBERS
AS (SELECT DP1.name AS DatabaseRoleName
		 , ISNULL(DP2.name, 'No members') AS DatabaseUserName
	FROM
		sys.database_role_members AS DRM
	RIGHT OUTER JOIN sys.database_principals AS DP1
				  ON DRM.role_principal_id = DP1.principal_id
	LEFT OUTER JOIN sys.database_principals AS DP2
				 ON DRM.member_principal_id = DP2.principal_id
	WHERE DP1.type = 'R')
SELECT DISTINCT
	  DB_NAME() AS DBName
	 ,  pr.principal_id
	 , pr.name AS RoleName
	 	 , rm.DatabaseUserName
	 , pr.type_desc AS User_or_Role
	 , pr.authentication_type_desc AS Auth_Type
	 , pe.state_desc
	 , pe.permission_name
	 , pe.class_desc
	 , o.name AS "Object"

FROM
	sys.database_principals AS pr
JOIN sys.database_permissions AS pe
  ON pe.grantee_principal_id = pr.principal_id
LEFT JOIN sys.objects AS o
	   ON (o.object_id = pe.major_id)
JOIN ROLE_MEMBERS AS rm
  ON pr.name = rm.DatabaseRoleName;
