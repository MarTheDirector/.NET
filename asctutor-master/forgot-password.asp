<!DOCTYPE html>
<% response.buffer = true %><html>
<head>
<!--#include file="includes/header_For_Homepage.asp"-->
</head>
<body>
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="http://winthrop.edu/success/">ASC</a>

          <div class="nav-collapse collapse">
            <ul class="nav">
              <li><a href="default.asp"><i class="icon-home"></i> Home</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div><!--/.container-->
      </div><!--/.navbar-inner-->
    </div><!--/.navbar-->
<!--#include file="includes/sha256.asp"-->

<%
function RandomString()

    Randomize()

    dim CharacterSetArray
    CharacterSetArray = Array(_
        Array(3, "abcdefghijklmnopqrstuvwxyz"), _
        Array(2, "ABCDEFGHIJKLMNOPQRSTUVWXYZ"), _
        Array(3, "0123456789")_
    )

    dim i
    dim j
    dim Count
    dim Chars
    dim Index
    dim Temp

    for i = 0 to UBound(CharacterSetArray)

        Count = CharacterSetArray(i)(0)
        Chars = CharacterSetArray(i)(1)

        for j = 1 to Count

            Index = Int(Rnd() * Len(Chars)) + 1
            Temp = Temp & Mid(Chars, Index, 1)

        next

    next

    dim TempCopy

    do until Len(Temp) = 0

        Index = Int(Rnd() * Len(Temp)) + 1
        TempCopy = TempCopy & Mid(Temp, Index, 1)
        Temp = Mid(Temp, 1, Index - 1) & Mid(Temp, Index + 1)

    loop

    RandomString = TempCopy

end function
%>

<div class="container">
		<h2>Reset Your Password</h2>
		<p>To reset your password, please enter the following details.</p>
		<%
			EstablishDBCON rsForgotPass, conForgotPass
			EstablishDBCON rsPassReset, conPassReset
			dim myQuery, newPassword, bodyOfEmail


			
			If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
				'initialize variables
				dim theQuery, username, theEmail
				theEmail = Request.Form("email")
				username = Request.Form("username")				
				theQuery = "SELECT * FROM Users Where UserName="
				theQuery = theQuery & "'" & username & "'"
				
				'Open the query
				rsForgotPass.open(theQuery)
				
				'Check to see what type of user it is
				If rsForgotPass.eof then
					Response.Write("<div class='alert alert-error'>The username you entered is not correct, please try again.</div>")
				
				elseif rsForgotPass("Type") = "Tutee" then
					'Grab the info about that user
					EstablishDBCON rsTutee, conTutee
					GetRecord rsTutee, "Tutee", username
					
					If rsTutee("Email") <> theEmail then
						Response.Write("<div class='alert alert-error'>The email you entered is not correct, please try again.</div>")
					Else
						'Reset their password to a randomly generated one
						newPassword = RandomString
                        shaPassword = sha256(newPassword & "xxMc4ppl3saUceBurgerKingxx")
						myQuery = "UPDATE Users Set "
						myQuery = myQuery & "Password= '" & shaPassword & "' "			
						myQuery = myQuery & " WHERE UserName = '" & username & "' "
						rsPassReset.open(myQuery)
						bodyOfEmail = "The password for " & username & " has been reset to: " & newPassword & "<br />Please copy/paste this password and login to the site using the link provided below. After logging in you may change your password through the account menu."
						Email theEmail, "Your Password Has Been Reset", bodyOfEmail
						Response.Write("<div class='alert alert-success'>Your password has been reset<br />Please check your email for your new password</div>")										
					End if
					
				elseif rsForgotPass("Type") = "Tutor" then
					'Grab the info about that user
					EstablishDBCON rsTutor, conTutor
					GetRecord rsTutor, "Tutor", username
					
					If rsTutor("Email") <> theEmail then
						Reponse.Write("<div class='alert alert-error'>The email you entered is not correct, please try again.</div>")
					Else
						'Reset their password to a randomly generated one
						newPassword = RandomString
                        shaPassword = sha256(newPassword & "xxMc4ppl3saUceBurgerKingxx")
						myQuery = "UPDATE Users Set "
						myQuery = myQuery & "Password= '" & shaPassword & "' "			
						myQuery = myQuery & " WHERE UserName = '" & username & "' "
						rsPassReset.open(myQuery)
						bodyOfEmail = "The password for " & username & " has been reset to: " & newPassword & "<br />Please copy/paste this password and login to the site using the link provided below. After logging in you may change your password through the account menu."
						Email theEmail, "Your Password Has Been Reset", bodyOfEmail
						Response.Write("<div class='alert alert-success'>Your password has been reset<br />Please check your email for your new password</div>")				
					End if
					
				elseif rsForgotPass("Type") = "Admin" then
					Response.Write("<div class='alert alert-error'>Unfortunately we cannot recover your password as you are an administrator.<br />Please consult the documentation manual for more help.</div>")
				
				End if
				
			End If
		%>
		<form name="ForgotPassword" class="form-horizontal" action="forgot-password.asp" method="post" onsubmit="return validateForm()">
			
			<div class="control-group">
		        <label class="control-label" for="username">username</label>
		        <div class="controls">
			       	<input name='username' id='username' type='text' required placeholder="Usually your Winthrop username">
		       	</div>
	       	</div>

			<div class="control-group">
		        <label class="control-label" for="email">email</label>
		        <div class="controls">
			       	<input name='email' id='email' type='email' required placeholder="Usually your Winthrop email">
		       	</div>
	       	</div>

			
			<div class="form-actions">
        		<script>
        			document.write("<button type='submit' class='btn btn-primary'>Reset Password</button>");
        		</script>
        		<a href="default.asp" class="btn btn-inverse">Back</a>
			</div>

		</form>
<hr>
<footer>
	ASC Tutoring
</footer>
</div> <!-- /container -->

<script>
function validateForm() {
	var username = document.forms["ForgotPassword"]["username"].value;
	var email = document.forms["ForgotPassword"]["email"].value;
	
    if (username == null || username == "") {
        alert("Please enter your username.");
        return false;
    }

    if (email == null || email == "") {
        alert("Please enter your email.");
        return false;
    }
    
    //checks if they entered illegal characters
    var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "%", "*/", "@@"];
    length = substrings.length;
    while (length--) {
        if (username.indexOf(substrings[length]) !== -1 || email.indexOf(substrings[length]) !== -1) {
            alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
            return false;
        }
    }
}
</script>

<!-- JQuery and Boostrap Scripts placed in footer to improve page load times -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='js/jquery-1.8.3.min.js' type='text/javascript'%3E%3C/script%3E"));
}
</script>
<script src="js/bootstrap.min.js"></script>
</body>
</html>