select 'update' as action, portalHandle as username, dbo.getStudentIDFromUID(StudentUID) as SID ,  dbo.getStudentEmailAddress(StudentUID) as Email , PortalPassword as NPassword , dbo.getStudentFullNameWOptions(dbo.getStudentIDFromUID(StudentUID), 2) as Lastname, dbo.getStudentFullNameWOptions(dbo.getStudentIDFromUID(StudentUID), 0) as FirstName
from studentportal
where dbo.getStudentIDFromUID(StudentUID) in
(
'A0000005032',
'A0000019317',
'A0000027692',
'A0000027725',
'A0000027882',
'A0000028428'


)
