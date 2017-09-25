
drop table #TmpCross2
drop table #tmptable

drop table #RosterBYOR

drop table #tempSracademic

Select Distinct A.SROfferID, A.SracademicID Into #RosterBYOR From SRAcademic A  Inner Join SROffer as B ON A.SROfferID = B.SROfferID Where (A.TermCalendarID = 616)  AND (B.CampusID = 3)AND (A.Grade Not IN ('W', 'WP', 'WF')) 
--Select Distinct A.SROfferID, A.SracademicID Into #RosterBYOR From SRAcademic A  Inner Join SROffer as B ON A.SROfferID = B.SROfferID Where (A.TermCalendarID = 616)  AND (B.CampusID = 3)AND (A.Grade Not IN ('W', 'WP', 'WF')) 

Select Distinct SROfferID Into #TmpCross2 From #RosterBYOR UNION  Select CrossListID as SROfferID From SROffer Where SROfferID IN  (Select Distinct SROfferID From #RosterBYOR) AND CrossListID > 0 UNION  Select SROfferID from SROffer Where CrossListID IN (  (Select Distinct SROfferID From #RosterBYOR) UNION   (Select CrossListID From SROffer Where SROfferID IN      (Select Distinct SROfferID From #RosterBYOR) AND CrossListID > 0) )
--Select Distinct SROfferID Into #TmpCross2 From #RosterBYOR UNION  Select CrossListID as SROfferID From SROffer Where SROfferID IN  (Select Distinct SROfferID From #RosterBYOR) AND CrossListID > 0 UNION  Select SROfferID from SROffer Where CrossListID IN (  (Select Distinct SROfferID From #RosterBYOR) UNION   (Select CrossListID From SROffer Where SROfferID IN      (Select Distinct SROfferID From #RosterBYOR) AND CrossListID > 0) )


Select Distinct A.* Into #TempSracademic From CAMS_RptRoster_View A  Inner Join #RosterBYOR as B ON A.SROfferID = B.SROfferID AND A.SracademicID = B.SracademicID


select * from #tempSracademic

Select Distinct A.* into #tmptable From CAMS_RptSROfferSchedule_View A Where (A.SrofferID IN (Select Distinct SROfferID From #RosterBYOR)) 


select * from #tmptable

select Distinct RoomAbbreviation, FirstName, LastName from #tmptable
drop table #TmpCross2
drop table #tmptable

drop table #RosterBYOR
drop table #tempSracademic


