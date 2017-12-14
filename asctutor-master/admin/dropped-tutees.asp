<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
<!--#include file="../includes/navbar-admin.asp"-->
<div class="container">
    <div class= "well">
<%

	EstablishDBCON rsReport, conReport

    sqlString = "Select * from TuteeDateTutorDrop order by DropDate"
    rsReport.Open sqlString

    if rsReport.eof = true then
        counter= 0
        Response.write("No tutees have been dropped")

    else

        Response.write("<table class='table table-bordered'>")
        Response.write("<tr><td colspan='4' style='text-align:center; font-size:x-large; font-weight:bold;'>Dropped Tutees</td></tr>")
        Response.write("<tr>")
        Response.write("<td><b> Tutee Username </b></td>")
        Response.write("<td><b> Tutee Name </b></td>")
        Response.write("<td><b> Tutor Username </b></td>")
        Response.write("<td><b> Tutor Name </b></td>")
        Response.write("<td><b> Course </b></td>")
        Response.write("<td><b> Date Dropped </b></td>")


            do until rsReport.eof
                TuteeUserName = rsReport("Tutee")
                TutorUserName = rsReport("Tutor")
                Course = rsReport("CourseDropped")
                DateDropped = rsReport("DropDate")

                    Response.write("<tr><td>")
                    Response.write(TuteeUserName)
                    Response.write("</td>")
                    Response.write("<td>")
                    Response.write(getRealName(TuteeUserName))
                    Response.write("</td>")
                    Response.write("<td>")
                    Response.write(TutorUserName)
                    Response.write("</td>")
                    Response.write("<td>")
                    Response.write(getRealName(TutorUserName) )
                    Response.write("</td>")
                    Response.write("<td>")
                    Response.write(Course)
                    Response.write("</td>")
                    Response.write("<td>")
                    Response.write(DateDropped)
                    Response.write("</td>")
                    Response.write("</tr>")
               
                    counter= counter + 1     
                    rsReport.movenext
            loop 

    end if

%>
<tr>
    <td colspan = 6><p><b>Total Drops: <% Response.Write(counter) %></b></p></td>
</tr>	
</table>

<a href="default.asp" class="btn btn-inverse">Back</a>
  <hr>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  </div>
</div>
</body>
</html>
