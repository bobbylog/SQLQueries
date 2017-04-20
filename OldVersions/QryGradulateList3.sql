/*select distinct 
tmptbl.studentssn,
tmptbl.birthdate,
tmptbl.studentname,
tmptbl.textterm,
tmptbl.studentuid,
tmptbl.studentid

 from (
 SELECT "CAMS_RptRosterViewwSSNBD"."StudentSSN", "CAMS_RptRosterViewwSSNBD"."BirthDate", "CAMS_RptRosterViewwSSNBD"."StudentName", "CAMS_RptRosterViewwSSNBD"."TextTerm", "CAMS_RptRosterViewwSSNBD"."StudentUID", "CAMS_RptRosterViewwSSNBD"."StudentID", "CAMS_RptRosterViewwSSNBD"."Section", "CAMS_RptSROfferType1000_View"."Course","CAMS_RptRosterViewwSSNBD"."CourseName"
 FROM   (("CAMS_Enterprise"."dbo"."tmpRptBYORRoster" "tmpRptBYORRoster" LEFT OUTER JOIN "CAMS_Enterprise"."dbo"."CAMS_RptStudentAddressList_View" "CAMS_RptStudentAddressList_View" ON ("tmpRptBYORRoster"."StudentUID"="CAMS_RptStudentAddressList_View"."StudentUID") AND ("tmpRptBYORRoster"."AddressTypeID"="CAMS_RptStudentAddressList_View"."AddressTypeID")) INNER JOIN "CAMS_Enterprise"."dbo"."CAMS_RptRosterViewwSSNBD" "CAMS_RptRosterViewwSSNBD" ON ("tmpRptBYORRoster"."StudentUID"="CAMS_RptRosterViewwSSNBD"."StudentUID") AND ("tmpRptBYORRoster"."SRAcademicID"="CAMS_RptRosterViewwSSNBD"."SRAcademicID")) INNER JOIN "CAMS_Enterprise"."dbo"."CAMS_RptSROfferType1000_View" "CAMS_RptSROfferType1000_View" ON "tmpRptBYORRoster"."SROfferID"="CAMS_RptSROfferType1000_View"."SROfferID"
 WHERE  "tmpRptBYORRoster"."ReportKey"=298463 AND "CAMS_RptSROfferType1000_View"."SemesterID"=612
 and "CAMS_RptRosterViewwSSNBD"."CourseName" like 'practical nursing%'
) tmptbl
 */
 
 select studentid, StudentSSN,BirthDate, LastName,FirstName,MiddleInitial from dbo.Student where StudentID in (
 'A0000017532',	
'A0000022805',	
'A0000021867',	
'A0000021777',	
'A0000022344',	
'A0000023152',	
'C0000066872',	
'A0000019244',	
'A0000021354',	
'A0000019148',	
'A0000018784',	
'A0000022274',	
'A0000021621',	
'A0000022889',	
'A0000021087',	
'A0000020608',	
'A0000013520')
