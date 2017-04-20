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
		-- List of Student Registered in Current Term
		SELECT  dbo.CAMS_StudentStatus_View.StudentStatusID, dbo.CAMS_StudentStatus_View.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID, dbo.CAMS_StudentStatus_View.TermCalendarID as CurrentTerm, 
		dbo.getStudentNextEnrolledTerm(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrTerm,
		dbo.getStudentNextEnrolledStatusID(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrStatusID
	    INTO #TBCurActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.CAMS_StudentStatus_View ON dbo.TermCalendar.TermCalendarID = dbo.CAMS_StudentStatus_View.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.CAMS_StudentStatus_View.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID  INNER JOIN
					   dbo.Student ON dbo.CAMS_StudentStatus_View.StudentUID = dbo.Student.StudentUID
		WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm =@CTerm)and dbo.CAMS_StudentStatus_View.StudentUID in
		(
				
		SELECT DISTINCT
					CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View INNER JOIN
               dbo.Student ON CAMS_RptStudentAddressList_View.StudentUID = dbo.Student.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = dbo.Student.StudentID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON CAMS_RptStudentAddressList_View.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = CAMS_RptRoster_View.StudentID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID AND 
               CAMS_RptRoster_View.TermCalendarID = CAMS_RptSROfferType1000_View.SemesterID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@CTerm))
		
		) 

		-- List of students who have enrollment in other term whose status is not continuing or transfer
		select * 
		into #TBCurActive2
		from #TBCurActive1 
		where 
		NEnrTerm <>0
		and EnrollmentStatusID<>2 
		--and EnrollmentStatusID<>27
		and EnrollmentStatusId <>3


		--select * from #TBCurActive2

		-- List of students status  enrolled in other term whose status is not continuing or transfer
		select StudentStatusID,StudentUID,StudentID, EnrollmentStatus as Status, EnrollmentStatusID, StudentLoad
		into #TBNextActive1
		from dbo.CAMS_StudentStatus_View
		where StudentLoad <>'' 
		and EnrollmentStatusID <>2 
		--and EnrollmentStatusId <>27 
		and EnrollmentStatusId <>3
		and Studentstatusid in 
		(select distinct NEnrStatusID from #TBCurActive2)

			--select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID from #TBNextActive1


			INSERT INTO dbo.tmpStudentStatHistory
						select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
						from #TBNextActive1 

			 UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
					   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
						AND EnrollmentStatusID <> 2 
					 	
		 	EXEC msdb.dbo.sp_send_dbmail 
				@profile_name='TROCMAIL',
				@recipients = 'etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu', 
				@query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
				@subject = 'Student Status Change Report',
				@body = 'IDs of Students whose Status have changed to CONTINUING this week:' ;  
		  

				drop table #TBNextActive1
				drop table #TBCurActive2
				drop table #TBCurActive1
  
  
 END
 ELSE
 BEGIN
		 
		-- List of Student Registered in Current Term
		SELECT  dbo.CAMS_StudentStatus_View.StudentStatusID, dbo.CAMS_StudentStatus_View.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID, dbo.CAMS_StudentStatus_View.TermCalendarID as CurrentTerm, 
		dbo.getStudentNextEnrolledTerm(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrTerm,
		dbo.getStudentNextEnrolledStatusID(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrStatusID
	    INTO #TBCurActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.CAMS_StudentStatus_View ON dbo.TermCalendar.TermCalendarID = dbo.CAMS_StudentStatus_View.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.CAMS_StudentStatus_View.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID  INNER JOIN
					   dbo.Student ON dbo.CAMS_StudentStatus_View.StudentUID = dbo.Student.StudentUID
		WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm =@CTerm)and dbo.CAMS_StudentStatus_View.StudentUID in
		(
				
		SELECT DISTINCT
					CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View INNER JOIN
               dbo.Student ON CAMS_RptStudentAddressList_View.StudentUID = dbo.Student.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = dbo.Student.StudentID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON CAMS_RptStudentAddressList_View.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = CAMS_RptRoster_View.StudentID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID AND 
               CAMS_RptRoster_View.TermCalendarID = CAMS_RptSROfferType1000_View.SemesterID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@CTerm))
		
		) 

		-- List of students who have enrollment in other term whose status is not continuing or transfer
		select * 
		into #TBCurActive2
		from #TBCurActive1 
		where 
		NEnrTerm <>0
		and EnrollmentStatusID<>2 
		--and EnrollmentStatusID<>27


		--select * from #TBCurActive2

		-- List of students status  enrolled in other term whose status is not continuing or transfer
		select StudentStatusID,StudentUID,StudentID, EnrollmentStatus as Status, EnrollmentStatusID, StudentLoad
		into #TBNextActive1
		from dbo.CAMS_StudentStatus_View
		where StudentLoad <>'' 
		and EnrollmentStatusID <>2 
		--and EnrollmentStatusId <>27 
		and Studentstatusid in 
		(select distinct NEnrStatusID from #TBCurActive2)

			--select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID from #TBNextActive1


			INSERT INTO dbo.tmpStudentStatHistory
						select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
						from #TBNextActive1 

			 UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
					   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
						AND EnrollmentStatusID <> 2 
					 	
		 	EXEC msdb.dbo.sp_send_dbmail 
				@profile_name='TROCMAIL',
				@recipients = 'etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu', 
				@query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
				@subject = 'Student Status Change Report',
				@body = 'IDs of Students whose Status have changed to CONTINUING this week:' ;  
		  

				drop table #TBNextActive1
				drop table #TBCurActive2
				drop table #TBCurActive1
  
  END
  
  
  
  

  
