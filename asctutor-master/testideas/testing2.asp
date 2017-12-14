<!--#include file="../includes/header.asp"-->

<%
response.expires=-1
dim sql
sql="SELECT UserName,Type FROM Users Where UserName="
sql=sql & "'" & request.querystring("q") & "'"
'response.Write(sql&"<br/>")

'Pointless stuff 
'set conn=Server.CreateObject("ADODB.Connection")
'conn.Provider="Microsoft.Jet.OLEDB.4.0"
'conn.Open(Server.Mappath("/db/northwind.mdb"))
'set rs=Server.CreateObject("ADODB.recordset")
'rs.Open sql,conn


EstablishDBCON rsforadmin,conforadmin
'EstablishDBCON testforadmin,testforadmin
rsforadmin.Open sql,conforadmin

dim bordervalue
bordervalue=1

response.Write("<table class='table table-bordered'>")
response.Write("<tr>")
response.Write("<td colspan='2' style='text-align:center;'>" & "<b>User Information</b>" & "</th>")
'response.Write("<th>" & "Type" & "</th>")
response.Write("</tr>")
'response.Write("<tr>")

UserName = rsforadmin("UserName")
UType = rsforadmin("Type")


'rsforadmin.Close
'Response.Write(UserName)
'Reponse.Write(UType)
'sql="SELECT L_Name,F_Name,PhoneNo,Tutor1,Tutor2,Course1,Course2,Standing,Course1Time,Course2Time FROM Tutee Where UserName='"&UserName&"'"
'Response.Write("<br>" & sql & "</br>")
rsforadmin.Close
'rsforadmin.Open sql

if UType = "tutee" then
    sql="SELECT L_Name,F_Name,PhoneNo,Tutor1,Tutor2,Course1,Course2,Standing,Course1Time,Course2Time FROM Tutee Where UserName='"&UserName&"'"
    rsforadmin.Open sql
                FName = rsforadmin("F_Name")
                LName = rsforadmin("L_Name")
                PhoneNo = rsforadmin("PhoneNo")
                Tutor1 = rsforadmin("Tutor1")
                Tutor2= rsforadmin("Tutor2")
                Course1 = rsforadmin("Course1")
                Course2 = rsforadmin("Course2")
                Standing = rsforadmin("Standing")
                Course1Time = rsforadmin("Course1Time")
                Course2Time = rsforadmin("Course2Time")

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
                Response.Write("<td>Tutor 1</td>")
                Response.Write("<td>"&Tutor1&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 1</td>")
                Response.Write("<td>"&Course1&"</td>")
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
                Response.Write("<td>"&Course2&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 2 Time</td>")
                Response.Write("<td>"&Course2Time&"</td>")
                response.Write("</tr>")
               ' response.Write("</tr>")

				'rsforadmin.MoveNext

                'response.Write("<tr>")
    'loop
'end if
response.Write("</table>")

elseif UType = "tutor" then
                sql="SELECT L_Name,F_Name,PhoneNo,Course1,Course2,Course3,Course4,Course5,M_Hours FROM Tutor Where UserName='"&UserName&"'"
                rsforadmin.Open sql

                FName = rsforadmin("F_Name")
                LName = rsforadmin("L_Name")
                PhoneNo = rsforadmin("PhoneNo")
                Course1 = rsforadmin("Course1")
                Course2 = rsforadmin("Course2")
                Course3 = rsforadmin("Course3")
                Course4 = rsforadmin("Course4")
                Course5 = rsforadmin("Course5")
                MHours = rsforadmin("M_Hours")
                
              
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
                Response.Write("<td>Course 1</td>")
                Response.Write("<td>"&Course1&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 2</td>")
                Response.Write("<td>"&Course2&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 3</td>")
                Response.Write("<td>"&Course3&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 4</td>")
                Response.Write("<td>"&Course4&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Course 5</td>")
                Response.Write("<td>"&Course5&"</td>")
                response.Write("</tr>")
                
                response.Write("<tr>")
                Response.Write("<td>Max Hours</td>")
                Response.Write("<td>"&MHours&"</td>")
                response.Write("</tr>")

elseif UType = "admin" then

                response.Write("<tr>")
                Response.Write("<td>User Name</td>")
                Response.Write("<td>"& UserName& "</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>User Type</td>")
                Response.Write("<td>"&UType&"</td>")
                response.Write("</tr>")
end if


'response.Write(rsforadmin.Fields)
'response.write(rsforadmin.Fields)
'do until rs.EOF
'  for each x in rs.Fields
'    response.write("<tr><td><b>" & x.name & "</b></td>")
'    response.write("<td>" & x.value & "</td></tr>")
'  next
'  rs.MoveNext
'loop
'response.write("</table>")
%>