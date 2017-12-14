<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
<!--#include file="../includes/navbar-tutee.asp"-->
</head>
<body>

   
                    

		<%
				Response.write("<div class='container'>")
				response.Write("<table class='table table-bordered'>")
				response.Write("<tr>")
				response.Write("<td colspan='2' style='text-align:center;'>" & "<b>User Information</b>" & "</th>")
		
				UserName = Request.QueryString("q")
				
				EstablishDBCON rs6,con6
				
                query = "Select Type from Users where UserName = '"&UserName&"'"
                rs6.open query
                UType = rs6("Type")
				rs6.close

                query = "Select * from "&UType&" where UserName = '"&UserName&"'"
				'response.write (query)
                rs6.open query

                FName = rs6("F_Name")
                LName = rs6("L_Name")
                PhoneNo = rs6("PhoneNo")

                theEmail = rs6("Email")

             
                'response.Write("<tr>")
                'Response.Write("<td>User Name</td>")
                'Response.Write("<td>"& UserName& "</td>")
                'response.Write("</tr>")

                'response.Write("<tr>")
                'Response.Write("<td>User Type</td>")
                'Response.Write("<td>"&UType&"</td>")
                'response.Write("</tr>")

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


				Response.Write("</table>")
                rs6.close

		%>
        <a href="view-tutor.asp" class="btn btn-primary">Back</a>
</body>
<br />
<hr />
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

      

</html>