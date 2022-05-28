DECLARE @kill VARCHAR(8000) = '';

SELECT  @kill = @kill + 'KILL ' + CONVERT(VARCHAR(5), c.session_id) + ';' + CHAR(10) + 'GO' + CHAR(10)
FROM    sys.dm_exec_connections AS c
    JOIN
    sys.dm_exec_sessions AS s
      ON c.session_id = s.session_id
WHERE   c.session_id <> @@SPID
ORDER BY c.connect_time ASC;

PRINT (@kill);