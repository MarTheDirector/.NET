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
<%

EstablishDBCON rstutorcourses,conforcourses

 If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
 
    pass = false
    UserName = request.form("tutors")
    CourseSelected = Request.Form("Courses")
   ' Response.write(UserName&"<br />")
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
            response.write ("<div class='alert alert-success'>Sucessfully added "&CourseSelected&" to "&UserName&"'s course list </div> <br />")
        else
            Response.write("<div class='alert alert-error'>Unable to add "&CourseSelected&" because "&UserName&" is already tutoring it. </div><br />")
        end if
    else
        Response.write("<div class='alert alert-error'>Unable to add course because you did not select one.</div>")
    end if'valiate string input


 end if

 %>

<form name="CourseForm" class="form-horizontal" action="add-courses-for-tutor.asp" onsubmit="return validateForm()" method="POST">     
<br /> Select a tutor and course you would like to add to a tutor's course list and click submit. <br />


<br />Select a tutor to add a class to. <br />
<select name="tutors" id="tutors">
			<option value="">Select a user:</option>
<% 
EstablishDBCON rsforadmin,conforadmin
sql="SELECT UserName FROM Users where type = 'Tutor'"
			
			rsforadmin.Open sql,conforadmin
			
			do until rsforadmin.EOF
					For Each item In rsforadmin.Fields
							Response.Write("<option value="& item &">" & item & "</option>")
					Next
							rsforadmin.MoveNext
			loop
    rsforadmin.close

%>
</select>

	<br /><br />
 
 <div id="results2"> Tutor's current courses will be shown here </div>

          <script>
              function showUser(str) {
                  var xmlhttp;
                  if (str == "") {
                      document.getElementById("results2").innerHTML = "Tutor's courses will be shown here";
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
                          document.getElementById("results2").innerHTML = xmlhttp.responseText;
                      }
                  }
                  xmlhttp.open("GET", "ajax-add-course-for-tutor.asp?q=" + str, true);
                  xmlhttp.send();
              }
	</script>



<br /> Select which courses you would like to add to the tutor's list and click submit. <br />

<select  id='Course' name='Courses' onchange="showCourse(this.value)">

<option selected disabled>Select a course here.</option>
<%
'prehaps a procedure to display all courses based on tutor selection
'can i get tutor selection passed here
'or abandon hope, checkboxes, or multiple selection box
sqlString = "exec dbo.DisplayAllCourses"
rstutorcourses.open sqlString

do until rstutorcourses.eof

    course= rstutorcourses("Course")
    
    Response.Write("<option>" & course & "</option>")

    rstutorcourses.movenext
loop

%>
</select>


<div class="form-actions">
   <a href="add-courses-for-tutor.asp"><button class="btn btn-primary">Add course</button></a>
    <a href="default.asp" class="btn btn-inverse">Back</a>
</div>
</form>

         <div id = "results">Course info will be shown here.</div>


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
                 xmlhttp.open("GET", "../tutor/displaycourseinfo.asp?q=" + str, true);
                 xmlhttp.send();
             }
	</script>


  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
</body>
</html>
