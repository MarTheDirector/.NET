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
	<form class="form-horizontal" action="find-tutor-for-tutee-p2.asp" name="courseForm"  method="post">

		<h2>Please select the tutee you wish to find a tutor for </h2>
		<select name="customers" onchange="showUser(this.value)">
			<option value="">Select a user:</option>
			<%
			EstablishDBCON rsforadmin,conforadmin
			
			sql="SELECT UserName FROM Tutee"
			
			rsforadmin.Open sql,conforadmin
			
			do until rsforadmin.EOF
					For Each item In rsforadmin.Fields
							Response.Write("<option value=" &item&">" & item & "</option>")
					Next
							rsforadmin.MoveNext
			loop
			 %>
		</select>
	
	<br /> <br />
	<a href="default.asp" class="btn btn-inverse">Go Back</a>
	<button a href="find-tutor-for-tutee-p2.asp" class='btn btn-primary' type='submit' >Next <i class='icon-chevron-right'></i></button>
	<br /><br />
	
	</form>
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
	</div>
	<hr>
	<footer>
	    <!--#include file="../includes/footer.asp"-->
	</footer>
	
</div> <!-- /container -->
</body>
</html>