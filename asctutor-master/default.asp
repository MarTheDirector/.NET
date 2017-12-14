<!DOCTYPE html>
<% response.buffer = true %><html>
<title>
ASC Tutor Scheduling Website</title>
<head>
<!--#include file="includes/header_For_Homepage.asp"-->
<style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type=text], .form-signin input[type=password] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    </style>
</head>
<body>
<!--#include file="includes/navbar-home.asp"-->
<!--#include file="includes/sha256.asp"-->
    <div class="container-fluid" style="padding-top:20px;">
		<%			
			'Tests if username and password portion of cookie exists	
	If  (Request.Cookies("user")("username") <> "") AND (Request.Cookies("user")("password") <> "") Then
	
		'Tests if username portion of cookie is not empty
		If Len(Request.Cookies("user")("username"))>1 Then
		

			EstablishDBCON rs,con2	

		
			queryString = "SELECT * FROM Users WHERE UserName= '" & Request.Cookies("user")("username") & "' "
			rs.Open queryString
			
			'*****************************************************
			'Password Check	
			'*****************************************************
								
				'If Request.Cookies("user")("password") <> sha256(rs("Password") & "xxMc4ppl3saUceBurgerKingxx") Then
				If Request.Cookies("user")("password") <> rs("Password") Then	
                    rs.close
					Response.Redirect "../logout.asp"
				
				ElseIf Request.Cookies("user")("type") = "Admin" Then
					rs.close
					Response.Redirect "admin/default.asp"
                ElseIf Request.Cookies("user")("type") = "Tutee" Then
                    rs.close
                    Response.Redirect "tutee/default.asp"
                ElseIf Request.Cookies("user")("type") = "Tutor" Then
                    rs.close
                    Response.Redirect "tutor/default.asp"					
				End if
		End if
	End if
            
            
            '******************************************************
			'Username Query 
			'******************************************************
			
			If Len(Request.Form("username"))>1 Then
				dim queryString, username
				username = Lcase(Request.Form("username"))
				
				EstablishDBCON rs1,con2	
				GetRecord rs1, "Users", username
				
				'*****************************************************
				'Password Check	
				'*****************************************************
				If rs1.EOF Then
					Response.write("<div class='alert alert-error'>Incorrect Username or Password, please try again.</div>")
				
		        '&Update
                '***************
                '**************
				ElseIf ( sha256(Request.Form("password") & "xxMc4ppl3saUceBurgerKingxx") = rs1("Password")  ) Then
				
					'*************************************************
					'Set Cookie
					'*************************************************

					Response.Cookies("user")("username") = rs1("UserName")					
					Response.Cookies("user")("password") = rs1("Password") 
					Response.Cookies("user")("signout") = "in"
					Response.Cookies("user")("type") = rs1("Type")
					
					'*************************************************
					'Page Redirects
					'*************************************************
					
					'Tutor page redirect
					If rs1.Fields.Item(2) = "Tutor" Then
						Response.Redirect "tutor/default.asp"
					End If
					
					'Tutee page redirect
					If rs1.Fields.Item(2) = "Tutee" Then
						Response.Redirect "tutee/default.asp"
					End If
					
					'Admin Portal redirect
					If rs1.Fields.Item(2) = "Admin" Then
						Response.Redirect "admin/default.asp"
					End If
				Else
					Response.write("<div class='alert alert-error'>Incorrect Username or Password, please try again.</div>")
					
				End If				
			End If
		%>

        
        <h2 style="text-align:center;"> Academic Success Center Tutor Scheduling Portal</h2>
        <form class="form-signin" name="LoginForm" action="default.asp" onsubmit="return validateForm()" method="post">
        	<script>
        		document.write("<h2 class='form-signin-heading'>Please Sign in</h2>");
        		document.write("<input type='text' class='input-block-level' placeholder='username' required name='username'>");
        		document.write('<input type="password" class="input-block-level" placeholder="password" required name="password">');
        		document.write("<button class='btn btn-large btn-primary' type='submit'>Sign in</button>");
        		document.write('&nbsp;&nbsp;<a class="pull-right" href="forgot-password.asp">Forgot Password?</a>');
        	</script>
        <noscript>
            <h3>To use this site it is necessary to enable JavaScript.<br />
            <a href="http://www.enable-javascript.com/" target="_blank">
            Click Here For Instructions on how to enable JavaScript</a></h3>
        </noscript>
        </form>
        <script>
        function are_cookies_enabled()
		{
			var cookieEnabled = (navigator.cookieEnabled) ? true : false;
		
			if (typeof navigator.cookieEnabled == "undefined" && !cookieEnabled)
			{ 
				document.cookie="testcookie";
				cookieEnabled = (document.cookie.indexOf("testcookie") != -1) ? true : false;
			}
			return (cookieEnabled);
		}
        if(!are_cookies_enabled())
        {
        	document.write("<p class='lead' style=\"text-align:center;\">This site uses cookies, please <a href=\"http:\/\/support.google.com\/accounts\/bin\/answer.py?hl=en&answer=61416\" target=\"_blank\">enable them<\/a> or you will not be able to log in.<\/p>");
        }
        </script>
   

      <hr>
      <footer>
