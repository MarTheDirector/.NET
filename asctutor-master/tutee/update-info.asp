<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
	<!--#include file="../includes/navbar-tutee.asp"-->
    <% 
    updateTuteeInfo = "updateTuteeInfo"
    LockPage(updateTuteeInfo)
    %>

    <div class="container">
    	    <div class="well">
        <%
			Dim username,F_Name,L_Name,Phone,myQuery
			username = Request.Cookies("user")("username")
			
            EstablishDBCON rstutorcourses, concourses
            EstablishDBCON rstutorcourses2, concourses2
            queryString = "select Course1,Course2 FROM Tutee WHERE UserName= '" & UserName & "' "
        	rstutorcourses.Open queryString

            Disabled1 = ""
            Disabled2 = ""

            do until rstutorcourses.EOF
	        	
                Course1=rstutorcourses("Course1")
                Course2=rstutorcourses("Course2")

                queryString = "exec GetTuteeTutorTimes @UserName = '"&UserName&"'"
                rstutorcourses2.Open queryString
                do until rstutorcourses2.EOF

                    if Course1 = rstutorcourses2("Course") then
                        Disabled1 = "Disabled"
                    elseif Course2 =  rstutorcourses2("Course") then
                        Disabled2 = "Disabled"
                    end if

                    rstutorcourses2.MoveNext
			    loop
                rstutorcourses2.Close
				
				rstutorcourses.MoveNext
			loop
            rstutorcourses.Close

            if Disabled1="Disabled" or Disabled2="Disabled" then
                Response.write("<div class='alert alert-caution'>A course is unchangeable if you currently already have a tutor in that course. To change the course you must fill out the form on this <a href='http://www.winthrop.edu/success/form.aspx?ekfrm=31739'>page. Click here. </a> </div>")
                end if

			'******************************************************
			'Estabilsh connection and retrieve record from database
			'******************************************************
			
			EstablishDBCON rs3,con2	
			EstablishDBCON rs4,con3

            'Update for winthrop ID
            EstablishDBCON rs5,con5
            queryString = "select WID from AdditionalInformation where Username = '"&username&"'"
            rs5.open queryString
            EstablishDBCON rs6,con6
            '**********************
            EstablishDBCON rsforcourse,conforcourse
			GetRecord rs3, "Tutee", username

			'*******************************************************
			'Check for changes if found update database
			'*******************************************************
			
			If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then

				'Grab course1 and course2 instead of form data
                	EstablishDBCON rsCourseCheck,conCourseCheck	
				    sqlString = "Select * from Tutee where UserName = '"&username&"'"
                    rsCourseCheck.open sqlString
                    if rsCourseCheck.eof <> true then
                        Course1 = rsCourseCheck("Course1")
                        Course2 = rsCourseCheck("Course2")
                    rsCourseCheck.close
                    end if

                If Request.Form("Course1") <> rs3("Course1") Then
                    'Drop_Class username, "Tutee", rs3("Course1")
                End If

                If Request.Form("Course2") <> rs3("Course2") Then
                    'Drop_Class username, "Tutee", rs3("Course2")
                End If
				' If ( Course1 <> 'EMPTY' and Course1  = Request.Form("Course2") ) or ( Course2 <> 'EMPTY' and Course 2 = Request.Form("Course1") ) or ( Request.Form("Course1")  = Request.Form("Course2") )Then
               
                'If Disabled1 = "Disabled" or Diabled2 = "Disabled" Then
                    'If Course1 = Request.Form("Course2") or Course2 = Request.Form("Course1")
                        'Response.Write("<div class='alert alert-error'>You cannot pick the same course twice</div>")
                    'If Course2 = Request.Form("Course1")
                        'Response.Write("<div class='alert alert-error'>You cannot pick the same course twice</div>")
                 'If Disabled1 = "Disabled" or Diabled2 = "Disabled" Then
                If  (Course1 = Request.Form("Course2") or Course2 = Request.Form("Course1")) 'and (Course2 <> 'EMPTY' and Course1 <> 'EMPTY') then
                        Response.Write("<div class='alert alert-error'>You cannot pick the same course twice</div>")
                elseIf Request.Form("Course1")  = Request.Form("Course2")Then
                    Response.Write("<div class='alert alert-error'>You cannot pick the same course twice</div>")
                Else
			        
				    myQuery = "UPDATE Tutee Set "
				    myQuery = myQuery & "F_Name= '" & Request.Form("F_Name") & "',"
				    myQuery = myQuery & "L_Name= '" & Request.Form("L_Name") & "',"
				    myQuery = myQuery & "PhoneNo= '" & Request.Form("PhoneNo") & "', "
				    
				    if Disabled1 <> "Disabled"   then              
                        myQuery = myQuery & "Course1= '" & Request.form("Course1") & "', "
                    end if
                
                    if Disabled2 <> "Disabled" then
                        myQuery = myQuery & "Course2= '" & Request.form("Course2") & "', "
                    end if
                
                    myQuery = myQuery & "Email= '" & Request.form("TheEmail") & "' "
				
				    myQuery = myQuery & " WHERE UserName = '" & Request.Cookies("user")("username") & "' "
				    
                    

				    rs4.Open(myQuery)		
                    rs3.close()
                    GetRecord rs3, "Tutee", username

                    
                    winthropID = Request.form("winID")
                    queryString = "Update AdditionalInformation set WID = '"& winthropID &"' where Username = '"&UserName&"'"
                    rs6.open queryString
                   
                    Response.Write("<div class='alert alert-success'>User " & username & " Successfully Updated! Click <a href='default.asp'> here </a> or back to return to your home page. </div>")
                     End If
			End If
	    %>

        <h2>Enter Your Information</h2>
        <form name="UpdateForm" class="form-horizontal" action="update-info.asp" onsubmit="return formValidation()" method="POST">
        
        <div class="control-group">
        <label class="control-label" for="F_Name">First Name</label>
        <div class="controls">
        <% 
        	Response.Write("<input name='F_Name' id='F_Name' type='text' required autofocus value='" & rs3("F_Name") & "'>")
       	%>
       	</div></div>
        
       	<div class="control-group">
       	    <label class="control-label" for="L_Name">Last Name</label>
       	        <div class="controls">
       	            <%
        	            Response.Write("<input name='L_Name' id='L_Name' required type='text' value='"&rs3("L_Name")&"'>")
                    %>
                </div>
        </div>
        
       	<div class="control-group">
       	    <label class="control-label" for="PhoneNo">Phone</label>
       	        <div class="controls">        
                    <%	
        	            Response.Write("<input name='PhoneNo' id='PhoneNo' type='text' required class='input-small' maxlength='16' value='"&rs3("PhoneNo")&"'>")
                    %>
                </div>
        </div>
        
        	<div class="control-group">
       	    <label class="control-label" for="winID">Winthrop ID ex: 12345678</label>
       	        <div class="controls">        
                    <%	
        	            Response.Write("<input name='winID' id='winID' type='text' required class='input-small' maxlength='10' value='"&rs5("WID")&"'>")
                    %>
                </div>
        </div>

        <div class="control-group">
	       	<label class="control-label" for="TheEmail">Email</label>
	       	<div class="controls">        
		        <%	
		        	Response.Write("<input name='TheEmail' id='TheEmail' type='email' required value='"&rs3("Email")&"'>")
		        %>
			</div>
		</div>

       	<div class="control-group">
       	    <label class="control-label" for="Course1">Course 1</label>
       	    <div class="controls">  
                <!--Course 1 drop down box-->
                <select id="Course1" <%Response.write (Disabled1) %> name="Course1" onload="showCourse1(this.value)" onchange="showCourse1(this.value)">
                    <%
        	            EstablishDBCON rs2,con2
        	
        	            queryString = "SELECT Course FROM Course order by Course ASC"
        	
        	            rs2.Open queryString     	
		                            Response.Write("<option Selected style='background-color:#ffc120;'>" & rs3("Course1") & "</option>")


		                        do until rs2.EOF
			        	            For Each item In rs2.Fields
		                                If item <> rs3("Course1") Then    
                                            Response.Write("<option>" & item & "</option>")
                                        End if
						            Next
						            rs2.MoveNext
					            loop
		            %>
        	    </select>
            </div>
        </div>

        <div id="txtHint1">
        <%
        sql = "exec dbo.displayallcourseinfo @Course = '" & rs3("Course1") & "'"

        response.Write("<table class='table table-bordered'>")
        response.Write("<tr>")
        response.Write("<td colspan='2' style='text-align:center;'>" & "<b>Course Information</b>" & "</th>")
        response.Write("</tr>")

        rsforcourse.Open sql

            if rsforcourse.eof <> true then
                Course = rsforcourse("Course")
                Title = rsforcourse("Title")
                Section = rsforcourse("Section")
                Instructor = rsforcourse("Instructor")
                Times = rsforcourse("Time")
                Days = rsforcourse("Days")
                Location = rsforcourse("Location")

                response.Write("<tr>")
                Response.Write("<td>Course</td>")
                Response.Write("<td>"&Course&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Title</td>")
                Response.Write("<td>"&Title&"</td>")
                response.Write("</tr>")

                 response.Write("<tr>")
                Response.Write("<td>Section</td>")
                Response.Write("<td>"&Section&"</td>")
                response.Write("</tr>")

                 response.Write("<tr>")
                Response.Write("<td>Instructor</td>")
                Response.Write("<td>"&Instructor&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Time</td>")
                Response.Write("<td>"&Times&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Days</td>")
                Response.Write("<td>"&Days&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Location</td>")
                Response.Write("<td>"&Location&"</td>")
                response.Write("</tr>")


            end if
            rsforcourse.close
        response.Write("</table>")
         %>
        
        
        </div>
	

	<script>
	    function showCourse1(str) {
	        var xmlhttp;
	        if (str == "") {
	            document.getElementById("txtHint1").innerHTML = "";
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
	                document.getElementById("txtHint1").innerHTML = xmlhttp.responseText;
	            }
	        }
	        xmlhttp.open("GET", "../tutor/displaycourseinfo.asp?q=" + str, true);
	        xmlhttp.send();
	    }
	</script>





        	
       	<div class="control-group">
       	<label class="control-label" for="Course2">Course 2</label>
       	<div class="controls">  
            <!--Course 2 drop down box-->
            <select id="Course2" <%Response.write (Disabled2) %> name="Course2" onchange="showCourse(this.value)">
        <% 
        	EstablishDBCON rs2,con2
        	
        	queryString = "SELECT Course FROM Course order by Course ASC"
        	
        	rs2.Open queryString 
		                Response.Write("<option Selected style='background-color:#ffc120;'>" & rs3("Course2") & "</option>")

		            do until rs2.EOF
			        	For Each item In rs2.Fields
		                    If item <> rs3("Course2") then    
                                Response.Write("<option>" & item & "</option>")
                            End if
						Next
						rs2.MoveNext
					loop
		%>
        	</select></div></div>

            <div id="txtHint2">
            <%
        sql = "exec dbo.displayallcourseinfo @Course = '" & rs3("Course2") & "'"

        response.Write("<table class='table table-bordered'>")
        response.Write("<tr>")
        response.Write("<td colspan='2' style='text-align:center;'>" & "<b>Course Information</b>" & "</th>")
        response.Write("</tr>")

        rsforcourse.Open sql

            if rsforcourse.eof <> true then
                Course = rsforcourse("Course")
                Title = rsforcourse("Title")
                Section = rsforcourse("Section")
                Instructor = rsforcourse("Instructor")
                Times = rsforcourse("Time")
                Days = rsforcourse("Days")
                Location = rsforcourse("Location")

                response.Write("<tr>")
                Response.Write("<td>Course</td>")
                Response.Write("<td>"&Course&"</td>")
                response.Write("</tr>")

                response.Write("<tr>")
                Response.Write("<td>Title</td>")
                Response.Write("<td>"&Title&"</td>")
                response.Write("</tr>")

                 response.Write("<tr>")
                Response.Write("<td>Section</td>")
                Response.Write("<td>"&Section&"</td>")
                response.Write("</tr>")

                 response.Write("<tr>")
                Response.Write("<td>Instructor</td>")
                Response.Write("<td>"&Instructor&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Time</td>")
                Response.Write("<td>"&Times&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Days</td>")
                Response.Write("<td>"&Days&"</td>")
                response.Write("</tr>")

                  response.Write("<tr>")
                Response.Write("<td>Location</td>")
                Response.Write("<td>"&Location&"</td>")
                response.Write("</tr>")


            end if
        response.Write("</table>")
         %></div>
	

	<script>
	    function showCourse(str) {
	        var xmlhttp;
	        if (str == "") {
	            document.getElementById("txtHint2").innerHTML = "";
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
	                document.getElementById("txtHint2").innerHTML = xmlhttp.responseText;
	            }
	        }
	        xmlhttp.open("GET", "../tutor/displaycourseinfo.asp?q=" + str, true);
	        xmlhttp.send();
	    }
	</script>




			<div class="form-actions">
        		<script>
        			document.write("<a href='#'><button type='submit' class='btn btn-primary'>Update Information</button></a>");
        		</script>
        		<a href="default.asp" class="btn btn-inverse">Back</a>
			</div>
        </form>
      	<hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
	</div> <!-- /container -->
    </div> <!-- /container -->

<!--Scripts placed at end of page to decrease page load time-->
<script type="text/javascript">
    //function that checks if phone number entered is valid
    function phoneValid(p) {
        var phoneRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
        var digits = p.replace(/\D/g, "");
        return (digits.match(phoneRe) !== null);
    }

    //function that checks if winthrop id number entered is valid
    function widValid(w) {
        var winIdRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
        var digits = w.replace(/\D/g, "");
        return (digits.match(winIdRe) !== null);
    }

    //function that checks if they entered stuff into the form
    function formValidation() {
        var valid = true;
        var F_Name = document.forms["UpdateForm"]["F_Name"].value;
        var L_Name = document.forms["UpdateForm"]["L_Name"].value;
        var PhoneNo = document.forms["UpdateForm"]["PhoneNo"].value;
        var winID = document.forms["UpdateForm"]["winID"].value;

        //Make the phone number be just digits so it can be safely entered into database.
        var phoneRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
        var digits = PhoneNo.replace(/\D/g, "");
        document.forms["UpdateForm"]["PhoneNo"].value = digits;
        PhoneNo = digits;
        if(digits.length != 10)
        {
        	alert("Please enter a ten digit phone number")
        	return false;
        }

        //Make the Winthrop ID be just digits so it can be safely entered into database.
        var winIdRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
        var digits = winID.replace(/\D/g, "");
        document.forms["UpdateForm"]["winID"].value = digits;
        winID = digits;
        if (digits.length != 8) {
            alert("Please enter an eight digit winthrop ID number")
            return false;
        }

        //Email and at and dot positions
        var Email = document.forms["UpdateForm"]["TheEmail"].value;
        var atpos = Email.indexOf("@");
        var dotpos = Email.lastIndexOf(".");

        var Course1 = document.forms["UpdateForm"]["Course1"].value;
        var Course2 = document.forms["UpdateForm"]["Course2"].value;

        //checks if they entered illegal characters
        var substrings = ["--", "<", ">", "(", ")", ";", "/*", "'", "*/", "@@"];
        length = substrings.length;
        while (length--) {
            if (F_Name.indexOf(substrings[length]) !== -1 || L_Name.indexOf(substrings[length]) !== -1 || Email.indexOf(substrings[length]) !== -1) {
                alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
                valid = false;
            }
        }
        if (F_Name == null || F_Name == "" || L_Name == null || L_Name == "") {
            alert("Please enter both a First and Last Name");
            valid = false;
        }
        
        if (PhoneNo == null || PhoneNo == "") {
        	alert("Please enter a phone number.");
        	valid = false;
        }

        if (winID == null || winID == "") {
            alert("Please enter a Winthrop ID number.");
            valid = false;
        }

        if (Email == null || Email == "") {
            alert("Please enter an email.");
            valid = false;
        }
        
        if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
            alert("Not a valid e-mail address");
            valid = false;
        }

        if (Course1 == "EMPTY" && Course2 == "EMPTY") {
            alert("You must choose at least one course");
            valid = false;
        }

        if (Course1 == Course2) {
            alert("You cannot choose the same course twice");
            valid = false;
        }

        if (Course1 === Course2) {
            alert("You cannot choose the same course twice");
            valid = false;
        }

        if (!phoneValid(PhoneNo)) {
            alert("Please enter a valid US Phone Number");
            valid = false;
        }

        if (valid == true)
            return true;
        else if (valid == false)
            return false;
    }
</script>
</body>
</html>