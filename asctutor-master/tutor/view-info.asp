<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>

</head>
<body>
<!--#include file="../includes/navbar-tutor.asp"-->
    <div class="container">
		<%				
				response.Write("<table class='table table-bordered'>")
				response.Write("<tr>")
				response.Write("<td colspan='2' style='text-align:center;'>" & "<b>User Information</b>" & "</th>")
		
				username = Request.Cookies("user")("username")
				UType = Request.Cookies("user")("type")
				EstablishDBCON rs6,con6
				GetRecord rs6, "Tutor", username
				
				'Find all the tutees that this tutor tutors
				
                FName = rs6("F_Name")
                LName = rs6("L_Name")
                PhoneNo = rs6("PhoneNo")

                theEmail = rs6("Email")

                MHours = rs6("M_Hours")
                TakenHours = rs6("U_Hours")

             
                response.Write("<tr>")
                Response.Write("<td>User Name</td>")
                Response.Write("<td>"& UserName& "</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>User Type</td>")
                Response.Write("<td>"&UType&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>First Name</td>")
                Response.Write("<td>"&FName&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Last Name</td>")
                Response.Write("<td>"&LName&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Phone Number</td>")
                Response.Write("<td>"&PhoneNo&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Email</td>")
                Response.Write("<td>"&theEmail&"</td>")
                response.Write("</tr>")

                
                response.Write("<tr>")
                Response.Write("<td>Max Hours</td>")
                Response.Write("<td>"&MHours&"</td>")
                response.Write("</tr>")
                
                response.Write("<tr>")
                Response.Write("<td>Taken Hours</td>")
                Response.Write("<td>"&TakenHours&"</td>")
                response.Write("</tr>")

				Response.Write("</table>")

		%>
<br />
<%
EstablishDBCON rstutorinfo, contutorinfo
TutorName = Request.Cookies("user")("username")
sqlString = "exec dbo.ActiveTutorTutees @UserName ='"&TutorName&"'"
'Response.write sqlString
rstutorinfo.open sqlString

if rstutorinfo.eof = false then
		Response.write("<table class='table table-bordered'>")
		Response.write("<tr>")
		Response.write("<th colspan=9 style='text-align:center;'>Tutees being tutored</th>")
		Response.write("</tr>")
		Response.write("<tr>")
		Response.write("<td>ID</td>")
		Response.write("<td>Day</td>")
		Response.write("<td>Start Time</td>")
		Response.write("<td>Stop Time</td>")
		Response.write("<td>Tutee 1</td>")
		Response.write("<td>Tutee 2</td>")
		Response.write("<td>Course</td>")
		Response.write("<td>Allows Two?</td>")
		Response.write("</tr>")

        do until rstutorinfo.eof 
                UserName= rstutorinfo("UserName")
                Days = rstutorinfo("Day")
                StartTime=rstutorinfo("Start Time")
                StopTime=rstutorinfo("Stop Time")
                Status = rstutorinfo("Status")
                Tutee1= rstutorinfo("Tutee 1")
                Tutee2= rstutorinfo("Tutee 2")
                Selected = rstutorinfo("Tutor Selected")
                Allows2 = rstutorinfo("Allow Two?")
                Course = rstutorinfo("Course")
                ID = rstutorinfo("ID")
                DisplayThisTime = StartTime & "-" & StopTime

                Response.write("<tr>")

                Response.write("<td>")
                Response.write(ID)
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
                 Response.write ("<a href='view-basic-info.asp?q="&Tutee1&"'>")
                Response.write(getRealName (Tutee1))
                Response.write ("</a>")
                Response.write("</td>")

                 Response.write("<td>")
                 Response.write ("<a href='view-basic-info.asp?q="&Tutee2&"'>")
                Response.write(getRealName (Tutee2))
                Response.write ("</a>")
                Response.write("</td>")

                Response.write("<td>")
                Response.write(getCourseTitle(Course))
                Response.write("</td>")

                Response.write("<td>")
                Response.write(Allows2)
                Response.write("</td>")
                Response.write("</tr>")

                rstutorinfo.movenext
         loop

		Response.write("</table>")
		'Response.write("<button type='submit'value ="&ID&"class='btn btn-primary'>Submit</button>")
else
    	Response.Write("You are not currently tutoring any tutees.")

end if
%>
	  <a href="default.asp" class="btn btn-inverse">Back</a>
      <hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

</div> <!-- /container -->
</body>
</html>