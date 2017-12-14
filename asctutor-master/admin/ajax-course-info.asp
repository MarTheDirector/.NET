
<!--#include file="../includes/header.asp"-->
<%
Course = request.querystring ("q")
EstablishDBCON rstutorcourses,conforcourses
sqlstring = "exec dbo.displayallcourseinfo @Course = '"&Course&"'"
rstutorcourses.open sqlString

if rstutorcourses.eof = false then

   

        CourseTitle = rstutorcourses("Title")  

                Response.write(CourseTitle)


else
    Response.write("Course info not found")
end if'Check if tutor has any times
%>
