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
       <div class="well">
        <form action="register-new-user.asp" class="form-horizontal" name="addForm" onsubmit="return validateForm()" method="post">
        <h2>Add a new user</h2>
		<div class="control-group">
        	<label class="control-label" for="username">username</label>
        	<div class="controls">
        		<input id="username" name="username" oninput="insertEmail()" required placeholder="username" type="text">
        	</div>
        </div>
		<div class="control-group">
        	<label class="control-label" for="user_email">email</label>
        	<div class="controls">
        		<input id="user_email" name="user_email" required placeholder="username@winthrop.edu" type="email">
        	</div>
        </div>
        <div class="control-group">
        	<label class="control-label" for="password">password</label>
        	<div class="controls">
        		<%
        			Response.Write("<input id='password' name='password' value='" & RandomString & "' required type='text'>")
				%>        	
        	</div>
        </div>
        <div class="control-group">
        	<label class="control-label" for="type">user type</label>
        	<div class="controls">
        		<select id="type" name="option">
				  <option value="Tutee">Tutee</option>
				  <option value="Tutor">Tutor</option>
				  <option value="Admin">Admin</option>
				</select>
        	</div>
        </div>
        <div class="form-actions">
        	<script>
        		document.write("<button type=submit class='btn btn-primary'>Add user</button>");
        	</script>
        	<a href="default.asp" class="btn btn-inverse">Back</a>
		</div>
       	</form>
       	
       

       	<%		
        EstablishDBCON rs2,con2	
        	
		If Len(Request.Form("username"))>1 Then
		
			Dim user_name, user_type, user_pass, queryString
	
			user_name = Request.Form("username")
			user_type = Request.Form("option")
            normal_user_pass = Request.Form("password")
			user_pass = sha256(Request.Form("password")& "xxMc4ppl3saUceBurgerKingxx")
			user_email = Request.Form("user_email")
			
			queryString = "SELECT * FROM Users WHERE UserName= '" & user_name & "' "
			
			
			rs2.Open queryString
						
			
			If rs2.EOF Then			
				queryString = "insert into Users (UserName, Password, Type) values('" & user_name & "','" & user_pass & "','" & user_type & "')"
				
				
				rs2.Close
				rs2.Open queryString
                
                queryString = "exec dbo.AddNewInformationForNewUser @UserName = '"&user_name & "'"
				rs2.Open queryString
				Response.Write("<div class='alert alert-success'>User: " & user_name & " Successfully Added!</div>")	
				
				
				'*************************************
				'Add user to appropriate tutor/tutee table
				'*************************************
				If user_type = "Tutee" Then
	
					queryString = "insert into Tutee (UserName, L_Name, F_Name, PhoneNo, Course1, Course2, Email) values('" & user_name & "','EMPTY' ,'EMPTY' ,'EMPTY', 'EMPTY', 'EMPTY', '" & user_email & "')"
					rs2.Open queryString
                    
                    'Update Date, add query 
                    queryString = "Update AdditionalInformation set DateRegistered = '" &Date &"' where Username = '"& user_name &"' "
                    'response.write(queryString)
                    rs2.Open queryString
					
				elseif user_type = "Tutor" Then
					queryString = "insert into Tutor (UserName, L_Name, F_Name, PhoneNo,M_Hours,U_Hours,Email) values('" & user_name & "','EMPTY','EMPTY' ,'EMPTY',0,0, '" & user_email & "')"

					rs2.Open queryString

                    queryString = "exec dbo.AddNewTutorTimes @UserName = '"&user_name & "'"
					rs2.Open queryString
					
					'Update Date,add query
			         queryString = "Update AdditionalInformation set DateRegistered = '" &Date &"' where Username = '"& user_name &"' "
					 rs2.Open queryString


				End If
				dim bodyOfmail
				bodyOfmail = "You have been added to the ASC Tutor Scheduling Website.<br />"
				bodyOfmail = bodyOfmail & "Your username is: " & user_name & "<br />and your password is: " & normal_user_pass
				Email user_email, "New user", bodyOfmail

			Else
				Response.write("<div class='alert alert-error'>Duplicate Username, please try again.</div>")

			End If
			
			
			
		End If	
			
		%>

      	<hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
	</div><!--/well-->
    </div> <!-- /container -->
    
<script>
//Function to make sure form is filled out
function validateForm()
{
	var username=document.forms["addForm"]["username"].value;
	var password=document.forms["addForm"]["password"].value;
	var email=document.forms["addForm"]["user_email"].value;
	if (username==null || username=="" || password==null || password=="" || email==null || email=="")
	{
	  	alert("Please enter a username, password, and email.");
	  	return false;
    }
    
    var atpos = email.indexOf("@");
    var dotpos = email.lastIndexOf(".");
    if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
        alert("Not a valid e-mail address");
        return false;
    }

    //checks if they entered illegal characters
    var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "%", "*/", "@@"];
    length = substrings.length;
    while (length--) {
        if (username.indexOf(substrings[length]) !== -1 || password.indexOf(substrings[length]) !== -1 || email.indexOf(substrings[length]) !== -1) {
            alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
            return false;
        }
    }
}

function insertEmail()
{
	document.forms["addForm"]["user_email"].value = document.forms["addForm"]["username"].value + "@winthrop.edu";
}
</script>

</body>
</html>