<!--#include file="../includes/header.asp"-->
<%
UserName = request.querystring ("q")
EstablishDBCON rstutorcourses,conforcourses
sqlstring = "exec dbo.displayAllTutorTimes @UserName = '"&UserName&"'"
rstutorcourses.open sqlString

if rstutorcourses.eof = false then
        'Build table
        response.Write("<table class='table table-bordered'>")
        response.Write("<tr>")
        response.Write("<td colspan='7' style='text-align:center;'>" & "<b>Tutor Time Information</b>" & "</th>")
        response.Write("</tr>")
        response.Write("<tr>")
        response.Write("<td><b>Course</b></td>")
        response.Write("<td><b>Day</b></td>")
        response.Write("<td><b>Start Time</b></td>")
        response.Write("<td><b>Stop Time</b></td>")
        response.Write("<td><b>Tutee 1</b></td>")
        response.Write("<td><b>Tutee 2</b></td>")
        response.Write("<td><b>Status</b></td>")
        response.Write("<td><b>Allows Two?</b></td>")
        response.Write("</tr>")


    do until rstutorcourses.eof

        Course = rstutorcourses("Course")
        StartTime = rstutorcourses("Start Time")
        StopTime = rstutorcourses("Stop Time")
        Days = rstutorcourses("Day")
        Tutee1 = rstutorcourses("Tutee 1")
        Tutee2 = rstutorcourses("Tutee 2")
        Status = rstutorcourses("Status")
        AllowTwo = rstutorcourses("Allow Two?")

        'Full2, Full, Open2, Open
        if Status = "Open" then
            bgcolor = "#00FF00"
        elseif Status = "Open2" then
            bgcolor = "#00FF00"
        elseif Status = "Full" then
            bgcolor = "#FF0000"
        elseif Status = "Full2" then
            bgcolor = "#FFA500"
        end if
    
        response.Write("<tr bgcolor="&bgcolor&">")
                Response.Write("<td>"&Course&"</td>")
                Response.Write("<td>"&StartTime&"</td>")
                Response.Write("<td>"&StopTime&"</td>")
                Response.Write("<td>"&Days&"</td>")
                Response.Write("<td>"&Tutee1&"</td>")  
                Response.Write("<td>"&Tutee2&"</td>")
                Response.Write("<td>"&Status&"</td>")
                Response.Write("<td>"&AllowTwo&"</td>")
        response.Write("</tr>")

        rstutorcourses.movenext
    loop
else
    Response.write("Tutor has no times selected")
end if'Check if tutor has any times
%>