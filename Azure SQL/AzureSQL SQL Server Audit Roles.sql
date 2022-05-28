SELECT  DP1.name AS "DatabaseRoleName"
      , ISNULL(DP2.name, 'No members') AS "DatabaseUserName"
FROM    sys.database_role_members AS DRM
    RIGHT OUTER JOIN
    sys.database_principals AS DP1
       ON DRM.role_principal_id = DP1.principal_id
    LEFT OUTER JOIN
    sys.database_principals AS DP2
      ON DRM.member_principal_id = DP2.principal_id
WHERE   DP1.type = 'R'
        AND DP2.name IS NOT NULL
UNION
SELECT  CONCAT('Current TimeStamp On DB Server:', CONVERT(NVARCHAR(50), SERVERPROPERTY('ServerName')))
      , CONVERT(
            NVARCHAR(80)
          , CONVERT(
                DATETIME, GETDATE()AT TIME ZONE (SELECT     CURRENT_TIMEZONE_ID()) AT TIME ZONE 'Eastern Standard Time'))
ORDER BY 1 DESC;
