
USE CAMS_Enterprise
					
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
			
			DECLARE db_cursor5 CURSOR FOR  
			
			SELECT DISTINCt 
				CAMS_rptSrofferType1000_View.SemesterID,
				CAMS_rptSrofferType1000_View.FacultyID, 
				SROffer.CourseID,
				SROffer.Section
			FROM  dbo.SROffer AS SROffer INNER JOIN
				dbo.CAMS_RptSROfferType1000_View AS CAMS_rptSrofferType1000_View ON SROffer.SROfferID = CAMS_rptSrofferType1000_View.SROfferID AND 
				SROffer.TermCalendarID = CAMS_rptSrofferType1000_View.SemesterID INNER JOIN
				dbo.CrsEvalQuestions AS CrsEvalQuestions INNER JOIN
				dbo.CrsEvalResponse AS CrsEvalResponse ON CrsEvalQuestions.QuestionID = CrsEvalResponse.QuestionID ON 
				SROffer.SROfferID = CrsEvalResponse.SrofferID LEFT OUTER JOIN
				dbo.CAMS_RptCourseEvalMCResponse_View AS CAMS_RptCourseEvalMCResponse_View ON 
				CrsEvalResponse.QuestionID = CAMS_RptCourseEvalMCResponse_View.QuestionID AND 
				CrsEvalResponse.SrofferID = CAMS_RptCourseEvalMCResponse_View.SROfferID
			WHERE (CAMS_rptSrofferType1000_View.SemesterID = 612) 
		    order by SROffer.courseID
			
			OPEN db_cursor5   
			FETCH NEXT FROM db_cursor5 INTO @name1 , @name2 , @name3, @name4

			WHILE @@FETCH_STATUS = 0   
			BEGIN   
				   exec dbo.COM_GetCourseEvaluationQuestionCounts @name1,@name2,@name3,@name4
			       
				   FETCH NEXT FROM db_cursor5 INTO  @name1 , @name2, @name3, @name4
			END   

			CLOSE db_cursor5   
			DEALLOCATE db_cursor5



