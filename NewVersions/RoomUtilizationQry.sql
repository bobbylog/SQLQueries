DROP TABLE #PrintSROfferRoomUtilization
Drop table #Offering

SELECT DISTINCT B.OfferRoomID INTO #PrintSROfferRoomUtilization FROM SROfferSchedule B INNER JOIN SROffer A ON A.SROfferID = B.SROfferID WHERE (A.TermCalendarID = 616) AND (A.CampusID = 0)

SELECT DISTINCT B.SrofferID INTO #Offering FROM SROfferSchedule B INNER JOIN SROffer A ON A.SROfferID = B.SROfferID WHERE (A.TermCalendarID = 616) AND (A.CampusID = 0)

--Select TextTerm, TermStartDate, TermEndDate From TermCalendar Where TermCalendarID = 616

--Drop Table #TmpRooms


Select Distinct A.RoomScheduleID, ss.SROfferID
Into #TmpRooms 
From RoomSchedules A  Inner join SrofferSchedule ss 
on ss.SrofferScheduleID = A.HeaderID And HeaderTable = 'SROfferSchedule' 
Inner Join #PrintSROfferRoomUtilization B On B.OfferRoomID = A.RoomID  
Where A.[Date] >= '10/03/2017' And A.[Date] <= '10/06/2017' And A.TimeFrom >= '1899-12-30 8:00:00 AM' And A.TimeTo <= '1899-12-30 5:00:00 PM' 
And SS.SrofferID in (select srofferID from #Offering) 
Union  
Select Distinct A.RoomScheduleID  ,s.SROfferID
From RoomSchedules A  
Inner join Sroffer s on s.SrofferID = A.HeaderID And HeaderTable = 'SROFFER' 
Inner Join #PrintSROfferRoomUtilization B On B.OfferRoomID = A.RoomID  
Where A.[Date] >= '10/03/2017' And A.[Date] <= '10/06/2017' And A.TimeFrom >= '1899-12-30 8:00:00 AM' And A.TimeTo <= '1899-12-30 5:00:00 PM' And 
S.SrofferID in (select srofferID from #Offering)

SELECT DISTINCT b.SROfferID,Room,ScheduledActivity,Faculty,DayOfWeek,ActivityDateFrom,ActivityDateTo,TimeFrom,TimeTo,OfferDays,
               [Day],HeaderTable,HeaderID , isnull([dbo].[getAttendanceCountsPerDay](616, b.SROfferID,DayOfWeek),0) as ACounts
FROM CAMS_PrintSROfferRoomUtilization_View A INNER JOIN #TmpRooms B On B.RoomScheduleID = A.RoomScheduleID
where
Faculty like '%Cole%'
-- ScheduledActivity like '%health res%'
--Room='MAIN-027'


--SET FMTONLY ON SELECT DISTINCT Room,ScheduledActivity,Faculty,DayOfWeek,ActivityDateFrom,ActivityDateTo,TimeFrom,TimeTo,OfferDays,[Day],HeaderTable,HeaderID FROM CAMS_PrintSROfferRoomUtilization_View A INNER JOIN #TmpRooms B On B.RoomScheduleID = A.RoomScheduleID WHERE 1=2  SET FMTONLY OFF
--SET FMTONLY ON SELECT DISTINCT Room,ScheduledActivity,Faculty,DayOfWeek,ActivityDateFrom,ActivityDateTo,TimeFrom,TimeTo,OfferDays,[Day],HeaderTable,HeaderID FROM CAMS_PrintSROfferRoomUtilization_View A INNER JOIN #TmpRooms B On B.RoomScheduleID = A.RoomScheduleID WHERE 1=2  SET FMTONLY OFF
--SET NO_BROWSETABLE OFF

Drop Table #TmpRoomsTCCAMSMGR
Drop Table #PrintSROfferRoomUtilization
Drop table #Offering
Drop Table #TmpRooms