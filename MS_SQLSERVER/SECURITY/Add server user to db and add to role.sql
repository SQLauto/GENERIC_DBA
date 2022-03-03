USE [DatabaseName]
GO
CREATE USER [ActiveDirectoryName\UserorGroupName] FOR LOGIN [ActiveDirectoryName\UserorGroupName]
GO
USE [DatabaseName]
GO
ALTER ROLE [DB_EXISTING_ROLE_NAME] ADD MEMBER [ActiveDirectoryName\UserorGroupName]
GO
