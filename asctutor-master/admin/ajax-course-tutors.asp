

<!--#include file="../includes/header.asp"-->
<%
Course = request.querystring ("q")
EstablishDBCON rstutorcoursesinfo,conforcourses

sqlString = "exec dbo.displayallcourseInfo @Course ='"&Course&"'"
rstutorcoursesinfo.open sqlString

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
    
    'rstutorcoursesinfo.open sqlString
                course= rstutorcoursesinfo("Course")
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

    response.write("</table>")
rstutorcoursesinfo.close


sqlstring = "exec dbo.CourseTutors @Course = '"&Course&"'"
rstutorcoursesinfo.open sqlString

if rstutorcoursesinfo.eof = false then
        'Build table
        response.Write("<table class='table table-bordered'>")
        response.Write("<tr>")
        response.Write("<td colspan='7' style='text-align:center;'>" & "<b>Course's Tutors</b>" & "</th>")
        response.Write("</tr>")
        response.Write("<tr>")
        response.Write("<td><b>Username</b></td>")
        response.Write("<td><b>Full Name</b></td>")
        response.Write("</tr>")



    do until rstutorcoursesinfo.eof

        UserName = rstutorcoursesinfo("UserName")  
        response.Write("<tr >")
                Response.write("<td>"&UserName&"</td>")
                Response.write("<td>"&getRealName(UserName)&"</td>")
        response.Write("</tr>")

        rstutorcoursesinfo.movenext
    loop

else
    Response.write("Course has no tutors")
end if'Check if tutor has any times

rstutorcoursesinfo.close

%>