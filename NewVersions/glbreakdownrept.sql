Drop Table #PrintSROfferRoomUtilization
Drop table #Offering
Drop Table #TmpRooms
Drop table #TmpSchedule


	DECLARE @tm varchar(25)
	DECLARE @Rm varchar(25)
	DECLARE @Sdt varchar(25)
	DECLARE @Edt varchar(25)
	DECLARE @Stim varchar(25)
	DECLARE @Etim varchar(25)

	
	set @tm='SP-18'
	set @rm='main-027'
	set @Sdt='01/02/2018'
	set @Edt='02/12/2018'
	set @Stim='04:00 pm'
	set @Etim='08:00 pm'

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
--	DROP TABLE #PrintSROfferRoomUtilization
--Drop table #Offering

set @tm=dbo.gettermID(@Tm)

SELECT DISTINCT B.OfferRoomID INTO #PrintSROfferRoomUtilization FROM SROfferSchedule B INNER JOIN SROffer A ON A.SROfferID = B.SROfferID WHERE (A.TermCalendarID = @Tm) AND (A.CampusID = 0)

SELECT DISTINCT B.SrofferID INTO #Offering FROM SROfferSchedule B INNER JOIN SROffer A ON A.SROfferID = B.SROfferID WHERE (A.TermCalendarID = @Tm) AND (A.CampusID = 0)

--Select TextTerm, TermStartDate, TermEndDate From TermCalendar Where TermCalendarID = @Tm

--Drop Table #TmpRooms


Select Distinct A.RoomScheduleID, ss.SROfferID
Into #TmpRooms 
From RoomSchedules A  Inner join SrofferSchedule ss 
on ss.SrofferScheduleID = A.HeaderID And HeaderTable = 'SROfferSchedule' 
Inner Join #PrintSROfferRoomUtilization B On B.OfferRoomID = A.RoomID  
Where A.[Date] >= @Sdt And A.[Date] <= @Edt And A.TimeFrom >= '1899-12-30 '+@Stim and A.TimeTo <= '1899-12-30 '+@Etim 
And SS.SrofferID in (select srofferID from #Offering) 
Union  
Select Distinct A.RoomScheduleID  ,s.SROfferID
From RoomSchedules A  
Inner join Sroffer s on s.SrofferID = A.HeaderID And HeaderTable = 'SROFFER' 
Inner Join #PrintSROfferRoomUtilization B On B.OfferRoomID = A.RoomID  
Where A.[Date] >= @Sdt And A.[Date] <= @Edt And A.TimeFrom >= '1899-12-30 '+@Stim And A.TimeTo <= '1899-12-30 '+@Etim And 
S.SrofferID in (select srofferID from #Offering)

SELECT DISTINCT b.SROfferID,Room,ScheduledActivity,Faculty,DayOfWeek,ActivityDateFrom,ActivityDateTo,TimeFrom,TimeTo,OfferDays,
               [Day],HeaderTable,HeaderID , isnull([dbo].[getAttendanceCountsPerDay](@Tm, b.SROfferID,DayOfWeek),0) as ACounts, '' as Conflict, dbo.getTermText(@Tm) as Term
into #TmpSchedule
FROM CAMS_PrintSROfferRoomUtilization_View A INNER JOIN #TmpRooms B On B.RoomScheduleID = A.RoomScheduleID

select Room, AVG(cast(Acounts as int)) as Average From #TmpSchedule
Group by Room
order by Room asc

--where room=@Rm

--SET FMTONLY ON SELECT DISTINCT Room,ScheduledActivity,Faculty,DayOfWeek,ActivityDateFrom,ActivityDateTo,TimeFrom,TimeTo,OfferDays,[Day],HeaderTable,HeaderID FROM CAMS_PrintSROfferRoomUtilization_View A INNER JOIN #TmpRooms B On B.RoomScheduleID = A.RoomScheduleID WHERE 1=2  SET FMTONLY OFF
--SET FMTONLY ON SELECT DISTINCT Room,ScheduledActivity,Faculty,DayOfWeek,ActivityDateFrom,ActivityDateTo,TimeFrom,TimeTo,OfferDays,[Day],HeaderTable,HeaderID FROM CAMS_PrintSROfferRoomUtilization_View A INNER JOIN #TmpRooms B On B.RoomScheduleID = A.RoomScheduleID WHERE 1=2  SET FMTONLY OFF
--SET NO_BROWSETABLE OFF

--Drop Table #TmpRoomsTCCAMSMGR
Drop Table #PrintSROfferRoomUtilization
Drop table #Offering
Drop Table #TmpRooms
Drop table #TmpSchedule


