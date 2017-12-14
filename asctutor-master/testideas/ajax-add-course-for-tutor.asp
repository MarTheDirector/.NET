 <!--#include file="../includes/header.asp"-->
 <%
 UserName = request.querystring ("q")
 EstablishDBCON rstutorcourses,conforadmin
 EstablishDBCON rstutorcoursesinfo,conforadmin2
 sqlString ="exec dbo.ShowTutorCourses @UserName = '"&UserName&"' "
 rstutorcourses.open sqlString

if rstutorcourses.eof = false then
    'if len(UserName)>1 then
        Response.write(UserName &" is tutoring the following courses: <br />")

        response.Write("<table class='table table-bordered'>")
        response.Write("<tr>")
        response.Write("<td colspan='7' style='text-align:center;'>" & "<b>Course Information</b>" & "</th>")
        response.Write("</tr>")
        response.Write("<tr>")
        response.Write("<td><b>Course</b></td>")
        response.Write("<td><b>Title</b></td>")
        response.Write("<td><b>Section</b></td>")
        response.Write("<td><b>Instructor</b></td>")
        response.Write("<td><b>Times</b></td>")
        response.Write("<td><b>Days</b></td>")
        response.Write("<td><b>Room</b></td>")
        response.Write("</tr>")

        do until rstutorcourses.eof
                Course= rstutorcourses("Course")
            'Response.write(Course & "<br />")

                sqlString ="exec dbo.displayallcourseinfo @Course = '"&Course&"' "
                rstutorcoursesinfo.open sqlString
                Title = rstutorcoursesinfo("Title")
                Instructor = rstutorcoursesinfo("Instructor")
                Section = rstutorcoursesinfo("Section")
                Location = rstutorcoursesinfo("Location")
                Times = rstutorcoursesinfo("Time")
                Days = rstutorcoursesinfo("Days")
               
                response.Write("<tr>")
                Response.Write("<td>"&Course&"</td>")
                Response.Write("<td>"&Title&"</td>")
                Response.Write("<td>"&Section&"</td>")
                Response.Write("<td>"&Instructor&"</td>")
                Response.Write("<td>"&Times&"</td>")  
                Response.Write("<td>"&Days&"</td>")
                Response.Write("<td>"&Location&"</td>")

                response.Write("</tr>")

				
                rstutorcoursesinfo.close

            rstutorcourses.movenext
        loop
        response.Write("</table>")
   ' end if
else
    Response.write("No courses currently being tutored")
end if
%>