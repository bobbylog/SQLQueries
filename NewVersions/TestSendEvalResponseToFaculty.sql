drop table #HeaderEval
Drop Table #TmpEval
--drop Table #TmpH
--drop Table TmpH2
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

--drop table #HeaderEval
--Drop Table #TmpEval
--Drop Table TmpH

DECLARE @FacID varchar(50)
DECLARE @Tm varchar(50)
DECLARE @CoID varchar(50)
DECLARE @CoSc varchar(50)

DECLARE @FacLName varchar(50)
DECLARE @FacFName varchar(50)
DECLARE @CoIDLab varchar(50)
DECLARE @CoName varchar(50)
DECLARE @CoSecName varchar(50)

set @Tm ='612'
set @FacID='97468'
set @CoID ='102'
set @CoSc='02'

SELECT TOP 
(100) PERCENT CAMS_rptSrofferType1000_View.SemesterID, SROffer.Section, SROffer.CourseID, CrsEvalQuestions.QuestionText, 
               CrsEvalQuestions.QuestionID, CAMS_rptSrofferType1000_View.FacultyLastName, CAMS_rptSrofferType1000_View.FacultyFirstName, 
               CAMS_rptSrofferType1000_View.FacultyMiddleName, CAMS_RptCourseEvalMCResponse_View.ResponseOrder, 
               CAMS_RptCourseEvalMCResponse_View.MCResp, CAMS_RptCourseEvalMCResponse_View.ResponseCnt, cast (CrsEvalResponse.NarrAnswer as nvarchar) as NarrAns, CrsEvalQuestions.IsNarr
into #TmpEval
FROM  dbo.SROffer AS SROffer INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_rptSrofferType1000_View ON SROffer.SROfferID = CAMS_rptSrofferType1000_View.SROfferID AND 
               SROffer.TermCalendarID = CAMS_rptSrofferType1000_View.SemesterID INNER JOIN
               dbo.CrsEvalQuestions AS CrsEvalQuestions INNER JOIN
               dbo.CrsEvalResponse AS CrsEvalResponse ON CrsEvalQuestions.QuestionID = CrsEvalResponse.QuestionID ON 
               SROffer.SROfferID = CrsEvalResponse.SrofferID LEFT OUTER JOIN
               dbo.CAMS_RptCourseEvalMCResponse_View AS CAMS_RptCourseEvalMCResponse_View ON 
               CrsEvalResponse.QuestionID = CAMS_RptCourseEvalMCResponse_View.QuestionID AND 
               CrsEvalResponse.SrofferID = CAMS_RptCourseEvalMCResponse_View.SROfferID
WHERE (CAMS_rptSrofferType1000_View.SemesterID = @Tm)  
               AND (SROffer.CourseID = @CoID) AND (SROffer.Section = @CoSc)
                AND (CAMS_rptSrofferType1000_View.FacultyId = @FacID)
GROUP BY CAMS_rptSrofferType1000_View.SemesterID, CrsEvalQuestions.QuestionID, CrsEvalQuestions.QuestionText, 
               CAMS_rptSrofferType1000_View.FacultyLastName, CAMS_rptSrofferType1000_View.FacultyFirstName, CAMS_rptSrofferType1000_View.FacultyMiddleName, 
               CAMS_RptCourseEvalMCResponse_View.ResponseOrder, CAMS_RptCourseEvalMCResponse_View.MCResp, 
               CAMS_RptCourseEvalMCResponse_View.ResponseCnt, SROffer.CourseID, SROffer.Section
               , CrsEvalQuestions.IsNarr, cast (CrsEvalResponse.NarrAnswer as nvarchar)
 ORDER BY CrsEvalQuestions.QuestionID, CAMS_RptCourseEvalMCResponse_View.ResponseOrder

-----------------------

SELECT  distinct @CoSecName=SROffer.Section, @CoIDLab=SROffer.CourseID,
               @FacLName=CAMS_rptSrofferType1000_View.FacultyLastName, @FacFName=CAMS_rptSrofferType1000_View.FacultyFirstName, 
				@CoName=Sroffer.Coursename
