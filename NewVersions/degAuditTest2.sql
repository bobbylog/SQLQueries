SELECT DISTINCT SR.Department+SR.CourseID+SR.CourseType as crscode, SR.TermCalendarID, SR.CourseID, SR.CourseType, SR.Section, SR.Department, SR.CourseName
into #CrsMatch
FROM  dbo.SRAcademic AS SR INNER JOIN
               dbo.CAMS_DegreeAuditSetup_View AS DASV ON SR.CourseID = DASV.CourseID AND SR.CourseType = DASV.CourseType AND 
               SR.Department = DASV.CourseDepartment
WHERE (DASV.ProgramName = 'Nursing') AND (DASV.CatalogTerm = 'FA-17') AND (SR.StudentUID = 56392)


select distinct Department+CourseID+CourseType as CrsCode, termcalendarid, Department,CourseID,CourseType,Section,CourseName 
into #crstaken
from SRAcademic
where StudentUID=56392

select * from #CrsMatch
--select * from #crstaken

select * from #crstaken
where CrsCode not in
(
select distinct crscode from #crsmatch
)


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
drop table #crstaken