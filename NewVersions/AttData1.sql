DECLARE @AttData TABLE
		(
		  Status varchar(25), 
		  DAtt int,
		  DName varchar(25)
		)
	
	insert into @AttData
	select Status , Day(SADate) dAtt, Datename(dw, SADate) as DName
	From CAMS_StudentAttendance_View
	where TermCalendarID=616
	and srofferid=101150 --100766
	--and SrofferScheduleID=15078

	select * from @AttData

	select A.DName, avg(A.AttNum) as Average from
				(
				select DName,count(Status) as AttNum from @AttData
					--where Status='Present'
					Group by datt, DName
					) A
					 WHere  A.DName='Friday'
					Group By A.DName

		
	--select * from @AttData