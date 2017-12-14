<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
	<!--#include file="../includes/navbar-tutee.asp"-->

	<div class="container">
		<div class="alert alert-info">
			<h4>Please pick which class you want to find a tutor for.</h4>
		</div>
		<form class="form-horizontal" action="mfind-tutor-p2.asp" name="courseForm" onsubmit="return validateForm()" method="post">
            <%
            EstablishDBCON rstutorcourses, concourses
            Dim Courses, queryString, testvar, testvar2, PassedCourse
            
            UserName = Request.Cookies("user")("username")

            queryString = "select Tutor1,Tutor2 from Tutee where UserName = '" & UserName & " '"
            rstutorcourses.Open queryString

            Tutor1 = rstutorcourses("Tutor1")
            Tutor2 = rstutorcourses("Tutor2")

            if Tutor1 <> "EMPTY"  or Tutor2 <> "EMPTY" then

            Response.write("<div class='alert alert-error'>One or more of these courses already has a tutor. Proceeding with this process will drop and replace current tutor.</div>")
                end if

            rstutorcourses.Close

            
            queryString = "select Course1,Course2 FROM Tutee WHERE UserName= '" & UserName & "' "
        	
            rstutorcourses.Open queryString

            Dim counter
            counter = 1

            do until rstutorcourses.EOF
	        	For Each item In rstutorcourses.Fields
                    if item <> "" then
					Response.Write("<div class='control-group'><div class='controls'><label class='radio'><input type='radio' checked name='course' value='" & item & "+"& counter& "'>" & item & "</label></div></div>")
                    end if
                    counter = counter +1
				Next
				rstutorcourses.MoveNext
			loop
            rstutorcourses.Close
			%>

			<div class="form-actions">
			<script>
			    document.write("<button class='btn btn-primary' type='submit'>Next <i class='icon-chevron-right'></i></button>");
			</script>
			<a href="default.asp" class="btn btn-inverse">Back</a>
			</div>
			

		</form>
	    
		<hr>    
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

    </div> <!-- /container -->
</body>
</html>