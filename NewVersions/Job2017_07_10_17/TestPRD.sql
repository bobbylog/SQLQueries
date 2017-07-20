USE [msdb]
GO

/****** Object:  Job [TestPRD]    Script Date: 07/20/2017 15:51:35 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 07/20/2017 15:51:35 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'TestPRD', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'trocaire\DuewigerP', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step1 Select]    Script Date: 07/20/2017 15:51:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step1 Select', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SELECT DISTINCT TC1.TextTerm, TC1.Term, 
       ST1.StudentUID, ST1.StudentID, ST1.LastName, ST1.FirstName,
       MM1.MajorMinorName, MM1.MajorMinorID, MM1.DegreeNameID,
       SP1.StudentProgramID, SP1.SequenceNo, SP1.PriProgID, SP1.NSLCClass,
       case
           when MM1.DegreeNameID IN (2049, 2050, 2051, 2052, 2053, 2054, 2055) then 3176 /*Associates*/
           when MM1.DegreeNameID IN (2056, 2057,2058) then 3178 /*Certificate*/
           when MM1.DegreeNameID IN (3037) then 3177 /*Bachelors*/
           when MM1.DegreeNameID IN (0) then 3179 /*Unspecified Undergrad*/
           else 0 
       end AS CalcNSLCClass,     
       case
           when SP1.SequenceNo = 0 then 1
           when SP1.SequenceNo = 1 then 0
           else 2
       end AS CalcPriProgID 
INTO #GetStudents
FROM CAMS_Enterprise_Test.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise_Test.dbo.TermCalendar TC1
       ON (SR1.TermCalendarID = TC1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise_Test.dbo.Glossary GL1
       ON (SR1.CategoryID = GL1.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise_Test.dbo.Student ST1
       ON (SR1.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise_Test.dbo.StudentStatus SS1
       ON ((SR1.StudentUID = SS1.StudentUID) AND 
           (SR1.TermCalendarID = SS1.TermCalendarID))
LEFT OUTER JOIN CAMS_Enterprise_Test.dbo.StudentProgram SP1
       ON (SS1.StudentStatusID = SP1.StudentStatusID)
LEFT OUTER JOIN CAMS_Enterprise_Test.dbo.MajorMinor MM1
       ON (SP1.MajorProgramID = MM1.MajorMinorID)
WHERE TC1.TextTerm IN (''FA-10'') AND
      GL1.DisplayText = ''Curriculum'' AND
      NOT ST1.LastName = ''Testperson''/*AND
     * NOT (MM1.MajorMinorName IS NULL)*/
ORDER BY ST1.StudentID

SELECT *
INTO #CStudents 
FROM #GetStudents
WHERE NOT ((PriProgID = CalcPriProgID) AND (NSLCClass = CalcNSLCClass)) AND LastName LIKE ''Nor%''
ORDER BY Term
/*
SELECT *
FROM CAMS_Enterprise_Test.dbo.StudentProgram 
WHERE EXISTS (SELECT #CStudents.* 
              FROM #CStudents 
              WHERE #CStudents.StudentProgramID = CAMS_Enterprise_Test.dbo.StudentProgram.StudentProgramID)
*/              

UPDATE CAMS_Enterprise_Test.dbo.StudentProgram
SET CAMS_Enterprise_Test.dbo.StudentProgram.PriProgID = (SELECT #CStudents.CalcPriProgID 
                                                         FROM #CStudents 
                                                         WHERE #CStudents.StudentProgramID = CAMS_Enterprise_Test.dbo.StudentProgram.StudentProgramID),
CAMS_Enterprise_Test.dbo.StudentProgram.NSLCClass = (SELECT #CStudents.CalcNSLCClass
                                                         FROM #CStudents 
                                                         WHERE #CStudents.StudentProgramID = CAMS_Enterprise_Test.dbo.StudentProgram.StudentProgramID)                                                          
WHERE EXISTS (SELECT #CStudents.* 
              FROM #CStudents 
              WHERE #CStudents.StudentProgramID = CAMS_Enterprise_Test.dbo.StudentProgram.StudentProgramID)
             
/*              
SELECT *
FROM CAMS_Enterprise_Test.dbo.StudentProgram 
WHERE EXISTS (SELECT #CStudents.* 
              FROM #CStudents 
              WHERE #CStudents.StudentProgramID = CAMS_Enterprise_Test.dbo.StudentProgram.StudentProgramID)              
*/
DROP TABLE #GetStudents
DROP TABLE #CStudents', 
		@database_name=N'CAMS_Enterprise_Test', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


