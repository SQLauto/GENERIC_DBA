USE [CustomLog]
GO

/****** Object:  Table [SFDEL].[SF_DELETES_30DAY_TANK]    Script Date: 3/4/2021 3:43:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SFDEL].[SF_DELETES_30DAY_TANK] (
	[DeleteTankID] [int] IDENTITY(1, 1) NOT NULL
	, [ObjectFromSFCreatingDelete] [varchar](128) NOT NULL
	, [IDToDeleteFromSQL] [nvarchar](36) NOT NULL
	, [DateSFLastModified] [datetime] NOT NULL
	, [DateTimeOnThisTable] [datetime] NOT NULL
	, [DeleteSuccessInSQL] [bit] NULL
	, CONSTRAINT [PK_SF_DELETES_30DAY_TANK] PRIMARY KEY CLUSTERED ([DeleteTankID] ASC) WITH (
		PAD_INDEX = OFF
		, STATISTICS_NORECOMPUTE = OFF
		, IGNORE_DUP_KEY = OFF
		, ALLOW_ROW_LOCKS = ON
		, ALLOW_PAGE_LOCKS = ON
		)
	ON [PRIMARY]
	) ON [PRIMARY]
GO

ALTER TABLE [SFDEL].[SF_DELETES_30DAY_TANK] ADD CONSTRAINT [DF_DateTimeOnThisTable] DEFAULT(getdate())
FOR [DateTimeOnThisTable]
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = N'Forced PK to keep table organized, also for auditing if needed in the future'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
	, @level2type = N'COLUMN'
	, @level2name = N'DeleteTankID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = 
	N'This object is what is originating the delete in SalesForce.  This must match a corresponding value in the SF_OBJ_TO_SQL_OBJ in this schema of this DB'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
	, @level2type = N'COLUMN'
	, @level2name = N'ObjectFromSFCreatingDelete'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = N'This is the ID that we will be using in our DELETE FROM statement inside of a trigger'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
	, @level2type = N'COLUMN'
	, @level2name = N'IDToDeleteFromSQL'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = 
	N'This exactly corresponds to the object/column name of LastModifiedDate in SF it will be used and compared to the timestamp on this table to make sure we have held on to record in this tank long enough before purging it from the tank'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
	, @level2type = N'COLUMN'
	, @level2name = N'DateSFLastModified'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = 
	N'This is exactly when the row was inserted on THIS table it will be compared to the DateSFLastModified on this table to make sure we have held on to record in this tank long enough before purging it from the tank'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
	, @level2type = N'COLUMN'
	, @level2name = N'DateTimeOnThisTable'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = 
	N'If the trigger fires with no error, then we will want to somehow find a way to update this flag to 1, the comments to this will be updated once the logic is worked out'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
	, @level2type = N'COLUMN'
	, @level2name = N'DeleteSuccessInSQL'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	, @value = 
	N'This table holds deletes recorded in SalesForce. Since SF holds those deleted records in what effectively is a recycling bin for 30 days, we can''t simply strip them from our database.  This holds them for 30 days and propigates the delete out correctly'
	, @level0type = N'SCHEMA'
	, @level0name = N'SFDEL'
	, @level1type = N'TABLE'
	, @level1name = N'SF_DELETES_30DAY_TANK'
GO


