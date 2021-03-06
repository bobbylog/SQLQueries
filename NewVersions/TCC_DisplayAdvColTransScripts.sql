USE [CAMSDB]
GO
/****** Object:  StoredProcedure [dbo].[TCC_DisplayAdvColTransScripts]    Script Date: 5/11/2017 4:41:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[TCC_DisplayAdvColTransScripts]
	-- Add the parameters for the stored procedure here
	@suid varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select * from dbo.AdvStudentPortalAlertsView
	
	
	IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

		CREATE TABLE #tmpDirectory (
			   id int IDENTITY(1,1)
			  ,subdirectory nvarchar(512)
			  ,depth int
			  ,isfile bit);

		INSERT #tmpDirectory (subdirectory,depth,isfile)
		EXEC master.sys.xp_dirtree 'C:\Inetpub\wwwroot\Repository\Advisement\ColT',1,1;

		select * 
		from #tmpDirectory
		WHERE subdirectory like 'Col'+ltrim(rtrim(@suid))+'%'
		order by subdirectory asc

		drop table #tmpDirectory



END
