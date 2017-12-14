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

    <%
        EstablishDBCON rs4,con4
        Dim QString
        	
        If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then

            QString = "SELECT * FROM Course WHERE Course= '" & Request.Form("CRN") & "'; "
            rs4.Open(QString)

            if rs4.EOF Then
                QString = "insert into Course (Course,Title,Instructor,Section,Location,Time,Days) values('" & Request.Form("CRN") & "', '" & Request.Form("Title") & "', '" & Request.Form("Instructor") & "', '" & Request.Form("Section") & "', '" & Request.Form("Location") & "', '" & Request.Form("Time") & "', '" & Request.Form("Days") & "')"
                'Consider procedure
                'sql= "exec dbo.insertnewcourse @Course = '"& Request.Form("CRN") & "', @Title = '"& Request.Form("Title") & "', @Instructor = '"& Request.Form("Instructor") & "', @Section = '"& Request.Form("Section") & "', @Location = '"& Request.Form("Location") & "', @Time = '"& Request.Form("Time") & "', @Days = '"& Request.Form("Days") & "'"
                rs4.Close()
                rs4.Open(QString)
                Response.Write("<div class='alert alert-success'>CRN " & Request.Form("CRN") & " Successfully Added!</div>")
            Else
                Response.Write("<div class='alert alert-error'>CRN " & Request.Form("CRN") & " Already Exists!</div>")
            End If
        End If
            
     %>


    <div class="container">
        <h2>Add a new CRN</h2>
        <form class="form-horizontal" name="addCourse" action="add-course.asp"  onsubmit="return validateForm()" method="post"> 
        	<div class="control-group">
        	    <label class="control-label" for="CRN">CRN</label>
        	    <div class="controls">
        	        <input class="input-mini" name="CRN" maxlength="5" id="CRN" required autofocus type="text" placeholder="11111">
        	    </div>
        	</div>
        	<div class="control-group">
        	    <label class="control-label" for="Title">Course Title</label>
        	    <div class="controls">
        	        <input name="Title" id="Title" required type="text" placeholder="HMXP 102">
        	    </div>
        	</div>
        	<div class="control-group">
        	    <label class="control-label" for="Section">Course Section</label>
        	    <div class="controls">
        	        <input class="input-mini" maxlength="3" name="Section" id="Section" required type="text" placeholder="001">
        	    </div>
        	</div>
        	<div class="control-group">
        	    <label class="control-label" for="Location">Location</label>
        	    <div class="controls">
        	        <input name="Location" id="Location" required type="text" placeholder="KINA 302">
        	    </div>
        	</div>
        	<div class="control-group">
        	    <label class="control-label" for="Instructor">Instructor</label>
        	    <div class="controls">
        	        <input name="Instructor" id="Instructor" required type="text" placeholder="Smith, John">
        	    </div>
        	</div>
        	<div class="control-group">
        	    <label class="control-label" for="CRN">Time</label>
        	    <div class="controls">
        	        <input name="Time" id="Time" required data-required="true" type="text" placeholder="12:30 - 01:45 PM">
        	    </div>
        	</div>
        	<div class="control-group">
        	    <label class="control-label" for="Days">Days</label>
        	    <div class="controls">
        	        <input class="input-mini" name="Days" maxlength="3" id="Days" required type="text" placeholder="MWF">
        	    </div>
        	</div>

        	<div class="form-actions">
        	    <script>
        	        document.write("<button type='submit' class='btn btn-primary'>Add Single CRN</button>");
        	    </script>
        	    <a href="default.asp" class="btn btn-inverse">Back</a>        	
        	</div>
        </form>
        <!--#include file="../includes/footer.asp"-->
	</div>

<script>
//Function to make sure form is filled out
function validateForm()
{
	var CRN=document.forms["addForm"]["CRN"].value;
	var Title=document.forms["addForm"]["Title"].value;
	var Instructor=document.forms["addForm"]["Instructor"].value;
	var Section=document.forms["addForm"]["Section"].value;
	var Location=document.forms["addForm"]["Location"].value;
	var Time=document.forms["addForm"]["Time"].value;
	var Days=document.forms["addForm"]["Days"].value;
	if (CRN==null || CRN=="" || Title==null || Title=="" || Instructor==null || Instructor=="" || Section==null || Section=="" || Location==null || Location=="" || Time==null || Time=="" || Days==null || Days=="")
	{
	  	alert("Please complete all fields.");
	  	return false;
	}
	if(!isInt(CRN))
	{
		alert("Please enter a correct CRN with numbers only")
		return false;
    }
    //checks if they entered illegal characters
    var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "%", "*/", "@@"];
    length = substrings.length;
    while (length--) {
        if (CRN.indexOf(substrings[length]) !== -1 || Title.indexOf(substrings[length]) !== -1 || Instructor.indexOf(substrings[length]) !== -1 || Section.indexOf(substrings[length]) !== -1 || Location.indexOf(substrings[length]) !== -1 || Time.indexOf(substrings[length]) !== -1 || Days.indexOf(substrings[length]) !== -1) {
            alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
            return false;
        }
    }
}
</script>

	
</body>
</html>