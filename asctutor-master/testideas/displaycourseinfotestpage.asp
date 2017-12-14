<!DOCTYPE html>
<html>
<head>
<!--#include file="includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>

</head>
<body>
<div class="container">
	
	<form action=""> 
		<h2>Please select a course to view its information</h2>
		<select name="courses" onchange="showCourse(this.value)">
			<option value="">Select a course:</option>
			<%

			EstablishDBCON rsforcourse,conforcourse
			
			sql="SELECT Course FROM Course"
			
			rsforcourse.Open sql,conforcourse
			
			do until rsforadmin.EOF
					For Each item In rsforadmin.Fields
							Response.Write("<option value=" &item&">" & item & "</option>")
					Next
							rsforadmin.MoveNext
			loop
			 %>

		</select>
	</form>
	<a href="../default.asp" class="btn btn-inverse">Go Back</a>
	<br /><br />

	<div id="txtHint">Course info will be listed here...</div>
	
	<script>
	    function showCourse(str) {
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
	        xmlhttp.open("GET", "displaycourseinfo.asp?q=" + str, true);
	        xmlhttp.send();
	    }
	</script>
	
	<hr>
	<footer>
	    <!--#include file="includes/footer.asp"-->
	</footer>
	
</div> <!-- /container -->
</body>
</html>