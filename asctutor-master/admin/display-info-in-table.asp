<!--#include file="../includes/header.asp"-->

<%
response.expires=-1
dim sql
sql="SELECT UserName,Type FROM Users Where UserName="
sql=sql & "'" & request.querystring("q") & "'"

'If Request.ServerVariables("REQUEST_METHOD")= "POST" then
'request form inputs
'Request.Form("CRN")
'update form inputs 
'end if

EstablishDBCON rsforadmin,conforadmin
rsforadmin.Open sql,conforadmin


response.Write("<table class='table table-bordered'>")
response.Write("<tr>")
response.Write("<td colspan='2' style='text-align:center;'>" & "<b>User Information</b>" & "</th>")
response.Write("</tr>")

UserName = rsforadmin("UserName")
UType = rsforadmin("Type")


rsforadmin.Close


if UType = "Tutee" then
		EstablishDBCON rs_tuteepersonalinfo,con_tuteepersonalinfo
        EstablishDBCON rs_tuteeclassinfo,con_tuteeclassinfo
        EstablishDBCON putCoursesBackIn, con_putCoursesBackin

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
                    sqlString = "Select Course1 from Tutee where UserName = '"&username&"'"
                    putCoursesBackIn.open sqlString

                    if putCoursesBackIn.eof then
                    'it is not eofing
                    'this is if no record is found
	                   Course1 = putCoursesBackIn("Course1") 
                          if Course1= "EMPTY" then
                            
                       end if
                    else
                        'if record is found
                        Course1 = putCoursesBackIn("Course1")
                        
                    end if

                    putCoursesBackIn.close
	                Course1Time = ""
                End If


                if NOT rs_tuteeclassinfo.EOF Then
	                Tutor2= rs_tuteeclassinfo("UserName")
	                Course2 = rs_tuteeclassinfo("Course")
	                Course2Time = rs_tuteeclassinfo("Day")&"  "&rs_tuteeclassinfo("Start Time")&"-"&rs_tuteeclassinfo("Stop Time")
	            Else
	                Tutor2 = ""
                    sqlString = "Select Course2 from Tutee where UserName = '"&username&"'"
                    putCoursesBackIn.open sqlString

                     if putCoursesBackIn.eof then
                    'it is not eofing
                    'this is if no record is found
	                   Course2 = putCoursesBackIn("Course2") 
                          if Course2= "EMPTY" then
                           
                       end if
                    else
                        'if record is found
                        Course2 = putCoursesBackIn("Course2")
                        
                    end if

                    putCoursesBackIn.close
	                Course2Time = ""
                End If
                
                response.Write("<tr>")
                Response.Write("<td>Winthrop ID</td>")
                Response.Write("<td>"& getWID(UserName) & "</td>")
                response.Write("</tr>")

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
                Response.Write("<td>"&EmailAddr&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Tutor 1</td>")
                Response.Write("<td>"&Tutor1&"</td>")
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
                Response.Write("<td>"&Tutor2&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 2</td>")

                Response.Write("<td>"&getCourseTitle(Course2)&"</td>")

                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 2 Time</td>")
                Response.Write("<td>"&Course2Time&"</td>")
                response.Write("</tr>")
                
                response.Write("<tr>")
                Response.Write("<td>Date Registered</td>")
                Response.Write("<td>"&getDateRegistered(UserName)&"</td>")
                response.Write("</tr>")
            
                
				response.Write("</table>")

elseif UType = "Tutor" then
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
                Response.Write("<td>Winthrop ID</td>")
                Response.Write("<td>"& getWID(UserName) & "</td>")
                response.Write("</tr>")
             
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
                
                response.Write("<tr>")
                Response.Write("<td>Date Registered</td>")
                Response.Write("<td>"&getDateRegistered(UserName)&"</td>")
                response.Write("</tr>")


				Response.Write("</table>")
				
EstablishDBCON rstutorinfo, contutorinfo
TutorName = username
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
                Response.write(getRealName (Tutee1))
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(getRealName (Tutee2))
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
else
    	Response.Write("This tutor is not currently tutoring any tutees.")

end if


elseif UType = "Admin" then

                response.Write("<tr>")
                Response.Write("<td>User Name</td>")
                Response.Write("<td>"& UserName& "</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>User Type</td>")
                Response.Write("<td>"&UType&"</td>")
                response.Write("</tr>")
                response.Write("</table>")
end if




%>