FROM  dbo.SROffer AS SROffer INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_rptSrofferType1000_View ON SROffer.SROfferID = CAMS_rptSrofferType1000_View.SROfferID AND 
               SROffer.TermCalendarID = CAMS_rptSrofferType1000_View.SemesterID INNER JOIN
               dbo.CrsEvalQuestions AS CrsEvalQuestions INNER JOIN
               dbo.CrsEvalResponse AS CrsEvalResponse ON CrsEvalQuestions.QuestionID = CrsEvalResponse.QuestionID ON 
               SROffer.SROfferID = CrsEvalResponse.SrofferID LEFT OUTER JOIN
               dbo.CAMS_RptCourseEvalMCResponse_View AS CAMS_RptCourseEvalMCResponse_View ON 
               CrsEvalResponse.QuestionID = CAMS_RptCourseEvalMCResponse_View.QuestionID AND 
               CrsEvalResponse.SrofferID = CAMS_RptCourseEvalMCResponse_View.SROfferID
WHERE (CAMS_rptSrofferType1000_View.SemesterID = @Tm)  
               -- AND (CAMS_rptSrofferType1000_View.FacultyLastName = 'Mang') AND 
               -- (CAMS_rptSrofferType1000_View.FacultyFirstName = 'Sharon') 
               AND (SROffer.CourseID = @CoID) AND (SROffer.Section = @CoSc)
                AND (CAMS_rptSrofferType1000_View.FacultyId = @FacID)


--------------------------


create table #HeaderEval(
    IDQ varchar(25),
    TypeQ varchar(2),
    Question varchar(300),
    vCount varchar(25)
)

select * from #TmpEval


					DECLARE @name1 varchar(25)
					DECLARE @name2 varchar(300)
					DECLARE @name3 varchar(25)
					DECLARE @name4 varchar(300)
					DECLARE @name5 varchar(25)
					DECLARE @name6 varchar(25)
					DECLARE @name7 varchar(25)
					DECLARE @name8 datetime
					DECLARE @i int
				    DECLARE @k int
					DECLARE @j varchar(25)

					
								set @i=1
								set @j=CAST(@i as varchar)
								
								DECLARE db_cursor CURSOR FOR  
								 select distinct QuestionID, QuestionText, IsNarr
								 --,MCResp, ResponseCnt,SemesterID   
								 from #TmpEval
								

								OPEN db_cursor   
								FETCH NEXT FROM db_cursor INTO @name1 , @name2 , @name3 --, @name4, @name5

								WHILE @@FETCH_STATUS = 0   
								BEGIN   
									   insert into #HeaderEval(IDQ,TypeQ,Question, vCount)
									   values(@j,'H', @name2,'')
									   --set @k=@k+1
									   if (@name3='No')
									   begin
										   insert into #HeaderEval(IDQ,TypeQ,Question, vCount)
										   select @j,'I', MCResp,ResponseCnt from #TmpEval where QuestionID=@name1  
									   end 
									   else
									   begin
										   insert into #HeaderEval(IDQ,TypeQ,Question, vCount)
										   select @j,'I', NarrAns,ResponseCnt from #TmpEval where QuestionID=@name1 
									   end
									  -- set @k=@k+1
									   insert into #HeaderEval(IDQ,TypeQ,Question, vCount)
									   select @j,'T','Total' , sum(ResponseCnt) from #TmpEval where QuestionID=@name1  
									   --set @k=@k+1
									   insert into #HeaderEval(IDQ,TypeQ,Question, vCount)
									   values('','','','')
									   --set @k=@k+1
										
								       set @i=@i+1
								       set @j=CAST(@i as varchar)
								       
									   FETCH NEXT FROM db_cursor INTO  @name1 , @name2 , @name3 --, @name4, @name5
								END   

								CLOSE db_cursor   
								DEALLOCATE db_cursor

select  row_number() OVER (ORDER BY (SELECT 0)) as ItemOrd, IDQ,TYpeQ, Question, vCount  into #TmpH from #HeaderEval

select * from #TmpH

--							DECLARE @tbody varchar(Max)
--							DECLARE @itemQ varchar(Max)
							
--							set @tbody=''
--							set @itemQ=''

--							DECLARE db_cursor1 CURSOR FOR  
--								 select ItemOrd, IDQ,TYpeQ, Question, vCount
--								 --,MCResp, ResponseCnt,SemesterID   
--								 from TmpH order by ItemOrd asc
								

--								OPEN db_cursor1   
--								FETCH NEXT FROM db_cursor1 INTO @name1 , @name2 , @name3, @name4, @name5

