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
        <div class= "well">
    <form name="resetForm" class="form-horizontal" action="reset-avail-times.asp"  method="POST">   
    <% 
     If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
        EstablishDBCON rsResetTimes,conResetTimes

       Pass = sha256(Request.Form("currPass") & "xxMc4ppl3saUceBurgerKingxx")
        ' = rs1("Password")

       If Len(Request.Form("currPass"))>1 Then
            UserName = Request.Cookies("user")("username")
            sqlString = "SELECT Password FROM Users WHERE UserName= '"&UserName&"'"
            rsResetTimes.open sqlString
            SuccessPass = rsResetTimes("Password")
            rsResetTimes.close
            if Pass = SuccessPass then
                sqlString = "exec dbo.resetAvailTimes"
                rsResetTimes.open sqlString
                sqlString = "exec dbo.resetTuteeCourses"
                rsResetTimes.open sqlString
                Response.write("<div class='alert alert-success'>You successfully reset all tutor and tutee times.</div>")
            else   
                Response.write("<div class='alert alert-error'>Password does not match.</div>") 
            end if

        else
             Response.write("<div class='alert alert-error'>Nothing was entered.</div>")  
        end if

    end if
     %>

     <div class="control-group">
         <p class="lead">
        		Type your current password to confirm reseting the times for all tutees and tutors.
        		<div class="controls">
        			<input name="currPass" id="curr" required autofocus type="password"><br />
        		</div>
             </p>
        	</div>


     <div class="form-actions">
        <a href="reset-avail-times.asp"><button class="btn btn-primary">Reset Times</button></a>
        <a href="default.asp" class="btn btn-inverse">Back</a>
    
    </div>

    </form>

    </div>
    </div>
      <footer>
        <!--#include file="../includes/footer.asp"-->
    </footer>
		
</body>
</html>