<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
<!--#include file="../includes/navbar-tutor.asp"-->
<div class="container">

<% 
EstablishDBCON rstutorcourses,conforcourses
'change to request cookie
UserName = Request.Cookies("user")("username")
'UserName = "tutor1"

 If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
    pass = false
    CourseSelected = Request.Form("Course")
    'Response.write("We got to post")
    'Response.write("Post gave us"&CourseSelected&"<br />")

    if len(CourseSelected)> 3 then
        sqlString = "Select * from TutorCourses where UserName = '"&UserName&"' and Course='" & CourseSelected &"'"
        rstutorcourses.open sqlString

        if rstutorcourses.eof = true then
            pass = true
        end if

        rstutorcourses.close

        if pass = true then
            sqlString = "exec AddCourseTutor  @UserName = '"&UserName&"', @Course = '" & CourseSelected &"'"
            rstutorcourses.open sqlString
            response.write ("<div class='alert alert-success'>Sucessfully added "&CourseSelected&" </div> <br />")
        else
            Response.write("<div class='alert alert-error'>Unable to add "&CourseSelected&" because you already are tutoring it. </div><br />")
        end if
    else
        Response.write("<div class='alert alert-error'>Unable to add course because you did not select one. alert red</div>")
    end if'valiate string input


 end if

 'procedure
 'display courses for a tutor
 'select * from TutorCourses where UserName = @UserName

 sqlString ="exec dbo.ShowTutorCourses @UserName = '"&UserName&"' "
 rstutorcourses.open sqlString

if rstutorcourses.eof = false then
    Response.write("<div class='well'><h4>You are tutoring the following courses:</h4></div><ul style='padding-left: 7em;'>")
    do until rstutorcourses.eof
        Course= rstutorcourses("Course")    
        
        Response.write("<li>" & Course & "</li>")

        rstutorcourses.movenext
    loop
    Response.write("</ul>")
else
    Response.write("<div class='alert alert-error'>No courses currently being tutored</div>")
end if
 'select course from course

 %>
 <form name="CourseForm" class="form-horizontal" action="add-course.asp" method="POST">
       
<div class="well"><h4>Select which courses you would like to add to your tutoring list and click submit.</h4></div>
       	<div class="control-group">
	       	<label class="control-label" for="Course">Course</label>
	       	<div class="controls">  
				<select  id='Course' name='Course' onchange='showCourse(this.value)'>
					<option selected disabled>Select a course here.</option>
					
					<%
					'query
					'select * from Course 
					rstutorcourses.close
					sqlString =  "exec dbo.CoursesNotTutored @UserName = '"&UserName&"'"
					rstutorcourses.open sqlString
					
					do until rstutorcourses.eof
					
					    course= rstutorcourses("Course")
					    
					    Response.Write("<option>" & course & "</option>")
					
					    rstutorcourses.movenext
					loop
					%>				
				</select>
			</div></div>
<div id="results" class="well" style="margin:0 0 0 8em;">Course info will be shown here.</div>

<div class="form-actions">
        		<script>
        		    document.write("<a href='add-course.asp'><button class='btn btn-primary'>Add course</button></a>");
        		</script>
        		<a href="default.asp" class="btn btn-inverse">Back</a>
			</div>

</form>

<script>
    function showCourse(str) {
        var xmlhttp;
        if (str == "") {
            document.getElementById("results").innerHTML = "";
            return;
        }
        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else {
            // code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("results").innerHTML = xmlhttp.responseText;
            }
        }
        xmlhttp.open("GET", "displaycourseinfo.asp?q=" + str, true);
        xmlhttp.send();
    }
	</script>



  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
 </div>
</body>
</html>