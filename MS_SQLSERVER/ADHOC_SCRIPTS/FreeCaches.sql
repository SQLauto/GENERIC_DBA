EXECUTE master.sys.sp_MSforeachdb 'USE [?] CHECKPOINT';
EXECUTE master.sys.sp_MSforeachdb 'USE [?] DBCC FREESYSTEMCACHE(''ALL'') WITH MARK_IN_USE_FOR_REMOVAL';
EXECUTE master.sys.sp_MSforeachdb 'USE [?] DBCC FREEPROCCACHE;';
EXECUTE master.sys.sp_MSforeachdb 'USE [?] DBCC DROPCLEANBUFFERS;';
EXECUTE master.sys.sp_MSforeachdb 'USE [?] DBCC FREESESSIONCACHE;';
EXECUTE master.sys.sp_MSforeachdb 'USE [?] CHECKPOINT';