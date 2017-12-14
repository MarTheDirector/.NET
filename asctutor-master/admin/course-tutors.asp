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

        <h2> Select a course to view its tutors. </h2>
        <hr style="margin: 0 0 1em 0;"/>

        <select name="tutors" onchange="showUser(this.value)">
			        <option value="">Select a course:</option>
        <% 
        EstablishDBCON rsforadmin,conforadmin

        sql="SELECT Course FROM Course ORDER BY Course"
			
			        rsforadmin.Open sql,conforadmin
			
			        do until rsforadmin.EOF
					                Courses = rsforadmin("Course")
							        Response.Write("<option value="&Courses&">"&Courses &"</option>")
					        		rsforadmin.MoveNext
			        loop

            rsforadmin.close

        %>
        </select>

	<br /><br />
 
            <div id="results2"> Course's tutors will be shown here </div>

                      <script>
                          function showUser(str) {
                              var xmlhttp;
                             
                              if (str == "") {
                                  document.getElementById("results2").innerHTML = "Course's tutors will be shown here";
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
                              xmlhttp.open("GET", "ajax-course-tutors.asp?q=" + str, true);
                              xmlhttp.send();


                          }

                        

	                </script>
<hr>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  
    </div>
</div>
      

</body>
</html>
