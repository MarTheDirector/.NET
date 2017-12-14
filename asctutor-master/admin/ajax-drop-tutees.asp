<!--#include file="../includes/header.asp"-->
<form name="droptutees" action="drop-tutees.asp" method="post" >
<%
TuteeName = request.querystring ("q")
EstablishDBCON rsTuteeInfo, conForTuteeInfo
sqlString = "exec dbo.ActiveTuteeTutors @UserName ='"&TuteeName&"'"
'Response.write sqlString
rsTuteeInfo.open sqlString

if rsTuteeInfo.eof = false then
		Response.write("<table class='table table-bordered'>")
		Response.write("<tr>")
		Response.write("<th colspan=9 style='text-align:center;'>Tutees being tutored</th>")
		Response.write("</tr>")
		Response.write("<tr>")
		Response.write("<td>ID</td>")
        Response.write("<td>Tutor</td>")
		Response.write("<td>Day</td>")
		Response.write("<td>Start Time</td>")
		Response.write("<td>Stop Time</td>")
		Response.write("<td>Tutee 1</td>")
        Response.write("<td>Drop Tutee 1?</td>")
		Response.write("<td>Tutee 2</td>")
        Response.write("<td>Drop Tutee 2?</td>")
		Response.write("<td>Course</td>")
		Response.write("<td>Allows Two?</td>")
		Response.write("<td>Drop entire slot?</td>")
		Response.write("</tr>")

        do until rsTuteeInfo.eof 
                UserName= rsTuteeInfo("UserName")
                Days = rsTuteeInfo("Day")
                StartTime=rsTuteeInfo("Start Time")
                StopTime=rsTuteeInfo("Stop Time")
                Status = rsTuteeInfo("Status")
                Tutee1= rsTuteeInfo("Tutee 1")
                Tutee2= rsTuteeInfo("Tutee 2")
                Selected = rsTuteeInfo("Tutor Selected")
                Allows2 = rsTuteeInfo("Allow Two?")
                Course = rsTuteeInfo("Course")
                ID = rsTuteeInfo("ID")
                DisplayThisTime = StartTime & "-" & StopTime

                Response.write("<tr>")

                Response.write("<td>")
                Response.write(ID)
                Response.write("</td>")

                
                Response.write("<td>")
                Response.write(UserName)
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(Days)
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(StartTime)
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(StopTime)
                Response.write("</td>")

                 Response.write("<td>")
                 Response.write ("<a href='display-info-in-table.asp?q="&Tutee1&"'>")
                Response.write(getRealName (Tutee1))
                 Response.write ("</a>")
                Response.write("</td>")

                Response.write("<td>")
                Response.write("<button type='submit' name='Dropping' value ='"&ID&",1' class='btn btn-primary'>Drop Tutee 1</button>")
                Response.write("</td>")


                 Response.write("<td>")
                 Response.write ("<a href='display-info-in-table.asp?q="&Tutee2&"'>")
                Response.write(getRealName (Tutee2))
                Response.write ("</a>")
                Response.write("</td>")

                Response.write("<td>")
                if (getRealName(Tutee2)<> "") then
                Response.write("<button type='submit' name='Dropping' value ='"&ID&",2' class='btn btn-primary'>Drop Tutee 2</button>")
                end if
                Response.write("</td>")

                Response.write("<td>")
                Response.write(Course)
                Response.write("</td>")

                Response.write("<td>")
                Response.write(Allows2)
                Response.write("</td>")

                Response.write("<td>")
                Response.write("<button type='submit' name='Dropping' value ='"&ID&",3' class='btn btn-primary'>Drop</button>")
                Response.write("</td>")

                Response.write("</tr>")

                rsTuteeInfo.movenext
         loop

		Response.write("</table>")
		'Response.write("<button type='submit'value ="&ID&"class='btn btn-primary'>Submit</button>")
else
    	Response.Write(TuteeName & " does not have any tutors.")

end if

%>

<a href="default.asp" class="btn btn-inverse">Back</a>
</form>
