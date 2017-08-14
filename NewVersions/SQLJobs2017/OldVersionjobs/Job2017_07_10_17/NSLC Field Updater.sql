USE [msdb]
GO

/****** Object:  Job [NSLC Field Updater]    Script Date: 07/20/2017 15:46:29 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07/20/2017 15:46:29 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'NSLC Field Updater', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Updates the NSLCClass and PriProgID fields in the StudentProgram Table.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'trocaire\DuewigerP', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Update NSLC Fields]    Script Date: 07/20/2017 15:46:29 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Update NSLC Fields', 
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
FROM CAMS_Enterprise.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
       ON (SR1.TermCalendarID = TC1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
       ON (SR1.CategoryID = GL1.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
       ON (SR1.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentStatus SS1
       ON ((SR1.StudentUID = SS1.StudentUID) AND 
           (SR1.TermCalendarID = SS1.TermCalendarID))
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentProgram SP1
       ON (SS1.StudentStatusID = SP1.StudentStatusID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.MajorMinor MM1
       ON (SP1.MajorProgramID = MM1.MajorMinorID)
WHERE TC1.Term > ''B13D'' AND
      GL1.DisplayText = ''Curriculum'' AND
      NOT ST1.LastName = ''Testperson''/*AND
     * NOT (MM1.MajorMinorName IS NULL)*/
ORDER BY ST1.StudentID

SELECT *
INTO #CStudents 
FROM #GetStudents
WHERE NOT ((PriProgID = CalcPriProgID) AND (NSLCClass = CalcNSLCClass))
ORDER BY Term

UPDATE CAMS_Enterprise.dbo.StudentProgram
SET CAMS_Enterprise.dbo.StudentProgram.PriProgID = (SELECT #CStudents.CalcPriProgID 
                                                         FROM #CStudents 
                                                         WHERE #CStudents.StudentProgramID = CAMS_Enterprise.dbo.StudentProgram.StudentProgramID),
CAMS_Enterprise.dbo.StudentProgram.NSLCClass = (SELECT #CStudents.CalcNSLCClass
                                                         FROM #CStudents 
                                                         WHERE #CStudents.StudentProgramID = CAMS_Enterprise.dbo.StudentProgram.StudentProgramID)                                                          
WHERE EXISTS (SELECT #CStudents.* 
              FROM #CStudents 
              WHERE #CStudents.StudentProgramID = CAMS_Enterprise.dbo.StudentProgram.StudentProgramID)

DROP TABLE #GetStudents
DROP TABLE #CStudents', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'NSLC Field Update', 
		@enabled=0, 
		@freq_type=1, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130701, 
		@active_end_date=99991231, 
		@active_start_time=144224, 
		@active_end_time=235959, 
		@schedule_uid=N'51ac4a33-1457-4875-b16a-446406c7ed8e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


