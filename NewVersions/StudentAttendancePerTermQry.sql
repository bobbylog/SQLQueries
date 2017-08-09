--Select * From CAMS_StudentAttendance_View Where TermCalendarID = 614 
--And SROfferID = 100519
--order by StudentID asc


Select StudentID,  StudentUID, SROfferID, Status, Count(StatusID) as AttStatCnt , Term, TermCalendarID,OfferDepartment, OfferType,OfferSection, OfferName
From CAMS_StudentAttendance_View Where TermCalendarID = 614 
--And SROfferID = 100519

group by StudentID,StudentUID,SROfferID, Status, Term, TermCalendarID,OfferDepartment, OfferType,OfferSection, OfferName
order by StudentID asc

/*1054 present
1049 absence
2933 no class
*/