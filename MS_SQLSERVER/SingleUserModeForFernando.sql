--Issue a checkpoint DO THIS FIRST!
USE [yourdatabaseforSinleUser]
CHECKPOINT;
GO

-- kill active connections
/*     
    1.	Press the Windows Key (⊞).  
    2.	Search by typing in “configuration manager”.
    3.	Choose “SQL SERVER [your model year] Configuration Manager”.
    4.	Right click any service under “SQL Server Services” EXCEPT “SQL Server (MSSQLSERVER)” 
            a.	Choose Stop.
            b.	Repeat for everything EXCEPT SQL Server (MSSQLSERVER)” 
            c.	Minimize this window.
 */




USE [master];
GO
DECLARE @kill VARCHAR(8000) = '';

SELECT @kill = @kill + 'kill ' + CONVERT(VARCHAR(5), session_id) + ';'
FROM sys.dm_exec_sessions
WHERE database_id = db_id('MyDB')

EXEC (@kill);

--CLOSE ALL WINDOWS IN SSMS EXCEPT THE ONE YOU CURRENTLY ARE WORKING IN!

USE  [yourdatabaseforSinleUser]
CHECKPOINT;

--one more checkpoint please


USE [master];--must be done from master
GO

ALTER DATABASE [yourdatabaseforSinleUser]
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;


-- run the kill script above again.  Close that window and open a new one. Repeat until it behaves.

USE [yourdatabaseforSinleUser]
 --- do stuff.
    --- do more stuff?
    ---- oh GOD why do you keep doing stuff get out of single user ASAP!!!
    --------what did you break?

---whew! it's fixed!

CHECKPOINT;

--TIME FOR BACK MULTI USER!

USE [master]
ALTER DATABASE  [yourdatabaseforSinleUser]
SET MULTI_USER;
GO

--TIME TO CLEAN WHATEVER GARBAGE WAS STUCK--WE PROBABLY HAVE TO REBOOT ANYWAY
DBCC FREESYSTEMCACHE('ALL');
DBCC FREEPROCCACHE;


--now go back to the configuration manager.   

/* 
        1.	Right click and choose “Restart” on “SQL Server (MSSQLSERVER)”.
            a.	Wait for it to restart.
        2.	Right click all the other services and click start, one-by-one.
        3.	Close this window, and keep it a secret from nonDBAs it’s dangerous.
        --I'm all about sharing knowledge, ... except with somethings. 
 */