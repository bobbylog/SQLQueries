 --SELECT 
 --"CAMS_RptSROfferType1000_View"."Department", 
 --"CAMS_RptSROfferType1000_View"."Course", 
 --"CAMS_RptSROfferType1000_View"."Section", 
 --"CAMS_RptSROfferType1000_View"."Credits", 
 --"CAMS_RptSROfferType1000_View"."CourseName", 
 --"CAMS_RptSROfferType1000_View"."OfferDays", 
 --"CAMS_RptSROfferType1000_View"."RoomNumber", 
 --"CAMS_RptSROfferType1000_View"."FacultyLastName", 
 --"CAMS_RptSROfferType1000_View"."FacultyFirstName", 
 --"CAMS_RptSROfferType1000_View"."TextTerm", 
 --"CAMS_RptSROfferType1000_View"."OfferTimeFrom", 
 --"CAMS_RptSROfferType1000_View"."OfferTimeTo", 
 --"tmpRptBYOROffering"."ReportKey", 
 --"CAMS_RptSROfferType1000_View"."SemesterID" 
 --FROM   
 --"CAMS_Enterprise"."dbo"."tmpRptBYOROffering" "tmpRptBYOROffering" 
 --INNER JOIN "CAMS_Enterprise"."dbo"."CAMS_RptSROfferType1000_View" "CAMS_RptSROfferType1000_View" ON 
 --"tmpRptBYOROffering"."SROfferID"="CAMS_RptSROfferType1000_View"."SROfferID" 
 --WHERE  "tmpRptBYOROffering"."ReportKey"=363569 AND "CAMS_RptSROfferType1000_View"."SemesterID"=617

drop table #TmpOfferings


SELECT     '' as Heading, Department, Department+Course+Section as courseID, CourseName, Credits, OfferDays,CONVERT(char(10), [OfferTimeFrom], 108) as  OfferTimeFrom, CONVERT(char(10), [OfferTimeTo], 108) as OfferTimeTo, RoomNumber,  FacultyLastName+', '+ FacultyFirstName as Instructor, TextTerm, SemesterID
into #TmpOfferings
FROM         dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View
WHERE     (SemesterID = 617)
union All
SELECT     distinct Department as Heading, Department, '' as courseID, '' as CourseName, -1 as Credits, '' as OfferDays, '' as OfferTimeFrom,'' as OfferTimeTo, '' as RoomNumber,  '' as Instructor, '' as TextTerm, '' as SemesterID
FROM         dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View
WHERE     (SemesterID = 617)


Select * from #TmpOfferings
order by Department, Credits ASC

drop table #TmpOfferings
