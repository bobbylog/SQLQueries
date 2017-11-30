select dbo.getStudentIDFromUID(StudentUID) as StudentID, 
dbo.getStudentFullNameWOptions(dbo.getStudentIDFromUID(StudentUID),2) as LastName,
dbo.getStudentFullNameWOptions(dbo.getStudentIDFromUID(StudentUID),0) as FirstName,
(Department+'-'+CourseID+CourseType) as CourseIdent,
CourseName,
dbo.getCurrentMajorFromUIDByTerm(StudentUID, TermCalendarID) as MajorName,
dbo.getStudentEmailAddress(StudentUID) as EmailAddress,
Grade

from sracademic
where TermCalendarID=614
and 
(Grade NOT 
IN(
'A',
'A-',
'B',
'B+',
'B-',
'C',
'C+',
'TR',
'W',
''
)
and Grade is not null
)