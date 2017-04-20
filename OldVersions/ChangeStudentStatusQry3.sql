declare @CTerm varchar(12)
declare @NTerm varchar(12)
declare @Tday datetime
declare @t int

set @CTerm=dbo.getCurrentTerm()
set @NTerm=dbo.getNextCurrentTerm()
set @Tday=GETDATE()
set @t=dbo.getTermID(@CTerm)



IF CHARINDEX('SU', @CTerm) >0 
BEGIN
-- Current Term

SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
INTO #TBCurActive
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @CTerm)and dbo.StudentStatus.StudentUID in
(
SELECT DISTINCT 
               CAMS_RptStudentAddressList_View.StudentUID
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster INNER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
               dbo.Student ON tmpRptBYORRoster.StudentUID = dbo.Student.StudentUID
WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@CTerm))
) 

-- Next Term
SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
INTO #TBNextActive
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @NTerm)and dbo.StudentStatus.StudentUID in
(
SELECT DISTINCT 
               CAMS_RptStudentAddressList_View.StudentUID
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster INNER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
               dbo.Student ON tmpRptBYORRoster.StudentUID = dbo.Student.StudentUID
WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@NTerm))
)

-- Display result
	-- delete from dbo.tmpStudentStatHistory
	INSERT INTO dbo.tmpStudentStatHistory
	select *, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
	-- INTO dbo.tmpStudentStatHistory
	from #TBNextActive where StudentUID in (
	select distinct StudentUID from #TBCurActive)
	  AND EnrollmentStatusID <>2 -- Continuing
	  AND EnrollmentStatusID <>27 -- Transfer
	 -- AND EnrollmentStatusID <>1 -- Alumni
	  AND Status NOT LIKE '%Freshman%'
  
   UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
	AND EnrollmentStatusID <> 2 
 	
 	EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='TROCMAIL',
		@recipients = 'etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu', 
		@query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
		@subject = 'Student Status Change Report',
		@body = 'IDs of Students whose Status have changed to CONTINUING today:' ;  
  
  drop table #TBCurActive
  drop table #TBNextActive
  
  END
 ELSE
 BEGIN
		 
		SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
		INTO #TBCurActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
		WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @CTerm)and dbo.StudentStatus.StudentUID in
		(
		SELECT DISTINCT 
					   CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster INNER JOIN
					   dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
					   tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
					   tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
					   dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
					   tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
					   dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
					   tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
					   dbo.Student ON tmpRptBYORRoster.StudentUID = dbo.Student.StudentUID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@CTerm))
		) 

		-- Next Term
		SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
		INTO #TBNextActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
		WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @NTerm)and dbo.StudentStatus.StudentUID in
		(
		SELECT DISTINCT 
					   CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster INNER JOIN
					   dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
					   tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
					   tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
					   dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
					   tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
					   dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
					   tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
					   dbo.Student ON tmpRptBYORRoster.StudentUID = dbo.Student.StudentUID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@NTerm))
		)

		-- Display result
			-- delete from dbo.tmpStudentStatHistory
			INSERT INTO dbo.tmpStudentStatHistory
			select *, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
			-- INTO dbo.tmpStudentStatHistory
			from #TBNextActive1 where StudentUID in (
			select distinct StudentUID from #TBCurActive1)
			  AND EnrollmentStatusID <>2 -- Continuing
			  AND EnrollmentStatusID <>27 -- Transfer
			  -- AND EnrollmentStatusID <>1 -- Alumni
			  -- AND Status NOT LIKE '%Freshman%'
		  
		   UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
		   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
			AND EnrollmentStatusID <> 2 
		 	
		 	EXEC msdb.dbo.sp_send_dbmail 
				@profile_name='TROCMAIL',
				@recipients = 'etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu', 
				@query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
				@subject = 'Student Status Change Report',
				@body = 'IDs of Students whose Status have changed to CONTINUING this week:' ;  
		  
		  drop table #TBCurActive1
		  drop table #TBNextActive1
  
  END
  
  
  
  

  
