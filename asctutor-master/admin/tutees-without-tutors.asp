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

<%

    


    %>
    <table class="table table-bordered">
    <tr><td colspan="4" style="text-align:center; font-size:x-large; font-weight:bold;">Total Tutees Without Tutors</td></tr>
    <tr><td><b> User Name </b></td><td><b> Course </b></td></tr>
<%
    emptyCheck = "EMPTY"
	EstablishDBCON rsReport, conReport
    EstablishDBCON rsReport2, conReport2
    counter = 0
    sqlString = "Select * from Tutee where Course1 <> '"&emptyCheck&"'"
    rsReport.Open sqlString

    do until rsReport.eof
        UserName = rsReport("UserName")
        Course = rsReport("Course1")

        sqlString = "Select * from Available_Times where (([Tutee 1] = '"&UserName&"') and (Course = '"&Course&"' )) or  ((Course = '"&Course&"' ) and ([Tutee 2] = '"&UserName&"'))"

        rsReport2.open sqlString

            if rsReport2.eof then
            Response.write("<tr><td>")
            Response.write(UserName)
            Response.write("</td>")
            Response.write("<td>")
            Response.write(Course)
            Response.write("</td>")
            Response.write("</tr>")
            counter= counter + 1
            else
            'Testing
            'Response.write(UserName & " does have a tutor for " & Course & "</br>")
            end if
        rsReport2.close

        rsReport.movenext
    loop 

    rsReport.close

    sqlString = "Select * from Tutee where Course2 <> '"&emptyCheck&"'"
    rsReport.Open sqlString

    do until rsReport.eof
        UserName = rsReport("UserName")
        Course = rsReport("Course2")

        sqlString = "Select * from Available_Times where (([Tutee 1] = '"&UserName&"') and (Course = '"&Course&"' )) or  ((Course = '"&Course&"' ) and ([Tutee 2] = '"&UserName&"'))"

        rsReport2.open sqlString

            if rsReport2.eof then
            Response.write("<tr><td>")
            Response.write(UserName)
            Response.write("</td>")
            Response.write("<td>")
            Response.write(Course)
            Response.write("</td>")
            Response.write("</tr>")
            counter= counter + 1
            else
            'Testing
            'Response.write(UserName & " does have a tutor for " & Course & "</br>")
            end if
        rsReport2.close

        rsReport.movenext
    loop 

      rsReport.close


%>
<tr>
    <td colspan = 4><p><b>Total: <%Response.Write(counter)%></b></p></td>
</tr>	
</table>

<a href="report.asp" class="btn btn-inverse">Back</a>
  <hr>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  
</div>
</body>
</html>
