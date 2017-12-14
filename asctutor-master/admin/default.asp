<!DOCTYPE html>
<html>
    <head>
        <!--#include file="../includes/header.asp"-->
        <title>ASC Tutor Scheduling Website</title>
        <!--
             Name:  ASC Tutor Schedule Portal Home Page
             Written By:  Unknown
             Updated By:  Ethan Hanner, Marcus Nesbitt, Courtney Stokes, Tara Slabich
             System:  Part of the ASC Tutor Schedule Portal Website  
             Created: Unknown
             Updated: Spring 2015
             Purpose: Providers an interface for users to access various parts of the system.  
             How:  The HTML script includes links to access the files for various modules.     
        -->
</head>
<body>
	<!--#include file="../includes/navbar-admin-home.asp"-->

    <div class="container">
        <%Response.write("<h1>Welcome, " & Request.Cookies("user")("username") & "</h1>") %>
        
        <div class= "well">
			<h3>User Management</h3>
			<hr style="margin: 0 0 1em 0;">
			<p class="lead">
				<a href="register-new-user.asp">Register a new user</a><br />
				<a href="reset-users-password.asp">Reset a user's password</a><br />
				<a href="delete-user.asp">Delete a user</a><br />
                <a href="lock-page.asp">Lock specific tutor/tutee pages</a><br />
                <a href="find-tutor-for-tutee-p1.asp">Find tutor for tutee</a>
			</p>
		</div>
		<!--
        <div class= "well">
			<h3>Testing</h3>
			<hr style="margin: 0 0 1em 0;">
			<p class="lead">
				<a href="find-tutor-for-tutee-p1.asp">Find tutor for tutee</a>
			</p>
		</div>
        -->

		<div class= "well">
			<h3>Course Management</h3>
			<hr style="margin: 0 0 1em 0;">
			<p class="lead">
				<a href="add-course.asp">Add new available courses</a><br />
				<a href="delete-course.asp">Delete a course</a><br />
				<a href="add-courses-for-tutor.asp">Allow a tutor to tutor a course</a><br />
				<a href="drop-courses-for-tutor.asp">Unallow a tutor from tutoring a course</a><br />
                <a href="drop-tutees.asp">Drop tutees</a><br />
                <a href="form.asp">Update all available courses (from Excel .csv file)</a>
			</p>
		</div>
		
		<div class= "well">
			<h3>Information Lookup</h3>
			<hr style="margin: 0 0 1em 0;">
			<p class="lead">
				<a href="view-info.asp">View any user's information</a><br />
				<a href="view-tutee-info.asp">View any tutee's information</a><br />
				<a href="view-tutor-info.asp">View any tutor's information</a><br />
                <a href="course-tutors.asp">View a course's tutors</a><br />
                <a href="tutors-times.asp">View a tutor's current times and in use times</a><br />
                <a href="dropped-tutees.asp">View all dropped tutees</a><br />     
                <a href="tutees-with-same.asp">View all tutees who selected same course twice</a><br />   
                <a href="report.asp">View Reports</a>
            </p>
       </div>        
		<div class= "well">	
            <h3>Database Tools</h3>
            <hr style="margin: 0 0 1em 0;">
            <p class="lead">
                <a href="reports-export.asp">Export Reports without having to delete everything</a> <br />
                <a href="reset-avail-times.asp">Reset all times for tutees and tutors</a> <br />
                <a href="backup-and-delete-everything.asp">Backup and delete everything</a><br />
		    </p>
        </div>  

      <hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
    </div> <!-- /container -->
</body>
</html>