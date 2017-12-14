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
        <form action="change-password.asp" class="form-horizontal" name="addForm" onsubmit="return validateForm()" method="post">
        
        <%       	
        	EstablishDBCON rs4,con4	
			If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
				If sha256(Request.Form("currPass") & "xxMc4ppl3saUceBurgerKingxx") <> Request.Cookies("user")("password") Then
					Response.write("<div class='alert alert-error'>You entered your current password incorrectly, please try again</div>")
				Else
					myQuery = "UPDATE Users Set "
					myQuery = myQuery & "Password= '" & Request.Form("confirmNewPass") & "' "			
					myQuery = myQuery & " WHERE UserName = '" & Request.Cookies("user")("username") & "' "
				
					rs4.Open(myQuery)
					Response.Cookies("user")("password") = sha256(Request.Form("confirmNewPass") & "xxMc4ppl3saUceBurgerKingxx")
					Response.write("<div class='alert alert-success'>Your new password was set successfully!</div>")
				End If
			End If
		%>
        
        <h2>Change Password</h2>
			<div class="control-group">
        		<label class="control-label" for="curr">Your current password</label>
        		<div class="controls">
        			<input name="currPass" id="curr" required autofocus type="password"><br />
        		</div>
        	</div>
        	<div class="control-group">
        		<label class="control-label" for="new">New password</label>
        		<div class="controls">	
        			<input name="newPass" id="new" required type="password"><br />
        		</div>
        	</div>
        	<div class="control-group">
        		<label class="control-label" for="conf">Confirm new password</label>
        		<div class="controls">	
        			<input name="confirmNewPass" id="conf" required type="password">
				</div>
			</div>
			<div class="form-actions">
        		<script>
        			document.write("<button type='submit' class='btn btn-primary'>Change Password</button>");
        		</script>
				<a href='default.asp' class='btn btn-inverse'>Back</a>
			</div>
       	</form>
  
      	<hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

    </div> <!-- /container -->
    
<script>
//Function to make sure form is filled out
function validateForm()
{
	var currPass=document.forms["addForm"]["currPass"].value;
	var newPass=document.forms["addForm"]["newPass"].value;
	var confirmNewPass=document.forms["addForm"]["confirmNewPass"].value;
	if (currPass==null || currPass=="" || newPass==null || newPass=="" || confirmNewPass==null || confirmNewPass=="")
	{
	  	alert("Please complete all fields.");
	  	return false;
	}
	if(newPass != confirmNewPass)
	{
		alert("Please make sure your new password is typed exactly the same in both of the bottom two fields.")
		return false;
    }
    //checks if they entered illegal characters
    var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "%", "*/", "@@"];
    length = substrings.length;
    while (length--) {
        if (currPass.indexOf(substrings[length]) !== -1 || newPass.indexOf(substrings[length]) !== -1 || confirmNewPass.indexOf(substrings[length]) !== -1) {
            alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
            return false;
        }
    }
}
</script>

</body>
</html>