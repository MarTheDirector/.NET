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
	<form action=""> 
		<h2>Please select a user to view their information</h2>
		<select name="customers" onchange="showUser(this.value)">
			<option value="">Select a user:</option>
			<%
			EstablishDBCON rsforadmin,conforadmin
			
			sql="SELECT UserName FROM Users"
			
			rsforadmin.Open sql,conforadmin
			
			do until rsforadmin.EOF
					For Each item In rsforadmin.Fields
							Response.Write("<option value=" &item&">" & item & "</option>")
					Next
							rsforadmin.MoveNext
			loop
			 %>
		</select>
	</form>
	<a href="default.asp" class="btn btn-inverse">Go Back</a>
	<br /><br />
	
	<div id="txtHint">Student info will be listed here...</div>
	
	<script>
	    function showUser(str) {
	        var xmlhttp;
	        if (str == "") {
	            document.getElementById("txtHint").innerHTML = "";
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
	                document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
	            }
	        }
	        xmlhttp.open("GET", "display-info-in-table.asp?q=" + str, true);
	        xmlhttp.send();
	    }
	</script>
	
	<hr>
	<footer>
	    <!--#include file="../includes/footer.asp"-->
	</footer>
	</div> <!-- /well -->
</div> <!-- /container -->
</body>
</html>