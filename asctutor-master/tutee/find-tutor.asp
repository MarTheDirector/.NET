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
    <% 
    findTutor = "findTutor"
    LockPage(findTutor)
    %>

	<div class="container">
		<div class="alert alert-info">
			<h4>Please pick which class you want to find a tutor for.</h4>
		</div>
		<form class="form-horizontal" action="find-tutor-p2.asp" name="courseForm" onsubmit="return validateForm()" method="post">
            <%
            Dim Courses, queryString, testvar, testvar2, PassedCourse
            EstablishDBCON rstutorcourses, concourses
            EstablishDBCON rstutorcourses2, concourses2
            
            
            UserName = Request.Cookies("user")("username")

            Disabled1=""
            Disabled2=""

            'Response.write("<div class='alert alert-caution'>A course is unselectable if you currently already have a tutor in that course. To search for a new tutor for the course you must first drop your current tutor on the View/Drop Tutoring Times page. </div>")
            

            queryString = "select Course1,Course2 FROM Tutee WHERE UserName= '" & UserName & "' "
        	rstutorcourses.Open queryString

            Dim counter
            counter = 1

            do until rstutorcourses.EOF
	        	
                Course1=rstutorcourses("Course1")
                Course2=rstutorcourses("Course2")

                queryString = "exec GetTuteeTutorTimes @UserName = '"&UserName&"'"
                rstutorcourses2.Open queryString
                do until rstutorcourses2.EOF

                if Course1 = rstutorcourses2("Course") then
                Disabled1 = "Disabled"
                elseif Course2 =  rstutorcourses2("Course") then
                Disabled2 = "Disabled"
                end if

                rstutorcourses2.MoveNext
			    loop
                rstutorcourses2.Close

                if Disabled1="Disabled" or Disabled2="Disabled" then
                Response.write("<div class='alert alert-caution'>A course is unselectable if you currently already have a tutor in that course. To search for a tutor for the specific you must fill out the form on this <a href='http://www.winthrop.edu/success/form.aspx?ekfrm=31739'>page. Click here. </a> </div>")
                end if

                    if Course1 <> "EMPTY" then
					Response.Write("<div class='control-group'><div class='controls'><label class='radio'><input type='radio'  name='course' value='" & Course1 & "+"& counter& "'"&Disabled1&">" & Course1 & "</label></div></div>")
                    end if
                    counter = counter +1
                    if Course2 <> "EMPTY" then
                    Response.Write("<div class='control-group'><div class='controls'><label class='radio'><input type='radio'  name='course' value='" & Course2 & "+"& counter& "'"&Disabled2&">" & Course2 & "</label></div></div>")
                    end if
				
				rstutorcourses.MoveNext
			loop
            rstutorcourses.Close
			%>
			<div class="form-actions">
			<script>
			    document.write("<button class='btn btn-primary' type='submit' >Next <i class='icon-chevron-right'></i></button>");
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