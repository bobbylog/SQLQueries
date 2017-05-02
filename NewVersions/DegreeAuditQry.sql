SELECT DegreeName, ProgramName, ProgramCreditsRequired, RequirementCreditsRequired, RequirementMinimumGPA, GroupName, CatalogTerm, RequirementName, 
               ProgramMinimumGPA, GroupRequired, GroupFormula, GroupCreditsRequired, GroupMinimumGPA, CourseRequired, CourseCreditsApplyToGroup, 
               CourseTransferApplyToGroup, CourseEquivalentApplyToGroup, CourseRequirePrerequisite, CourseDepartment, CourseID, CourseType, Coursename, 
               CourseCredits, CourseMinimumGrade, ReqSortOrder, GrpSortOrder
FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')

--select * from CAMS_StudentProgram_View
--where StudentUID=56392

-- Courses taken
select distinct termcalendarid, CourseID, CourseType, Section, Department , CourseName from SRAcademic
where StudentUID=56392


--Common Courses
select distinct termcalendarid, CourseID, CourseType, Section, Department , CourseName from SRAcademic
where StudentUID=56392
and CourseID in
(
SELECT distinct courseid 
        FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')
)

--Common Courses
select distinct termcalendarid, CourseID, CourseType, Section, Department , CourseName 
into #tmpCourseCom
from SRAcademic
where StudentUID=56392
and CourseID in
(
SELECT distinct courseid 
        FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')
)

SELECT DegreeName, ProgramName, CatalogTerm, RequirementName, CourseRequired, CourseDepartment, CourseID, CourseType, Coursename
               FROM  dbo.CAMS_DegreeAuditSetup_View AS CAMS_DegreeAuditSetup_View
WHERE (ProgramName = 'Nursing') AND (CatalogTerm = 'FA-17')
and CourseID not in
(
select distinct CourseID from #tmpCourseCom
)



drop table #tmpCourseCom