select StudentUID, StudentID, LastName, FirstName, typeid, AdmitDate from Student where 
--LastName like 'stief%'
--and 
StudentID='A0000015526'

select [dbo].[getAdvisorDetailsByStudentID] ('sp-17','A0000015526',6) as advisordetails

select FacultyID, LastName, FirstName from faculty where lastname like 'ried%'

select FacultyID, PortalAlias, PortalPassword, PortalAccess from FacultyPortal where FacultyID=53841

select StudentUID, PortalPassword, LastName, FirstName, PortalHandle, PortalEnable, PortalPIN, PINValidateDT from CAMS_Student_Portal_Who_View
where StudentUID=66272

--select * from Student where LastName='shannon'