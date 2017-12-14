<!--#include file="sha256.asp"-->
<%
'***************************************************************************************************************
'User Validity Checker
'***************************************************************************************************************

'Tests if user has logged out
	if (Request.Cookies("user")("signout") <> "in") Then
		Response.Redirect "../default.asp"
		
'Tests if username and password portion of cookie exists	
	elseif  (Request.Cookies("user")("username") <> "") AND (Request.Cookies("user")("password") <> "") Then
	
'Tests if username portion of cookie is not empty
		If Len(Request.Cookies("user")("username"))>1 Then
		

			EstablishDBCON rs,con2	

		
			queryString = "SELECT * FROM Users WHERE UserName= '" & Request.Cookies("user")("username") & "' "
			rs.Open queryString
			
			'*****************************************************
			'Password Check	
			'*****************************************************
								
				If Request.Cookies("user")("password") <> rs("Password")  Then
					rs.close
					Response.Redirect "../logout.asp"
				
				ElseIf Request.Cookies("user")("type") <> "Admin" Then
					rs.close
					Response.Redirect "../unallowed.asp"


					
				End if
		End if

	else
		rs.close
		Response.Redirect "default.asp"
	End if
%>
				
