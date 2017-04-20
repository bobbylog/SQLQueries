SELECT FacultyID, LastName, FirstName, Email1, ActiveFlag, Active
FROM  dbo.CAMS_FacultyAddressList_View
WHERE (ActiveFlag = 'yes') AND (Active = 1)