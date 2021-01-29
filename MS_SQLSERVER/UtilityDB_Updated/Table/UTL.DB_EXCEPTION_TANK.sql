USE CustomLog
GO

/****** Object:  Table [dbo].[DB_EXCEPTION_TANK]    Script Date: 11/23/2020 10:42:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ERR].[DB_EXCEPTION_TANK](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [varchar] (80) NULL, 
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table will hold generic exception data from stored procedured with Try/Catch implementation until such time
        that Mezrah specific exceptions can be created --Dave Babler' , @level0type=N'SCHEMA',@level0name=N'ERR', @level1type=N'TABLE',@level1name=N'DB_EXCEPTION_TANK'
GO


