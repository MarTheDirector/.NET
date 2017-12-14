<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
	<!--#include file="../includes/navbar-admin.asp"-->
	

    <div class="container">
        <form action="reset-users-password.asp" class="form-horizontal" name="addForm" onsubmit="return validateForm()" method="post">
        <h2>Reset a user's password</h2>
		<%
		If (Request.ServerVariables("REQUEST_METHOD")= "POST")  Then
            'establish connection and get username from form
            EstablishDBCON rs4,con4
            EstablishDBCON rs5, con5
            EstablishDBCON rsForgotPass, conForgotPass
            
            username = Request.Form("username")
            newPassword = Request.Form("newPassword")
            databasePassword = sha256(Request.Form("newPassword")& "xxMc4ppl3saUceBurgerKingxx")	
			theQuery = "SELECT * FROM Users Where UserName="
			theQuery = theQuery & "'" & username & "'"
			
			'Open the query
			rsForgotPass.open(theQuery)
			userType = rsForgotPass("Type")
			If userType = "Tutee" then
				GetRecord rs5, "Tutee", username
				bodyEmail = "Your password has been reset by the administrator for them to access your account.<br />It has been reset to: " &_
				newPassword & "<br />You can login using this password next time and then once logged in you can change your password."
				Email rs5("Email"), "Your password has been reset", bodyEmail
			ElseIf userType = "Tutor" then
				GetRecord rs5, "Tutor", username
				bodyEmail = "Your password has been reset by the administrator for them to access your account.<br />It has been reset to: " &_
				newPassword & "<br />You can login using this password next time and then once logged in you can change your password."
				Email rs5("Email"), "Your password has been reset", bodyEmail		
			else
				response.Write("That admin's password has been reset but they haven't been emailed. Please be sure to let them know.")
			End If
						
			'setup the query and do it
			myQuery = "UPDATE Users Set "
			myQuery = myQuery & "Password= '" & databasePassword & "' "			
			myQuery = myQuery & " WHERE UserName = '" & username & "' "
			rs4.Open(myQuery)
			
			'Print success message
			Response.Write("<div class='alert alert-success'>For User: " & username & ", You Successfully Changed Their Password!</div>")
		End If
		%>
        <div class="control-group">
        	<label class="control-label">username</label>
        	<div class="controls">
	        	<select name="username">
	        	 <%
	        	EstablishDBCON rs2,con2
	        	
	        	'Do a query to grab all users into rs
	        	queryString = "SELECT UserName FROM Users"
	        	rs2.Open queryString
	        	
	        	do until rs2.EOF
		        	For Each item In rs2.Fields
		        			if item <> Request.Cookies("user")("username") then
	                        Response.Write("<option>" & item & "</option>")
	                        End If
					Next
					 rs2.MoveNext
				loop
				%>
	        	</select><br />
        	</div>
 		</div>
        <div class="control-group">
        	<label class="control-label" for="newPassword">new password</label>
        	<div class="controls">
        		<input id="newPassword" name="newPassword" value="winthrop" required type="text">
        	</div>
        </div>
        <div class="form-actions">
			<button type=submit class='btn btn-primary'>Reset Password</button>
        	<a href="default.asp" class="btn btn-inverse">Back</a>
		</div>
       	</form>
    
      <hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

    </div> <!-- /container -->
<script>
function validateForm()
{
	var newPass=document.forms["addForm"]["newPassword"].value;
	if (newPass==null || newPass=="")
	{
	  	alert("Please enter a new password.");
	  	return false;
    }
    //checks if they entered illegal characters
    var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "%", "*/", "@@"];
    length = substrings.length;
    while (length--) {
        if (newPass.indexOf(substrings[length]) !== -1) {
            alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
            return false;
        }
    }
}
</script>
</body>
</html>