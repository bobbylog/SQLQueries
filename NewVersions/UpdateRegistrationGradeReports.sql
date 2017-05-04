--EXEC CAMS_SracademicByStudent 66272, 'Official'

select *, RegistrationStatus, ShowGradeReport from SRAcademic where 
--StudentUID=66272
--and 
registrationstatus='official'
--and Section like 'c%'
and TermCalendarID=614

--update SRAcademic set ShowGradeReport='yes'
--where 
----StudentUID=66272
----and 
--registrationstatus='official'
----and Section like 'c%'
--and TermCalendarID=614
