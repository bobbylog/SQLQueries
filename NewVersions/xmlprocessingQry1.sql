drop table #tmp

DECLARE @MyXML XML


Declare @Object as Int;
Declare @ResponseText as NVarchar(Max);
DECLARE @posData NVARCHAR(2500)
SET @posData = 'method=get_user_grades&token=Moodle2018&user=A0000024702'
 
DECLARE @ret binary(4);


Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;

--Code Snippet
Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;

Exec @ret=sp_OAMethod @Object, 'open', NULL, 'post','https://trocaire.mrooms.net/blocks/conduit/webservices/rest/user.php','false'
print @ret
Exec @ret=sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/x-www-form-urlencoded'
print @ret

Exec @ret=sp_OAMethod @Object, 'send("method=get_user_grades&token=Moodle2018&user=A0000024702&course=BU132I01-FA-17&xml=XMLSTRING")'
print @ret

Create table #tmp(dt nvarchar(max))

insert into #tmp
Exec sp_OAGetProperty @Object, 'responseText' --, @ResponseText OUTPUT
--print @ret
 
--Select @ResponseText

set @ResponseText=(select dt from #tmp)


set @ResponseText=REPLACE(@ResponseText, 'encoding="UTF-8"','')

select @ResponseText

set @MyXML=CONVERT(XML, @ResponseText)

SELECT
a.b.value('users[1]/id_20968[1]/user[1]/id[1]','varchar(10)') AS id,
a.b.value('users[1]/id_20968[1]/user[1]/fullname[1]','varchar(150)') AS fullname,
a.b.value('courses[1]/id_9188[1]/course[1]/id[1]','varchar(25)') AS courseid,
a.b.value('courses[1]/id_9188[1]/course[1]/shortname[1]','varchar(50)') AS shortname,
a.b.value('courses[1]/id_9188[1]/course[1]/fullname[1]','varchar(100)') AS fullname,
a.b.value('gradeitems[1]/gradeitem[1]/grades[1]/grade[1]/finalgrade[1]','varchar(25)') AS finalgradepoint,
a.b.value('gradeitems[1]/gradeitem[1]/grades[1]/grade[1]/gradeletter[1]','varchar(25)') AS finalgradeletter

FROM @MyXML.nodes('blocks_conduit_model_service_user/get_user_grades') a(b)

Exec sp_OADestroy @Object

select * from SRAcademic where StudentUID=118196
and TermCalendarID=616
and grade <> 'w'


drop table #tmp
