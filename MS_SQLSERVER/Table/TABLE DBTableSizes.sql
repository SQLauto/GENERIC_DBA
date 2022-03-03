USE [Utility]
GO

CREATE SCHEMA DBINFO
GO


CREATE TABLE [DBINFO].[DBTableSizes](
	[DBOrTableSizeID] [INT] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [NVARCHAR](128) NULL,
	[TableName] [NVARCHAR](128) NULL,
	[RecordsPerTable] [BIGINT] NULL,
	[PercOfDbRows] [DECIMAL](24, 6) NULL,
	[TableSizeInMB] [DECIMAL](38, 3) NULL,
	[PercOfDbSize] [DECIMAL](24, 6) NULL,
	[IndexSizeInMB] [DECIMAL](38, 3) NULL,
	[PercOfOverallIndexSize] [DECIMAL](24, 6) NULL,
	[DateofSizeCheck] [DATE] NULL,
 CONSTRAINT [PK_DBTableSizes] PRIMARY KEY CLUSTERED 
(
	[DBOrTableSizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [DBINFO].[DBTableSizes] ADD  DEFAULT (CONVERT([DATE],GETDATE())) FOR [DateofSizeCheck]
GO