<%
'<span class="icon-spin" style="color:Green; font-size:3em;">$</span>
'<span class="icon-spin" style="color:Green; font-size:3em;">$</span>
	If (Request.ServerVariables("REQUEST_METHOD")= "POST") AND (Request.Form("email") <> "")  Then
	Dim Subject, Body

    if Request.Form("otherTyped") <> "" Then
	    Subject = Request.Form("email") & " :  " &Request.Form("problemType") & " : " & Request.Form("otherTyped")
    else
        Subject = Request.Form("email") & " :  " &Request.Form("problemType")
    end if

	Body = Request.Form("comments")
	Email "myasctutortest@gmail.com", Subject,Body
	End If
%>

ASC Tutoring&nbsp;&#124;
<!-- Link to trigger Problem Contact Form -->
<a href="#myModal" data-toggle="modal">Having Trouble?</a>&nbsp;&#124;
<a href="#myModal" data-toggle="modal">Contact Us</a>&nbsp;&#124;
<a href="forgot-password.asp">Forgot Password?</a>
 
<!-- Modal -->
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <form name="problemForm" action="" onsubmit="return validateHavingTroubleForm()" method="post">
      <div class="modal-body">
        <fieldset>
	        <legend>What's Your Problem?</legend>
	        <label>Type of Problem:</label>
	        <select name="problemType" onchange="otherForm(this.options[this.selectedIndex].value)">
		        <option value="LoginIssues">Issues logging in (besides forgotten password)</option>
		        <option value="NoLoginGiven">I was never given a username</option>
		        <option value="ReportBug">Report problem with website</option>
		        <option value="Other">Other...please enter below</option>
	        </select>
	        <div id="otherdiv"></div>
	        <label>Your Email:</label>
	        <input required="required" type="email" name="email"><br />
	        <label>Additional Comments:</label>
	        <textarea name="comments" cols="5" rows="5"></textarea>        
        </fieldset>
      </div>
      <div class="modal-footer">
        <button class="btn btn-inverse"data-dismiss="modal" aria-hidden="true">Back</button>
        <button class="btn btn-primary" type="submit">Submit</button>
      </div>
  </form>
</div>
<!--Script for Modal to make the "Other" input box show up when selected-->
<script>
    function otherForm(name) {
        if (name == 'Other') document.getElementById('otherdiv').innerHTML = '<label>Other</label><input type="text" required name="otherTyped" />';
        else document.getElementById('otherdiv').innerHTML = '';
    }
    function validateHavingTroubleForm() {
        //First check email
        var x = document.forms["problemForm"]["email"].value;
        if (x == null || x == "") {
            alert("Please enter an email");
            return false;
        }
        var atpos = x.indexOf("@");
        var dotpos = x.lastIndexOf(".");
        if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
            alert("Not a valid e-mail address");
            return false;
        }
        var z = document.forms["problemForm"]["otherTyped"].value;
            if (z == null || z == "") {
                alert("Please enter your problem in the 'Other' box");
                return false;
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
</footer>
</div>
<script>
//Function to make sure form is filled out
function validateForm()
{
	var x=document.forms["LoginForm"]["username"].value;
	var y=document.forms["LoginForm"]["password"].value;
	if (x==null || x=="" || y==null || y=="")
	{
	  	alert("Please enter both a username and password.");
	  	return false;
    }
    //checks if they entered illegal characters
	var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "%", "*/", "@@"];
    length = substrings.length;
	while (length--) {
	    if (x.indexOf(substrings[length]) !== -1 || y.indexOf(substrings[length]) !== -1) {
	        alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
	        return false;
	    }
	}
}
</script>
</body>
</html>