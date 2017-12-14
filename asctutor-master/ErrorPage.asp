<!DOCTYPE html>
<% response.buffer = true %><html>
<head>
<!--#include file="includes/header_For_Homepage.asp"-->
</head>
<body>
<div class="container-fluid">
	<div style="text-align:center;">
	<h2>Hey there, <%Response.Write(Request.Cookies("user")("username"))%>. You tried to enter invalid data into a form, and that's not allowed!<br /></h2>
	<p>For future reference, please don't enter any of these values:</p>
	<pre>
-- < > ( ) ; /* ' "" % */ @@
	</pre>
	<%
		dim userType
		userType = Request.Cookies("user")("type")
		if userType = "Admin" then
			Response.Write("<h3><a href='admin/default.asp'>Click here to go back to the admin portal</a></h3>")
		ElseIf userType = "Tutee" then
			Response.Write("<h3><a href='tutee/default.asp'>Click here to go back to the tutee portal</a></h3>")
		ElseIf userType = "Tutor" then
			Response.Write("<h3><a href='tutor/default.asp'>Click here to go back to the tutor portal</a></h3>")
		Else
			Response.Write("<h3><a href='logout.asp'>Your cookie is corrupted, Please click here to logout and then login again.</a></h3>")
		End If
	%>
	</div>
</div> <!-- /container -->
</body>
</html>