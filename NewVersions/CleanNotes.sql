


--drop table ctm_advstudentNotesBak
select *
 --into ctm_advstudentNotesBak
from ctm_advstudentNotes
order by NoteID desc

--delete from ctm_advstudentNotes
--where NoteID in (100,101)


select * from ctm_advstudentNotes
order by NoteID desc
