<!DOCTYPE html>
<html>
<head>
<!--#include file="includes/header_For_Homepage.asp"-->
<META HTTP-EQUIV="refresh" CONTENT="3;URL=default.asp">
</head>
<body>
<!--#include file="includes/navbar-home.asp"-->
	<div class="container">
			<div style="text-align:center;">
			<h3>You have been Logged out.</h3>
			<h3>You will be redirected to the home page in 
			<script>
			var count=2;
			var counter=setInterval(timer, 1000); //1000 will  run it every 1 second
			function timer()
			{
			  if(count != 1)
			      document.getElementById("timer").innerHTML = count + " seconds ";
			  else
			      document.getElementById("timer").innerHTML = count + " second  ";
			  if (count <= 0)
			  {
			     clearInterval(counter);
			     return;
			  }
			 count=count-1;
			}
			</script><span id="timer">3 seconds </span>
			<i class="icon-spinner icon-spin"></i></h3>
			<p>If you are not redirected, you can <a href="default.asp">click this link to return to the home page</a></p>
			</div>
		<%
			Response.Cookies("user")("username") = ""
			Response.Cookies("user")("password") = ""
			Response.Cookies("user")("signout") = "out"
			Response.Cookies("user")("type") = ""
		%>
	</div>
</body>
</html>