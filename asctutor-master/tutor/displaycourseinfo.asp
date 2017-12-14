<!--#include file="../includes/header.asp"-->

<%
response.expires=-1
dim sql
'sql="SELECT Course, Title, Section, Instructor, Time, Days, Location from Course  Where Course="
'sql=sql & "'" & request.querystring("q") & "'"


'response.Write(sql)
'make this a procedure
queryvar = request.querystring("q")
sql = "exec dbo.displayallcourseinfo @Course = '" &queryvar& "'"

EstablishDBCON rsfortutee,confortutee
rsfortutee.Open sql,confortutee

response.Write("<table class='table table-bordered'>")
response.Write("<tr>")
response.Write("<td colspan='2' style='text-align:center;'>" & "<b>Course Information</b>" & "</th>")
response.Write("</tr>")


if rsfortutee.eof <> true then
                Course = rsfortutee("Course")
                Title = rsfortutee("Title")
                Section = rsfortutee("Section")
                Instructor = rsfortutee("Instructor")
                Times = rsfortutee("Time")
                Days = rsfortutee("Days")
                Location = rsfortutee("Location")

                response.Write("<tr>")
                Response.Write("<td>Course</td>")
                Response.Write("<td>"&Course&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Title</td>")
                Response.Write("<td>"&Title&"</td>")
                response.Write("</tr>")

                 response.Write("<tr>")
                Response.Write("<td>Section</td>")
                Response.Write("<td>"&Section&"</td>")
                response.Write("</tr>")

                 response.Write("<tr>")
                Response.Write("<td>Instructor</td>")
                Response.Write("<td>"&Instructor&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Time</td>")
                Response.Write("<td>"&Times&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Days</td>")
                Response.Write("<td>"&Days&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Location</td>")
                Response.Write("<td>"&Location&"</td>")
                response.Write("</tr>")





				response.Write("</table>")
				'response.Write("<button class='btn btn-primary' type='submit'>Submit Changes</button>")


end if
%>