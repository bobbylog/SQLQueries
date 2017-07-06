--select top 4 FormID, * 

--from CTM_AccomodationReq
----where TestDate=DATEADD(day,2,getdate())

--select top 4 FormID from CTM_AccomodationReq

DECLARE @name1 int
DECLARE @name2 varchar(200)


DECLARE db_cursor CURSOR FOR  
				select top 4 FormID, EmailAddress from CTM_AccomodationReq
				where TestDate=DATEADD(day,2,getdate())
				
				OPEN db_cursor   
				FETCH NEXT FROM db_cursor INTO @name1, @name2

				WHILE @@FETCH_STATUS = 0   
				BEGIN   
		         
		         -- Send an email
				exec dbo.CTM_SendAccoReminder @name1, @name2
		        
					   FETCH NEXT FROM db_cursor INTO  @name1, @name2
				END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor
