<!--#include file="../includes/header.asp"-->
		<%

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

                MHours = rs6("M_Hours")
                TakenHours = rs6("U_Hours")

                Response.write("<div id = 'results'>")
                Response.Write("User Name: ")
                Response.Write(""& UserName)
                response.Write("<br />")

                Response.Write("User Type: ")
                Response.Write(""& UType)
                response.Write("<br />")

                Response.Write("First Name: ")
                Response.Write(""&FName)
                response.Write("<br />")


                 Response.write("</div>")
                rs6.close

		%>
