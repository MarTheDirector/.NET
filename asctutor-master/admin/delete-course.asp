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
        <h2>Remove a course</h2>
        <%
		
		
		If Len(Request.Form("Course"))>1 Then
			EstablishDBCON rs3,con3
			EstablishDBCON rsExistCheck,conExistCheck
			dim Course
			Course = Request.Form("Course")
			queryString = "DELETE FROM Course WHERE Course='" & Course & "'"
			queryString1 = "Select * From Available_Times Where [Course] = '" & Course & "'"
			rsExistCheck.Open queryString1
			
			if rsExistCheck.EOF Then
				rs3.Open queryString
				Response.Write("<div class='alert alert-success'>Course " & Course & " Successfully Deleted!</div>")
			Else
				Response.Write("<div class='alert alert-error'>Course " & Course & " Delete Failed-Someone is registered for it!</div>")

			End If
						
		End If
		%>
        <form class="form-horizontal" action="delete-course.asp" method="post" onsubmit="return confirmSubmit()">
			<div class="control-group">
	        	<label class="control-label">Course to remove</label>
	        	<div class="controls">
	        	<select name="Course">
	        	<%
	        	EstablishDBCON rs2,con2
	        	
	        	queryString = "SELECT Course FROM Course"
	        	
	        	rs2.Open queryString     	
	        	
	        	do until rs2.EOF
		        	For Each item In rs2.Fields
						Response.Write("<option>" & item & "</option>")
					Next
					rs2.MoveNext
				loop
				
				%>
	        	</select>
        	</div>
        	</div>
        	<div class="form-actions">
        	<script>
        	document.write("<button type='submit' class='btn btn-primary'>Remove Course</button>");
        	</script>
        	<a href="default.asp" class="btn btn-inverse">Back</a>  
        	</div>
        </form>

      	<hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

    </div> <!-- /container -->
<script>
function confirmSubmit()
{
var agree=confirm("Are you sure you wish to delete this course?");
if (agree)
	return true ;
else
	return false ;
}
</script>
</body>
</html>