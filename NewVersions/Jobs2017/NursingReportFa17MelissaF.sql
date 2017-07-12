--select * from student where LastName='allen' and FirstName='tyme'

select * from SRAcademic where StudentUID=116383
--and TermCalendarID=616


--select grade from SRAcademic 
--where 
--StudentUID=116383
--and Department='NU'
--and CourseID='110'
--and TermCalendarID=614

--select dbo.getStudentLetterGradeByClass('116383','NU','110','614')

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
		         
--		         select dbo.getStudentLetterGradeByClass('116383','NU','110',dbo.gettermid(@name1))
				
		        
--					   FETCH NEXT FROM db_cursor INTO  @name1
--				END   

--			CLOSE db_cursor   
--			DEALLOCATE db_cursor

SELECT top 10
  ROW_NUMBER() OVER(ORDER BY Term DESC) AS ID,
  TermCalendarID, Term, TextTerm
  into #TmpCal
  FROM TermCalendar 
  where Term <=dbo.getTermOrdSeQ(614)
  AND TextTerm not like '%-BSN-%'
  
select 
'SP-17' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','614') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','614') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','614') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','614') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','614') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','614') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','614') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','614') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','614') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel
union all
select 
'FA-16' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','612') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','612') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','612') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','612') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','612') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','612') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','612') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','612') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','612') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel
union all
select 
'SU-16' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','610') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','610') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','610') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','610') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','610') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','610') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','610') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','610') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','610') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel
union all
select 
'SP-16' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','608') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','608') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','608') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','608') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','608') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','608') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','608') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','608') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','608') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel
union all
select 
'FA-15' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','604') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','604') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','604') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','604') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','604') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','604') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','604') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','604') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','604') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel
union all
select 
'SU-15' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','603') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','603') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','603') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','603') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','603') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','603') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','603') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','603') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','603') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel
union all
select 
'SP-15' as STerm,
'116383' as Studentuid,
dbo.getStudentLetterGradeByClass('116383','NU','110','602') as NU110,
dbo.getStudentLetterGradeByClass('116383','NU','112','602') as NU112,
dbo.getStudentLetterGradeByClass('116383','NU','114','602') as NU114,
dbo.getStudentLetterGradeByClass('116383','NU','116','602') as NU116,
dbo.getStudentLetterGradeByClass('116383','NU','115','602') as NU115,
dbo.getStudentLetterGradeByClass('116383','NU','124','602') as NU124,
dbo.getStudentLetterGradeByClass('116383','NU','122','602') as NU122,
dbo.getStudentLetterGradeByClass('116383','NU','214','602') as NU214,
dbo.getStudentLetterGradeByClass('116383','NU','217','602') as NU217,
dbo.getStudentNursingLevel('116383') as NursingLevel