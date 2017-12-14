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
        <h2>Delete a User</h2>
        
		<%
        ' *************************************************
        '                   DELETE USER 
        ' *************************************************
		If (Request.ServerVariables("REQUEST_METHOD")= "POST") AND (Request.Form("username") <> "")  Then
            
			dim username

			username = Request.Form("username") ' retrieve username
            safe_drop_person Username ' Delete user
           
			Response.Write("<div class='alert alert-success'>User " & username & " Successfully Deleted!</div>")
		End If
		%>

        <form action="delete-user.asp" class="form-horizontal" name="addForm" onsubmit="return confirmSubmit()" method="post">
        <div class="control-group">
        	<label class="control-label">username</label>
        	<div class="controls">
        	<select name="username">
        	
        	 <%
        	'ERROR IS SOMEHWERE IN HERE
        	EstablishDBCON rs2,con2
        	
        	'Do a query to grab all users into rs
        	queryString = "SELECT UserName FROM Users"
        	
        	rs2.Open queryString
        	
        	
        	do until rs2.EOF
	        	For Each item In rs2.Fields
	        	
	        			if item <> Request.Cookies("user")("username") then
                        Response.Write("<option>" & item & "</option>")
                        End If
 
				Next
				 rs2.MoveNext
			loop
			%>
        	</select><br />
        	</div>
 			</div>
 			<div class="form-actions">
        	<script>
        	document.write("<button type='submit' class='btn btn-primary'>Delete User</button>");
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
var agree=confirm("Are you sure you wish to delete this user?");
if (agree)
	return true ;
else
	return false ;
}
</script>    
</body>
</html>