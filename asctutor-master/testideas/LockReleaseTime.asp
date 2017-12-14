<!--#include file="../includes/header.asp"-->


<%
'ID = cint(Request.QueryString("q"))

'ReleaseTime(ID)

Function LockTime(ID)
EstablishDBCON rsLockTime, conLockTime

'Determine UserName from ID
sql = "Select UserName from Available_Times where ID = "&ID
rsLockTime.open sql
UserName = rsLockTime("UserName")
rsLockTime.close

sql = "exec dbo.getMinMax @UserName = '"&UserName&"'"
rsLockTime.open sql
minID = cint(rsLockTime("minID"))
maxID = cint(rsLockTime("maxID"))
rsLockTime.close

timeConst = 17
'timeConstB =  '!!!!!!!!!!!Determine this constant
'response.write("Before the IF<br />")
'response.write("ID = " & ID & "<br />")
'response.write("minID = " & minID & "<br />")

'response.write("timeConst = " & timeConst & "<br />")

if( (ID =  minID) or (ID = minID + timeConst)  or (ID = timeConst*2 + minID) or (ID = timeConst*3 + minID) or (ID = timeConst*4 + minID) ) then

'Update After Only
 'Response.write ("Updated After Only")
 
    sql = "Select Status from Available_Times where ID = "&(ID+1)
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID+1)
        rsLockTime.open sql    
    elseif Status = "Closed" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID+1)
        rsLockTime.open sql   
    else 
        Response.write ("001: Something went wrong. Report this to admin. ")
    end if

elseif  ( (ID = (timeConst-1) + minID ) or (ID = ((timeConst)*2-1) + minID) or (ID = ((timeConst*3)-1) + minID) or (ID = ((timeConst*4)-1) + minID) or (ID = ((timeConst*5)-1) + minID) ) then
'Update Before Only
    'Response.write ("Updated Before Only")
    sql = "Select Status from Available_Times where ID = "&(ID-1)
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID-1)
        rsLockTime.open sql    
    elseif Status = "Closed" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID-1)
        rsLockTime.open sql   
    else 
        Response.write ("002: Something went wrong. Report this to admin. ")
    end if

else
'Update Before and After
    'Response.write ("Updated Before and After")
    'Update Before Time first
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID - 1) &")"
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID-1)
        rsLockTime.open sql    
    elseif Status = "Closed" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID-1)
        rsLockTime.open sql   
    else 
        Response.write ("003: Something went wrong. Report this to admin. ")
    end if

    'Update After time second
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID + 1) &")"
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID+1)
        rsLockTime.open sql    
    elseif Status = "Closed" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID+1)
        rsLockTime.open sql   
    else 
        Response.write ("004: Something went wrong. Report this to admin. ")
    end if

end if

Response.write(ID & "<br />")
Response.write("After only IDs <br />")
Response.write ( minID & "<br />")
Response.write ( minID + timeConst & "<br />")
Response.write ( timeConst*2 + minID  & "<br />")
Response.write (timeConst*3 + minID  & "<br />")
Response.write ( timeConst*4 + minID & "<br />")

Response.write("Before only IDs <br />")
Response.write ( (timeConst-1) + minID & "<br />")
 Response.write ((timeConst)*2-1 + minID & "<br />") 
 Response.write  ((timeConst*3)-1 + minID& "<br />") 
 Response.write   ((timeConst*4)-1 + minID& "<br />") 
 Response.write    ((timeConst*5)-1 + minID& "<br />")

End Function



Function ReleaseTime(ID)
EstablishDBCON rsReleaseTime, conReleaseTime

'Determine UserName from ID
sql = "Select UserName from Available_Times where ID = "&ID
rsReleaseTime.open sql
UserName = rsReleaseTime("UserName")
rsReleaseTime.close

sql = "exec dbo.getMinMax @UserName = '"&UserName&"'"
rsReleaseTime.open sql
minID = cint(rsReleaseTime("minID"))
maxID = cint(rsReleaseTime("maxID"))
rsReleaseTime.close

timeConst = 17
'timeConstB =  '!!!!!!!!!!!Determine this constant
'response.write("Before the IF<br />")
'response.write("ID = " & ID & "<br />")
'response.write("minID = " & minID & "<br />")

'response.write("timeConst = " & timeConst & "<br />")

if( (ID =  minID) or (ID = minID + timeConst)  or (ID = timeConst*2 + minID) or (ID = timeConst*3 + minID) or (ID = timeConst*4 + minID) ) then

'Update After Only
 Response.write ("Updated After Only")
 
    sql = "Select Status from Available_Times where ID = "&(ID+1)
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID+1)
        rsReleaseTime.open sql    
    elseif Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID+1)
        rsReleaseTime.open sql   
    else 
        Response.write ("001: Something went wrong. Report this to admin. ")
    end if

elseif  ( (ID = (timeConst-1) + minID ) or (ID = ((timeConst)*2-1) + minID) or (ID = ((timeConst*3)-1) + minID) or (ID = ((timeConst*4)-1) + minID) or (ID = ((timeConst*5)-1) + minID) ) then
'Update Before Only
    'Response.write ("Updated Before Only")
    sql = "Select Status from Available_Times where ID = "&(ID-1)
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID-1)
        rsReleaseTime.open sql    
    elseif Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID-1)
        rsReleaseTime.open sql   
    else 
        Response.write ("002: Something went wrong. Report this to admin. ")
    end if

else
'Update Before and After
    'Response.write ("Updated Before and After")
    'Update Before Time first
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID - 1) &")"
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID-1)
        rsReleaseTime.open sql    
    elseif Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID-1)
        rsReleaseTime.open sql   
    else 
        Response.write ("003: Something went wrong. Report this to admin. ")
    end if

    'Update After time second
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID + 1) &")"
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID+1)
        rsReleaseTime.open sql    
    elseif Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID+1)
        rsReleaseTime.open sql   
    else 
        Response.write ("004: Something went wrong. Report this to admin. ")
    end if

end if

End Function

 %>

 