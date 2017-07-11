--select * from student where LastName='allen' and FirstName='tyme'

select * from SRAcademic where StudentUID=111818
--and TermCalendarID=616


--select grade from SRAcademic 
--where 
--StudentUID=111818
--and Department='NU'
--and CourseID='110'
--and TermCalendarID=614

--select dbo.getStudentLetterGradeByClass('111818','NU','110','614')

--select top 10 * from TermCalendar
--where Term <= dbo.getTermOrdSeq(614)
----and ActiveFlag=1
----and TextTerm not like 'bsn'
-- order by Term desc
 
 
 --DECLARE @name1 int
DECLARE @name1 varchar(200)


--DECLARE db_cursor CURSOR FOR  
--				select top 10 TextTerm from TermCalendar
--					where Term <= dbo.getTermOrdSeq(614)
--					--and ActiveFlag=1
--					--and TextTerm not like 'bsn'
--					 order by Term desc
				
--				OPEN db_cursor   
--				FETCH NEXT FROM db_cursor INTO @name1

--				WHILE @@FETCH_STATUS = 0   
--				BEGIN   
		         
--		         select dbo.getStudentLetterGradeByClass('111818','NU','110',dbo.gettermid(@name1))
				
		        
--					   FETCH NEXT FROM db_cursor INTO  @name1
--				END   

--			CLOSE db_cursor   
--			DEALLOCATE db_cursor


select 
'SP-17' as STerm,
'111818' as Studentuid,
dbo.getStudentLetterGradeByClass('111818','NU','110','614') as NU110,
dbo.getStudentLetterGradeByClass('111818','NU','112','614') as NU112,
dbo.getStudentLetterGradeByClass('111818','NU','114','614') as NU114,
dbo.getStudentLetterGradeByClass('111818','NU','116','614') as NU116,
dbo.getStudentLetterGradeByClass('111818','NU','115','614') as NU115,
dbo.getStudentLetterGradeByClass('111818','NU','124','614') as NU124,
dbo.getStudentLetterGradeByClass('111818','NU','122','614') as NU122,
dbo.getStudentLetterGradeByClass('111818','NU','214','614') as NU214,
dbo.getStudentLetterGradeByClass('111818','NU','217','614') as NU217,
dbo.getStudentNursingLevel('111818') as NursingLevel