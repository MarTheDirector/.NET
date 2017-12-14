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
'Response.write (UserName)


'**********************
'**Dont allow to drop course if tutoring it right now
'Check for this if clause and alert tutor if it happens and tell him to drop it correct way
'$$$$$$$$$$$$$$$$$$$$SWAG$$$$$$$$$$$$$$$$$$$

 If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
    pass = false
    CourseSelected = Request.Form("Course")
    'Response.write("We got to post")
    'Response.write("Post gave us"&CourseSelected&"<br />")

    if len(CourseSelected)> 3 then
        
        sqlString = "Select UserName from Available_Times where UserName ='" &UserName&"' and Course = '" & CourseSelected &"'"
        rstutorcourses.open sqlString

        if rstutorcourses.eof then
            rstutorcourses.close
            sqlString = "Select * from TutorCourses where UserName = '"&UserName&"' and Course='" & CourseSelected &"'"
            ' Response.write(sqlString)
            rstutorcourses.open sqlString

            if rstutorcourses.eof = false then
                pass = true
            end if

            rstutorcourses.close

            if pass = true then
                sqlString = "exec RemoveCourseTutor  @UserName = '"&UserName&"', @Course = '" & CourseSelected &"'"
                rstutorcourses.open sqlString
                response.write ("<div class='alert alert-success'>"&CourseSelected&" successfully removed. </div>")
            else
                Response.write("<div class='alert alert-error'> Unable to remove "&CourseSelected&" because you are not tutoring it. </div><br />")
            end if
        else
            rstutorcourses.close
            Response.write("<div class='alert alert-error'> Unable to remove "&CourseSelected&" because you are tutoring it right now.<br /> Please drop the tutee you are tutoring in the course with the drop tutee page. <br /> Then drop the course from here.</div><br />")
        end if
    else
        Response.write("<div class='alert alert-error'>Unable to remove course because you did not select one. </div>")
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
 rstutorcourses.close
 %>
 <form name="CourseForm" class="form-horizontal" action="drop-course.asp" method="POST">
       
<div class="well"><h4>Select which course you would like to drop from your tutoring list and click submit.</h4></div>
	<div class="control-group">
		<label class="control-label" for="Course">Course</label>
	       	<div class="controls">  
				<select  id='Course' name='Course' onchange='showCourse(this.value)'>
					<option selected disabled>Select a course here.</option>
					<%
					
					'query
					'select * from Course 
					'rstutorcourses.close
					'sqlString = "exec dbo.DisplayAllCourses"
					'rstutorcourses.open sqlString
                    rstutorcourses.open sqlString

				
                    if rstutorcourses.eof = false then
					    do until rstutorcourses.eof
					        course = rstutorcourses("Course")
					        Response.Write("<option>" & course & "</option>")
					        rstutorcourses.movenext
					    loop
					rstutorcourses.close
                    end if
					%>
				</select></div></div>

<div id="results" class="well" style="margin:0 0 0 8em;">Course info will be shown here.</div>

<div class="form-actions">
	<a href='dropcourse.asp'><button class='btn btn-primary'>Remove course</button></a>
    <a href="default.asp" class="btn btn-inverse">Back</a>
</div>

</form>
<footer>
	<!--#include file="../includes/footer.asp"-->
</footer>
  
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
</div>
</body>
</html>