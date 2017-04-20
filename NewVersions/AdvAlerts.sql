USE [CAMS_Enterprise]
GO

/****** Object:  Table [dbo].[AdvPortalAlerts]    Script Date: 01/26/2017 15:29:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


drop TABLE [dbo].[AdvPortalAlerts]

CREATE TABLE [dbo].[AdvPortalAlerts](
	[AlertID] [int] identity(1,1) NOT NULL,
	[Postid] [varchar](25),
	[DateAlert] [datetime] ,
	[TTerm] varchar(25),
	[StudentID] [varchar](25),
	[FacultyID] [varchar](25),
	[CourseID] [varchar](25),
	[Coursename] [varchar](150),
	[CAttendance] [bit],
	[CLate] [bit] ,
	[CAssignment] [bit] ,
	[CPIssues] [bit] ,
	[CInattentive] [bit],
	[COther] [varchar](400),
	[Notes] [varchar](max)
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


