<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>

</head>
<body>
<!--#include file="../includes/navbar-tutee.asp"-->

    <% 
        tuteeViewInfo = "tuteeViewInfo"
        LockPage(tuteeViewInfo)
    %>

    <div class="container">
    	    <div class="well">
		<%
		response.Write("<table class='table table-bordered'>")
response.Write("<tr>")
response.Write("<td colspan='2' style='text-align:center;'>" & "<b>User Information</b>" & "</th>")

		username = Request.Cookies("user")("username")
		UType = Request.Cookies("user")("type")
		EstablishDBCON rs_tuteepersonalinfo,con_tuteepersonalinfo
        EstablishDBCON rs_tuteeclassinfo,con_tuteeclassinfo
        
        
        
		GetRecord rs_tuteepersonalinfo, "Tutee", username
        myQuery = "Select * From Available_Times Where ([Tutee 1] = '"&username&"' OR [Tutee 2] = '"&username&"')"

        rs_tuteeclassinfo.open myQuery

				'Set Personal Info
                FName = rs_tuteepersonalinfo("F_Name")
                LName = rs_tuteepersonalinfo("L_Name")
                PhoneNo = rs_tuteepersonalinfo("PhoneNo")
                EmailAddr = rs_tuteepersonalinfo("Email")

                if NOT rs_tuteeclassinfo.EOF Then
	                Tutor1 = rs_tuteeclassinfo("UserName")
	                Course1 = rs_tuteeclassinfo("Course")
	                Course1Time = rs_tuteeclassinfo("Day")&"   "&rs_tuteeclassinfo("Start Time")&"-"&rs_tuteeclassinfo("Stop Time")
	                rs_tuteeclassinfo.movenext
	                Else
	                Tutor1 = ""
	                Course1 = ""
	                Course1Time = ""
                End If


                if NOT rs_tuteeclassinfo.EOF Then
	                Tutor2= rs_tuteeclassinfo("UserName")
	                Course2 = rs_tuteeclassinfo("Course")
	                Course2Time = rs_tuteeclassinfo("Day")&"  "&rs_tuteeclassinfo("Start Time")&"-"&rs_tuteeclassinfo("Stop Time")
	                Else
	                Tutor2 = ""
	                Course2 = ""
	                Course2Time = ""
                End If
                

                response.Write("<tr>")
                Response.Write("<td>User Name</td>")
                Response.Write("<td>"&  UserName& "</td>")
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
                Response.Write("<td>"&EmailAddr&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Tutor 1</td>")
                Response.Write("<td>")
                if Tutor1 <> "" then
                Response.Write(getRealName(Tutor1))
                else
                Response.Write(Tutor1)
                end if
                Response.write("</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 1</td>")
                Response.Write("<td>"&getCourseTitle(Course1)&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 1 Time</td>")
                Response.Write("<td>"&Course1Time&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Tutor 2</td>")
                Response.Write("<td>")
                 if Tutor2 <> "" then
                Response.Write(getRealName(Tutor2))
                else
                Response.Write(Tutor2)
                end if
                Response.write("</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 2</td>")
                if Course2 <> "" then
                Response.Write("<td>"&getCourseTitle(Course2)&"</td>")
                else
                Response.Write("<td>"&Course2&"</td>")
                end if
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 2 Time</td>")
                Response.Write("<td>"&Course2Time&"</td>")
                response.Write("</tr>")
				response.Write("</table>")

		%>
<a href="default.asp" class="btn btn-inverse">Back</a>
      <hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
</div> <!-- /well -->
</div> <!-- /container -->
</body>
</html>