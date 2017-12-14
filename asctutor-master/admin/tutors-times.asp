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
<form name="CourseForm" class="form-horizontal" action="add-courses-for-tutor.asp" onsubmit="return validateForm()" method="POST">     
<br /> Select a tutor to view their current time slots. <br />


<select name="tutors" onchange="showUser(this.value)">
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
 
 <div id="results2"> Tutor's current times will be shown here </div>

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
                  xmlhttp.open("GET", "ajax-display-tutors-times.asp?q=" + str, true);
                  xmlhttp.send();
              }
	</script>


</form>

<a href="default.asp" class="btn btn-inverse">Back</a>

</div>
<hr>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
</body>
</html>
