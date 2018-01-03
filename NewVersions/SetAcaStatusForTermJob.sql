DECLARE @endd datetime
DECLARE @UT varchar(25)
 
set @UT=dbo.getCurrentTerm()

set @endd=(select TermEndDate from dbo.TermCalendar where TextTerm=dbo.getCurrentTerm())

if @UT NOT like 'SU%'
	BEGIN
	if (cast(GETDATE() as date) = DATEADD(day, 5, cast(@endd as date)))
	 OR (cast(GETDATE() as date) = DATEADD(day, 15, cast(@endd as date)))
		EXEC [dbo].[CTM_SetTermAcademicStatusForAll] @UT
		else
		select 'No'
    END
 