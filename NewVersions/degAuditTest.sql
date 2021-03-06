USE [CAMS_Enterprise]
GO
/****** Object:  StoredProcedure [dbo].[TCC_Find_MustTakeToGrad]    Script Date: 05/02/2017 17:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[TCC_Find_MustTakeToGrad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--select distinct termcalendarid, CourseID, CourseType, Section, Department , CourseName 
--into #AuditTaken
--from SRAcademic
--where StudentUID=56392
--and CourseID in
--(
--SELECT distinct courseid 
--        FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
--WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')
--)

--SELECT DegreeName, ProgramName ,CatalogTerm as termcalendarid, RequirementName,CourseRequired, CourseDepartment as Department,
-- CourseID, CourseType, Coursename, CourseCredits, '' as Section
-- FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
--WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')
--and CourseID not in
--(
-- select distinct CourseID from #AuditTaken
-
SELECT DISTINCT SR.Department+SR.CourseID+SR.CourseType as crscode, SR.TermCalendarID, SR.CourseID, SR.CourseType, SR.Section, SR.Department, SR.CourseName
into #CrsMatch
FROM  dbo.SRAcademic AS SR INNER JOIN
               dbo.CAMS_DegreeAuditSetup_View AS DASV ON SR.CourseID = DASV.CourseID AND SR.CourseType = DASV.CourseType AND 
               SR.Department = DASV.CourseDepartment
WHERE (DASV.ProgramName = 'Nursing') AND (DASV.CatalogTerm = 'FA-17') AND (SR.StudentUID = 56392)


SELECT CourseDepartment+CourseID+CourseType as CrsCode, DegreeName, ProgramName ,CatalogTerm as termcalendarid, RequirementName,CourseRequired, CourseDepartment as Department,
 CourseID, CourseType, Coursename, CourseCredits, '' as Section
 into #DegAudit
 FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')


select * from #DegAudit 
where CrsCode not in
(
 select distinct crscode from #CrsMatch
)

drop table #DegAudit
drop table #CrsMatch


END
