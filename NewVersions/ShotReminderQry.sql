
drop table #TmpHealthPhys

select StudentUID, ExaminedDate as PhysicalDate , DATEADD(year,2,ExaminedDate) as ExpirationDate, 
DATEADD(month, -2, DATEADD(year,2,ExaminedDate)) as AlertDate1,
DATEADD(month, -1, DATEADD(year,2,ExaminedDate)) as AlertDate2
--DATEADD(month, -1, DATEADD(year,2,ExaminedDate)) as AlertDate2,
--TBTestDate1 as PPD1, TBTestDate2 as PPD2 , Meningitis 
--,dbo.getStudentCPRDate (studentuid) as CPR
--,dbo.getStudentHIPAADate(StudentUID) as HIPPATRNG
into #TmpHealthPhys
from CAMS_StudentHealth_view

select * from #TmpHealthPhys
where 
PhysicalDate >= GETDATE()


DECLARE @name1 varchar(25)
DECLARE @name2 datetime
DECLARE @name3 datetime
DECLARE @name4 datetime
DECLARE @name5 datetime



DECLARE @today date
set @today='03/15/2020'

DECLARE db_cursor CURSOR FOR  
				select Studentuid,PhysicalDate,ExpirationDate,AlertDate1,AlertDate2 from #TmpHealthPhys
				where PhysicalDate >= GETDATE()

				OPEN db_cursor   
				FETCH NEXT FROM db_cursor INTO @name1, @name2, @name3, @name4, @name5

				WHILE @@FETCH_STATUS = 0   
				BEGIN   
		         
		         -- Send an email
				--IF month(@name4)=month(getdate()) and day(@name4)=day(getdate()) and year(@name4)=year(getdate()) 
				
				IF month(@name4)=month(@today) and day(@name4)=day(@today) and year(@name4)=year(@today) 
				begin
					exec CTM_SendShotReminder @name1, @name2, @name3
                    IF NOT EXISTS(SELECT StudentUID from dbo.ShotReminderHistory where Studentuid=@name1)
						insert into dbo.ShotReminderHistory
						select @name1, @name2, @name3, @name4, @name5, 'Yes'
				end

				IF month(@name5)=month(@today) and day(@name5)=day(@today) and year(@name5)=year(@today) 
				begin
					exec CTM_SendShotReminder @name1, @name2, @name3
                    IF NOT EXISTS(SELECT StudentUID from dbo.ShotReminderHistory where Studentuid=@name1)
						insert into dbo.ShotReminderHistory
						select @name1, @name2, @name3, @name4, @name5, 'Yes'
				end
		        
					   FETCH NEXT FROM db_cursor INTO  @name1, @name2, @name3, @name4, @name5
				END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor


select * from dbo.ShotReminderHistory



drop table #TmpHealthPhys

