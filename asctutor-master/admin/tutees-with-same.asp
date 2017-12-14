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


    <table class="table table-bordered">
    <tr><td colspan="2" style="text-align:center; font-size:x-large; font-weight:bold;">Tutees with Same Course Selected</td></tr>
    
    <%
    'Check if empty or else error is shown, skip all of this if empty
    Query = "Select * from Tutee where [Course1] = [Course2] and  [Course1] != 'EMPTY'"

	EstablishDBCON rsReport, conReport 
    rsReport.open Query
    counter = 0
    if rsReport.eof = false then
        Response.write("<tr><td><b> User Name </b></td><td><b> Email </b></td></tr>")
        do until rsReport.eof   
            UserName = rsReport("UserName")
            EmailAddress = rsReport("Email")
            Response.write("<tr><td>"&UserName&"</td>")
            Response.write("<td>"&EmailAddress&"</td></tr>")
            counter = counter+1
            rsReport.Movenext
        loop
    else 
        Response.write("No tutors without tutee.")
    end if
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
