			
--drop table #TmpNursingList
--drop table #TmpCal
--drop table #TmpNursePerTerm



SELECT top 10
  ROW_NUMBER() OVER(ORDER BY Term DESC) AS ID,
  TermCalendarID, Term, TextTerm
  into #TmpCal
  FROM TermCalendar 
  where Term <=dbo.getTermOrdSeQ(616)
  AND TextTerm not like '%-BSN-%'
  
  --select * from #TmpCal
  
  

  
  
  --------
  DECLARE @S1 varchar(25)
  DECLARE @S2 varchar(25)
  DECLARE @S3 varchar(25)
  DECLARE @S4 varchar(25)
  DECLARE @S5 varchar(25)
  DECLARE @S6 varchar(25)
   DECLARE @S7 varchar(25)
   DECLARE @Cpass int
   
  set @CPass=1
  set @S1=(select TermCalendarID from #TmpCal where ID=1)
  set @S2=(select TermCalendarID from #TmpCal where ID=2)
  set @S3=(select TermCalendarID from #TmpCal where ID=3)
  set @S4=(select TermCalendarID from #TmpCal where ID=4)
  set @S5=(select TermCalendarID from #TmpCal where ID=5)
  set @S6=(select TermCalendarID from #TmpCal where ID=6)
  set @S7=(select TermCalendarID from #TmpCal where ID=7)
  
  ----
  
  DECLARE @stuid varchar(25)
DECLARE @name2 varchar(200)


  SELECT DISTINCT 
               TOP (100) PERCENT
               TC1.TextTerm AS Term,
                ST1.StudentUID,
               ST1.StudentID, LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) 
               AS FirstName, ST1.MiddleInitial, MM1.MajorMinorName AS DegreeProgram, LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) 
               AS USERID, dbo.getStudentNursingLevel(St1.studentuid) as Level
               into #TmpNursePerTerm
					FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
								   dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
								   dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
								   dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
								   dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
								   dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
								   dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
					WHERE (TC1.TextTerm = 'FA-17') AND (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson'))
					AND MM1.MajorMinorName like '%Nursing%'
					ORDER BY St1.StudentUID
					 --LastName, FirstName

--select * from #TmpNursePerTerm
--where Level > 0
--order by Level asc


DECLARE db_cursor CURSOR FOR  
				select studentuid from #TmpNursePerTerm
				where Level > 0
				order by Level asc
					 
				OPEN db_cursor   
				FETCH NEXT FROM db_cursor INTO @stuid
				WHILE @@FETCH_STATUS = 0   
				BEGIN   
		              print @stuid
						IF (@CPass=1)
							begin
								select 
								dbo.getTermText(@S1) as STerm,
								@stuid as Studentuid,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S1) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S1) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S1) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S1) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S1) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S1) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S1) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S1) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S1) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S1) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S1) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S1) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S1) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S1) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S1) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S1) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S1) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S1) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S1) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S1) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S1) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S1) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								into #TmpNursingList
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S2) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S2) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S2) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S2) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S2) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S2) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S2) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S2) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S2) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S2) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S2) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S2) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S2) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S2) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S2) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S2) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S2) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S2) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S2) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S2) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S2) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S2) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S2) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S3) as STerm,
								@stuid as Studentuid,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S3) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S3) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S3) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S3) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S3) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S3) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S3) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S3) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S3) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S3) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S3) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S3) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S3) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S3) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S3) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S3) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S3) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S3) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S3) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S3) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S3) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S3) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S4) as STerm,
								@stuid as Studentuid,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S4) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S4) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S4) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S4) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S4) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S4) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S4) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S4) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S4) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S4) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S4) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S4) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S4) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S4) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S4) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S4) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S4) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S4) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S4) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S4) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S4) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S4) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S5) as STerm,
								@stuid as Studentuid,
							    dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S5) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S5) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S5) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S5) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S5) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S5) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S5) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S5) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S5) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S5) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S5) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S5) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S5) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S5) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S5) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S5) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S5) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S5) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S5) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S5) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S5) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S5) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S6) as STerm,
								@stuid as Studentuid,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S6) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S6) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S6) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S6) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S6) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S6) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S6) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S6) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S6) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S6) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S6) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S6) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S6) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S6) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S6) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S6) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S6) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S6) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S6) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S6) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S6) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S6) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S7) as STerm,
								@stuid as Studentuid,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S7) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S7) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S7) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S7) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S7) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S7) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S7) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S7) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S7) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S7) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S7) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S7) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S7) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S7) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S7) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S7) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S7) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S7) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S7) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S7) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S7) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S7) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
							
							end
							
							
							IF (@CPass > 1)
							begin
							    insert into #TmpNursingList
								select 
								dbo.getTermText(@S1) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S1) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S1) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S1) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S1) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S1) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S1) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S1) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S1) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S1) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S1) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S1) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S1) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S1) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S1) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S1) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S1) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S1) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S1) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S1) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S1) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S1) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S1) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S2) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S2) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S2) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S2) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S2) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S2) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S2) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S2) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S2) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S2) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S2) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S2) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S2) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S2) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S2) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S2) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S2) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S2) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S2) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S2) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S2) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S2) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S2) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S3) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S3) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S3) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S3) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S3) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S3) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S3) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S3) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S3) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S3) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S3) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S3) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S3) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S3) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S3) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S3) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S3) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S3) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S3) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S3) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S3) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S3) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S3) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S4) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S4) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S4) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S4) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S4) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S4) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S4) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S4) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S4) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S4) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S4) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S4) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S4) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S4) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S4) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S4) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S4) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S4) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S4) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S4) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S4) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S4) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S4) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S5) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S5) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S5) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S5) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S5) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S5) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S5) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S5) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S5) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S5) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S5) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S5) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S5) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S5) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S5) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S5) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S5) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S5) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S5) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S5) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S5) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S5) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S5) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S6) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S6) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S6) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S6) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S6) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S6) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S6) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S6) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S6) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S6) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S6) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S6) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S6) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S6) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S6) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S6) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S6) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S6) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S6) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S6) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S6) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S6) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S6) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
								
								--union all
								
								insert into #TmpNursingList
								select 
								dbo.getTermText(@S7) as STerm,
								@stuid as Studentuid,
									dbo.getStudentLetterGradeByClass(@stuid,'BIO','130',@S7) as BIO130,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','130','L', @S7) as BIO130L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','131',@S7) as BIO131,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','131','L', @S7) as BIO131L,
								dbo.getStudentLetterGradeByClass(@stuid,'BIO','223',@S7) as BIO223,
								dbo.getStudentLetterGradeByClassAndSection(@stuid,'BIO','223','L', @S7) as BIO223L,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','110',@S7) as NU110,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','112',@S7) as NU112,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','114',@S7) as NU114,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','116',@S7) as NU116,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','115',@S7) as NU115,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','124',@S7) as NU124,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','122',@S7) as NU122,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','214',@S7) as NU214,
								dbo.getStudentLetterGradeByClass(@stuid,'NU','217',@S7) as NU217,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','101',@S7) as PSY101,
								dbo.getStudentLetterGradeByClass(@stuid,'PSY','102',@S7) as PSY102,
								dbo.getStudentLetterGradeByClass(@stuid,'EN','102',@S7) as EN102,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','103',@S7) as PH103,
								dbo.getStudentLetterGradeByClass(@stuid,'PH','205',@S7) as PH205,
								dbo.getStudentLetterGradeByClass(@stuid,'SOC','101',@S7) as SOC101,
								dbo.getCurrentMajorFromUIDByTerm(@stuid, @S7) as DegreeProgram,
								dbo.getStudentNursingLevel(@stuid) as NursingLevel
							
							end
							
							set @Cpass=@Cpass+1
							
							--union all

					   FETCH NEXT FROM db_cursor INTO  @stuid
				END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor
			
			select dbo.getStudentFullName(dbo.getStudentIDFromUID(Studentuid)) as FullName,* from #TmpNursingList
			order by NursingLevel , studentuid asc
			
			--select distinct  studentuid from #TmpNursePerTerm
			--where StudentUID not in
			--(select distinct StudentUID from #TmpNursingList)
			
			
			
drop table #TmpNursingList
drop table #TmpCal
drop table #TmpNursePerTerm