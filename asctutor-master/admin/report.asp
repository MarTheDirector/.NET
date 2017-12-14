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
    EstablishDBCON rsTutee,conTutee
    EstablishDBCON rsTutor,conTutor

    dim tutee,tutor
    tutee = 0
    tutor = 0

    rsTutee.open "Exec dbo.GetTuteeNumber"
    rsTutor.open "Exec dbo.GetTutorNumber"

    do until rsTutee.EOF
        tutee = tutee + 1
        rsTutee.movenext
    Loop

    do until rsTutor.EOF
        tutor = tutor + 1
        rsTutor.movenext
    Loop

  Response.Write("<h2>Reports<br /></h2><h4>Tutees: "& tutee &" Tutors: "& tutor &"</h4>")
  %>
  <div class="well">
	  <p class="lead">
		  <a href="tutees-without-tutors.asp">List of Tutees without a Tutor</a><br />
	      <a href="tutors-without-tutees.asp">List of Tutors without a Tutee</a><br />
	  </p>
  </div>

	<a href="default.asp" class="btn btn-inverse">Back</a>

  <hr>	
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  
</div>
</body>
</html>
