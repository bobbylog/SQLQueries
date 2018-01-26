select 'update' as action, portalHandle as username, dbo.getStudentIDFromUID(StudentUID) as SID ,  dbo.getStudentEmailAddress(StudentUID) as Email , PortalPassword as NPassword , dbo.getStudentFullNameWOptions(dbo.getStudentIDFromUID(StudentUID), 2) as Lastname, dbo.getStudentFullNameWOptions(dbo.getStudentIDFromUID(StudentUID), 0) as FirstName
from studentportal
where dbo.getStudentIDFromUID(StudentUID) in
(
'A0000000351',
'A0000013182',
'A0000027435',
'A0000028473',
'A0000028747',
'A0000028785',
'C0000041505'
)
