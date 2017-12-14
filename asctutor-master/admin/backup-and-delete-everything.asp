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
	If (Request.ServerVariables("REQUEST_METHOD")= "POST") Then
		'Delete all the rows from all the tables except Users table's admins
		EstablishDBCON rsForTables,conForTables
		QueryForTables = "exec dbo.DELETEEVERYTHING"
		rsForTables.Open(QueryForTables)
		Response.Write("<div class='alert alert-success'>Everything has been deleted except the admin accounts.</div>")
	End If		
%>

  <h2>Backup and Delete Everything</h2>
  <p>
	  From this page you will be able to backup your database and then reset it, deleting all users except yourself,
	  all courses, all tutor-tutee relationships, essentially everything. It gives the admin a blank slate to start new.<br />
	  <b>Please be certain this is what you want to do before you start this process, as it is a complicated process to "undo" your mistake!</b><br />
  </p>
  <form name="DeleteEverythingForm" class="form-horizontal" action="backup-and-delete-everything.asp" onsubmit="return validateForm()" method="POST">

	<label><input type="checkbox" name="UsersTable" onclick="if(this.checked){OpenWindow('export-users-table.asp')}" /> Backup Users Table</label>
	<label><input type="checkbox" name="TuteesTable" onclick="if(this.checked){OpenWindow('export-tutee-table.asp')}" /> Backup Tutees Table</label>
	<label><input type="checkbox" name="TutorsTable" onclick="if(this.checked){OpenWindow('export-tutor-table.asp')}" /> Backup Tutors Table</label>
	<label><input type="checkbox" name="TutorCoursesTable" onclick="if(this.checked){OpenWindow('export-tutor-courses-table.asp')}" /> Backup Tutor Courses Table</label>
	<label><input type="checkbox" name="AvailableTimesTable" onclick="if(this.checked){OpenWindow('export-available-times-table.asp')}" /> Backup Available_Times Table</label>
	<label><input type="checkbox" name="CoursesTable" onclick="if(this.checked){OpenWindow('export-course-table.asp')}" /> Backup Courses Table</label>


	<div class="form-actions">
    	<script>
        	document.write("<button type='submit' class='btn btn-primary'>Delete Everything</button>");
        </script>
        <a href="default.asp" class="btn btn-inverse">Back</a>
	</div>
 	
  </form>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  
</div>
<script>
function OpenWindow(info) {
  window.open(info,'_blank');
}

function validateForm() {
	if (DeleteEverythingForm.UsersTable.checked == false) {
		alert("Please backup everything (make sure each checkbox is checked) before attempting to delete.");
		return false;
	}
	else if (DeleteEverythingForm.TuteesTable.checked == false) {
		alert("Please backup everything (make sure each checkbox is checked) before attempting to delete.");
		return false;
	}
	else if (DeleteEverythingForm.TutorsTable.checked == false) {
		alert("Please backup everything (make sure each checkbox is checked) before attempting to delete.");
		return false;
	}
	else if (DeleteEverythingForm.TutorCoursesTable.checked == false) {
		alert("Please backup everything (make sure each checkbox is checked) before attempting to delete.");
		return false;
	}
	else if (DeleteEverythingForm.AvailableTimesTable.checked == false) {
		alert("Please backup everything (make sure each checkbox is checked) before attempting to delete.");
		return false;
	}
	else if (DeleteEverythingForm.CoursesTable.checked == false) {
		alert("Please backup everything (make sure each checkbox is checked) before attempting to delete.");
		return false;
	}
	else
	{
		var confirmFlag = false;
		
		var confirmation = confirm("Are you sure you wish to delete everything?");
		if (confirmation == true) {
			confirmFlag = true;
		}
		else {
			return false;
		}
			
		if (confirmFlag == true) {
			var finalConfirmation = confirm("Are you really really sure you wish to delete everything? (this is your final warning!)");
			if (finalConfirmation == true) {
				return true;
			}
			else {
				return false;
			}
		}
	}
}
</script>
</body>
</html>
