<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
	<!--#include file="../includes/navbar-tutee-home.asp"-->
    <%
        EstablishDBCON rs89, con89
        dim userName
        userName = Request.Cookies("user")("username")
        GetRecord rs89, "Tutee", userName
        If rs89("F_Name") = "EMPTY" Then
        	Response.Redirect "update-info.asp"
        End if
        rs89.close
    %>

    <div class="container">
        <% Response.write("<h2>Welcome, " & getRealName (Request.Cookies("user")("username")) & "</h2>") %>
        
        <%
        queryString = "select PasswordChanges,TimeChanges from AdditionalInformation where Username = '"& userName &"'"
        rs89.open queryString
        PasswordChanges = rs89("PasswordChanges")
        TimeChanges = rs89("TimeChanges")
        if PasswordChanges = 0 then
            Response.write("<div class='alert alert-error'>Please change your password to something you can remember. <br/> Click <a href='change-password.asp'>here</a> or go to change your password. <br/> This warning will remain until you do so. </div>")
         else
            'Response.write ("Password was changed")
        end if           
          if TimeChanges = 0 then
            Response.write("<div class='alert alert-error'>")
            Response.write("Please select a tutor by clicking <a href='find-tutor.asp'>here</a> or find a tutor. <br/> This warning will remain until you do so. </div>")
        else
            'Response.write ("Time was changed")
        end if    
         %>

        <div class= "well">
            <h3>Account Management</h3><hr style="margin: 0 0 1em 0;">
            <p class="lead">
        		<a href="update-info.asp">Update your information</a><br />
        		<a href="change-password.asp">Change your password</a><br />
            </p>
        </div>
        
        <div class= "well">
            <h3>Schedule Tools</h3><hr style="margin: 0 0 1em 0;">
            <p class="lead">
            	<a href="find-tutor.asp">Find a tutor</a><br />
            	<a href="view-tutor.asp">View your tutor times</a><br/>
        		<a href="view-info.asp">View your information</a>
            </p>
        </div> 
        <hr>
        <footer>
        	<!--#include file="../includes/footer.asp"-->
        </footer>

    </div> <!-- /container -->
</body>
</html>