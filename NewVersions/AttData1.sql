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


	select A.DName, avg(A.AttNum) as Average from
				(
				select DName,count(Status) as AttNum from @AttData
					--where Status='Present'
					Group by datt, DName
					) A
					Group By A.DName

		 --WHere A.Datt=@dat and A.DName=@dn

	--select * from @AttData