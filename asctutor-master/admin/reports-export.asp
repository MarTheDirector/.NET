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

%>

  <h2>Download Reports</h2>
  <p>
	  
  </p>
  
    <div class= "well">
        <h3> Raw Data Reports </h3>
        <hr style="margin: 0 0 1em 0;"/>
	    <a href='export-users-table.asp'> Users Table</a> <br />
	    <a href='export-tutee-table.asp'> Tutees Table</a> <br />
	    <a href='export-tutor-table.asp'> Tutors Table</a> <br />
	    <a href='export-tutor-courses-table.asp'> Tutor Courses Table</a> <br />
	    <a href='export-available-times-table.asp'> Available_Times Table</a> <br />
	    <a href='export-course-table.asp'> Courses Table</a> 
    </div>

    <div class= "well">
        <h3> More Informative Reports </h3>
         <hr style="margin: 0 0 1em 0;"/>
        <a href='export-tutee-report.asp'> Tutees and their Tutors </a><br />
        <a href='export-courses-tutors.asp'> Courses's Tutors </a><br />
    </div>

	<div class="form-actions">
        <a href="default.asp" class="btn btn-inverse">Back</a>
	</div>
 	
  </form>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  
</div>

</body>
</html>
