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
<div class="well">
    
<%

EstablishDBCON rstutorcourses,conforcourses
EstablishDBCON rstutorcoursesinfo,conforcourses2

 If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
 
    pass = false
    UserName = request.form("tutors")
   if len(UserName) > 3 then
    CourseSelected = Request.Form("courselist[]")
   ' Response.write(UserName&"<br />")
    'Response.write("Post gave us"&CourseSelected&"<br />")
    upperbound= 0

    for each courseSelected in Request.Form("courselist[]")

        upperbound = upperbound+1

        next
    'Response.write(upperbound)
   
    if (upperbound) = 0 then
        Response.write("<div class='alert alert-error'>No courses selected.</div>")   
    else
        'response.write("courses selected")
        
        for each courseSelected in Request.Form("courselist[]")
            sqlString = "Select * from TutorCourses where UserName = '"&UserName&"' and Course='" & CourseSelected &"'"
            rstutorcoursesinfo.open sqlString
            if rstutorcoursesinfo.eof=true then
                'insert statement to course   
                rstutorcoursesinfo.close
                sqlString = "exec AddCourseTutor  @UserName = '"&UserName&"', @Course = '" & CourseSelected &"'"         
                'success added course
                rstutorcoursesinfo.open sqlString
                Response.write("<div class='alert alert-success'>Successfully added course "&courseselected&".</div>")  
            else
                Response.write("<div class='alert alert-error'>Unable to add course "&courseselected&" because it is already being tutored by "&UserName&".</div>")   
                rstutorcoursesinfo.close
            end if
          
        next
    end if'upperbound

   ' for each courseSelected in Request.Form("courselist[]")

    'if len(CourseSelected)> 3 then
       ' sqlString = "Select * from TutorCourses where UserName = '"&UserName&"' and Course='" & CourseSelected &"'"
       ' rstutorcourses.open sqlString

       ' if rstutorcourses.eof = true then
         '   pass = true
        'end if

       ' rstutorcourses.close

       ' if pass = true then
          '  sqlString = "exec AddCourseTutor  @UserName = '"&UserName&"', @Course = '" & CourseSelected &"'"
         '   rstutorcourses.open sqlString
        '    response.write ("<div class='alert alert-success'>Sucessfully added "&CourseSelected&" to "&UserName&"'s course list </div> <br />")
       ' else
      '      Response.write("<div class='alert alert-error'>Unable to add "&CourseSelected&" because "&UserName&" is already tutoring it. </div><br />")
     '   end if
    'else
    '    Response.write("<div class='alert alert-error'>Unable to add course because you did not select one.</div>")
   ' end if'valiate string input

    else
        Response.write("<div class='alert alert-error'>No tutor selected.</div>")   
    end if 'tutorselected?
 end if 'post

 %>

<form name="CourseForm" class="form-horizontal" action="add-courses-for-tutor.asp" onsubmit="return validateForm()" method="POST">     
<br /> Select a tutor and course you would like to add to a tutor's course list and click submit. <br />


<br />Select a tutor to add a class to. <br />
        <select  name='tutors' id="tutors" > 
			<option value="">Select a user:</option>
                <% 
                EstablishDBCON rsforadmin,conforadmin
                sql="SELECT UserName FROM Users where type = 'Tutor'"
			
			                rsforadmin.Open sql,conforadmin
			
			                do until rsforadmin.EOF
					                For Each item In rsforadmin.Fields
							                Response.Write("<option value=" &item&">" & item & "</option>")
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


<%
'<select  id='Course' name='Courses' onchange="showCourse(this.value)">

'<option selected disabled>Select a course here.</option>

'prehaps a procedure to display all courses based on tutor selection
'can i get tutor selection passed here
'or abandon hope, checkboxes, or multiple selection box
sqlString = "exec dbo.DisplayAllCoursesInfo"
rstutorcoursesinfo.open sqlString

        response.Write("<table class='table table-bordered'>")
        response.Write("<tr>")
        response.Write("<td colspan='7' style='text-align:center;'>" & "<b>Course Information</b>" & "</th>")
        response.Write("</tr>")
        response.Write("<tr>")
        response.Write("<td><b>Assign</b></td>")
        response.Write("<td><b>Course</b></td>")
        response.Write("<td><b>Title</b></td>")
        response.Write("<td><b>Section</b></td>")
        response.Write("<td><b>Instructor</b></td>")
        response.Write("<td><b>Times</b></td>")
        response.Write("<td><b>Days</b></td>")
        response.Write("<td><b>Room</b></td>")
        response.Write("</tr>")

do until rstutorcoursesinfo.eof
    
    'rstutorcoursesinfo.open sqlString
                course= rstutorcoursesinfo("Course")
                Title = rstutorcoursesinfo("Title")
                Instructor = rstutorcoursesinfo("Instructor")
                Section = rstutorcoursesinfo("Section")
                Location = rstutorcoursesinfo("Location")
                Times = rstutorcoursesinfo("Time")
                Days = rstutorcoursesinfo("Days")
               
                response.Write("<tr>")
                Response.Write("<td><input type='checkbox' name='courselist[]' value='"&course&"'></td>")
                Response.Write("<td>"&Course&"</td>")
                Response.Write("<td>"&Title&"</td>")
                Response.Write("<td>"&Section&"</td>")
                Response.Write("<td>"&Instructor&"</td>")
                Response.Write("<td>"&Times&"</td>")  
                Response.Write("<td>"&Days&"</td>")
                Response.Write("<td>"&Location&"</td>")

                response.Write("</tr>")
    

    rstutorcoursesinfo.movenext
loop
    response.write("</table>")
%>



<div class="form-actions">
   <a href="add-courses-for-tutor.asp"><button class="btn btn-primary">Add course</button></a>
    <a href="default.asp" class="btn btn-inverse">Back</a>
</div>
</form>

</div>         


  <footer>
      <!--#include file="../includes/combobox.asp"-->
     
      <script>


           $("#tutors").change(function()
        {
            
            var id=$(this).find('option:selected').val();
            var dataString = 'q='+ id;   

            $.ajax
            ({
                    type: "GET",
                    url: "ajax-add-course-for-tutor.asp",
                   data: dataString,
                    cache: false,
                success: function(html)
                {
                    $("#results2").html(html);
                } 
            });

        });

      </script>

        <!--#include file="../includes/footer.asp"-->
  </footer>
    </div>
</body>
    
</html>
