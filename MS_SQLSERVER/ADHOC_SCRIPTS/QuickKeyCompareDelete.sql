DECLARE @tblNameChild NVARCHAR(64) = N'';
DECLARE @colForeignKey NVARCHAR(64) = N'';
DECLARE @tblNameParent NVARCHAR(64) = N'';
DECLARE @colNamePrimaryKey NVARCHAR(64) = N''
DECLARE @sqlSTMT NVARCHAR(MAX) = N' SELECT ' + @colForeignKey + ' 
									FROM ' + @tblNameChild + ' 
									WHERE ' + 
	@colForeignKey + ' NOT IN (
									SELECT ' + @colNamePrimaryKey + '
										FROM ' + @tblNameParent + ') ';
DECLARE @DELETE_STATEMENT_WARNING NVARCHAR(MAX) = N' DELETE	FROM ' + @tblNameChild + ' 
									WHERE ' + @colForeignKey + 
	' NOT IN (
									SELECT ' + @colNamePrimaryKey + '
										FROM ' + @tblNameParent + ') ';

PRINT @sqlSTMT;

EXEC sp_executesql @sqlSTMT

-- EXEC sp_executesql @DELETE_STATEMENT_WARNING
