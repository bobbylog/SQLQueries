select GL.DisplayText  as MajorN  , SS.StudentUID, SS.TermCalendarID
from StudentStatusUDef SSD
inner join Glossary GL on SSD.UDefLookup1=GL.UniqueId
inner join StudentStatus SS on SS.StudentStatusID=ssd.StudentStatusID
where GL.DisplayText like 'LA/%'
and ss.TermCalendarID=612
