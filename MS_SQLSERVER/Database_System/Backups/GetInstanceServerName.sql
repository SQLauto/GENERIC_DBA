SET NOCOUNT ON;

DECLARE @key        VARCHAR(100)
      , @PortNumber VARCHAR(20);

IF CHARINDEX('\', CONVERT(CHAR(20), SERVERPROPERTY('servername')), 0) <> 0
    BEGIN
        SET @key = 'SOFTWARE\MICROSOFT\Microsoft SQL Server\' + @@SERVICENAME + '\MSSQLServer\Supersocketnetlib\TCP';
    END;
ELSE
    BEGIN
        SET @key = 'SOFTWARE\MICROSOFT\MSSQLServer\MSSQLServer\Supersocketnetlib\TCP';
    END;

EXEC master..xp_regread @rootkey = 'HKEY_LOCAL_MACHINE'
                      , @key = @key
                      , @value_name = 'Tcpport'
                      , @value = @PortNumber OUTPUT;

SELECT  CONVERT(CHAR(20), SERVERPROPERTY('servername')) AS "ServerName"
      , CONVERT(CHAR(20), SERVERPROPERTY('InstanceName')) AS "instancename"
      , CONVERT(CHAR(20), SERVERPROPERTY('MachineName')) AS "HOSTNAME"
      , CONVERT(VARCHAR(10), @PortNumber) AS "PortNumber";
