<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
<!--#include file="../includes/navbar-tutor-home.asp"-->
    <%
        EstablishDBCON rs89, con89
        dim userName
        userName = Request.Cookies("user")("username")
        GetRecord rs89, "Tutor", userName
        If rs89("F_Name") = "EMPTY" Then
        	Response.Redirect "update-info.asp"
        End if
        rs89.close
    %>

    <div class="container">

      <!-- Main hero unit for a primary marketing message or call to action -->
        <% 
        'dim userType, userName, rs40
        'userType = Request.Cookies("user")("type")
        'userName = Request.Cookies("user")("username")
        'GetRecord rs40, userType, userName
		Response.write("<h2>Welcome, " & getRealName (Request.Cookies("user")("username")) & "</h2>")
		%>

         <%
        queryString = "select PasswordChanges from AdditionalInformation where Username = '"& userName &"'"
        rs89.open queryString
        PasswordChanges = rs89("PasswordChanges")
        'TimeChanges = rs89("TimeChanges")
        if PasswordChanges = 0 then
            Response.write("<div class='alert alert-error'>Please change your password to something you can remember. <br/> Click <a href='change-password.asp'>here</a> or go to change your password. <br/> This warning will remain until you do so. </div>")
        else
            'Response.write ("Password was changed")
        end if           
         %>

            <div class= "well">
	            <h3>Account Management</h3><hr style="margin: 0 0 1em 0;">
	            <p class="lead">
		        	<a href="update-info.asp">Update your information</a><br />
		            <a href="change-password.asp">Change your password</a>
	            </p>
            </div>
        	<div class= "well">
	            <h3>Scheduling Tools</h3><hr style="margin: 0 0 1em 0;">
	            <p class="lead">
		            <a href="edit-availability.asp">Edit your availability</a><br />
		        	<a href="drop-or-add-tutees.asp">View/Drop specific tutee(s)</a><br />
		        	<a href="view-info.asp">View your tutoring information</a>
	            </p>
            </div>
            <div class= "well">
	            <h3>Course Management</h3><hr style="margin: 0 0 1em 0;">
	            <p class="lead">
		            <a href="add-course.asp">Add a course to tutor for</a><br />
		            <a href="drop-course.asp">Drop a course you are tutoring</a><br />
	            </p>
            </div>
      <hr>

      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

    </div> <!-- /container -->
</body>
</html>