--								WHILE @@FETCH_STATUS = 0   
--								BEGIN   
--									if (@name3='H')
--									begin
--										--set @itemQ='<p><b>'+@name4+'</b><br/>'
--										set @itemQ='<tr><td><b>'+ISNULL(@name2,'')+'. '+ISNULL(@name4,'NA')+'</b></td></tr>'
--									end
--									else if(@name3='T')
--									begin
--										--set @itemQ='<b>'+@name4+'	'+@name5+'</b></p>'
--										set @itemQ='<tr style="background-color:#B0C4DE;border:1px solid black;"><td><b>'+ISNULL(@name4,'NA')+'		'+ISNULL(@name5,'0')+'</b></td></tr>'
--									end
--									else
--									begin
--										set @itemQ='<tr><td>'+ISNULL(@name4,'No Response')+'	'+ISNULL(@name5,'0')+'</td></t r>'
--									end
									
									
--									set @tbody=@tbody+@itemQ
									   
									
--									   FETCH NEXT FROM db_cursor1 INTO  @name1 , @name2 , @name3, @name4, @name5

--								END   

--								CLOSE db_cursor1   
--								DEALLOCATE db_cursor1
								
--								DECLARE @HeadSt varchar(max)
								
--								set @HeadSt='<html><head></head><body><table align="center" style="border:1px solid black;">'
--								set @HeadSt=@HeadSt+'<tr style=""> <td>'+'Faculty: <b>'+@FacFName+', '+@FacLName +'</b><br/>'+'Term: <b>'+dbo.getTermText(@Tm)+'</b>'
--								set @HeadSt=@HeadSt+'<br/>'+'Course: <b>'+@CoIDLab+' | Section: '+@CoSc+'</b><br/>'+'Course Name: <b>'+@CoName + '</b><br/></td> </tr>'
--								set @HeadSt=@HeadSt+'<tr style="background-color:#BDB76B;color:#ffffff;"> <th>'+@CoName+' Evaluation Responses</th> </tr>'
--								set @tbody=@HeadSt+@tbody+'</table></body></html>'

--print @tbody

----SELECT *,'ok' as tm FROM cams_enterprise.tempdb.#tmpH



---- Exporting Main AdImport File
		
--DECLARE @cmdstr nvarchar(max)
--DECLARE @tmstp varchar(15)
--DECLARE @globalcmdstr varchar(1000)
--DECLARE @cterm varchar(15)
--DECLARE @filename1 nvarchar(300)
--DECLARE @topic varchar(200)
--DECLARE @EmailFac varchar(100)

--select IDQ,'"'+Question+'"' as Questions,vCount 
----select @tbody as BodyQ
--into TmpH2 
--from TmpH

--select *  from TmpH2



--set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; select IDQ,Questions,vCount from cams_enterprise.dbo.TmpH2"  > D:\CAMSEnterprise\AdImports\'+dbo.getTermText(@Tm)+'_'+replace(replace(@FacLName,' ','_'),'''','')+'_'+replace(replace(@FacFName,' ','_'),'''','')+'_'+@CoIDLab+'_'+@CoSecName
----set @cmdstr= 'SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; select * from cams_enterprise.dbo.TmpH2"  > D:\CAMSEnterprise\AdImports\Ev'
--set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
--set @globalcmdstr = @cmdstr+'.csv'
----set @globalcmdstr = 'echo '+@tbody+' > Ev'+'_'+@tmstp+'.html'
--set @filename1='D:\CAMSEnterprise\AdImports\'+dbo.getTermText(@Tm)+'_'+replace(replace(@FacLName,' ','_'),'''','')+'_'+replace(replace(@FacFName,' ','_'),'''','')+'_'+@CoIDLab+'_'+@CoSecName+'.csv'
--EXEC  master..xp_cmdshell @globalcmdstr



--set @topic='Evaluation Responses Report: '+@CoIDLab+' | '+@CoSecName+'-'+@CoName+'('+dbo.getTermText(@Tm)+')'
--set @EmailFac=dbo.getFacultyEmailAddressFromID (@FacId)

---- Send an email
--EXEC msdb.dbo.sp_send_dbmail 
--@profile_name='TROCMAIL',
----@recipients = @EmailFac, 
--@recipients = 'etiennes@trocaire.edu', 
--@file_attachments =@filename1,
---- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
--@subject = @topic ,
--@body = @tbody,
--@body_format = 'HTML' ; 

drop table #HeaderEval
Drop Table #TmpEval
--drop Table #TmpH
--drop Table TmpH2

