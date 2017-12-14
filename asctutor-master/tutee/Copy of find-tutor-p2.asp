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

	<div class="container">
		<div class="alert alert-info">
			<h3>Please pick a tutor and time slot.</h3>
		</div>
        <%

        EstablishDBCON rstutorcourses, concourses
        EstablishDBCON rstutorcourses2, concourses2

            UserName = Request.Cookies("user")("username")
            
            course = Request.Form("course")
            'Make sure I'm sent something.
            
            if len(course) > 2 then
                courseinfo = split(course,"+")
                CourseChoice = courseinfo(0)
                CourseNumber = courseinfo(1)
                pass = true
            else
                Response.write("<div class='alert alert-error'>Please go back to the previous page and select a course</div>")
                pass= false
            end if
        
        %>

       <p>List of all available tutors and their time slots for the chosen class:</p>
        
        <%
        EstablishDBCON rstutorcourses4, concourses4

		'select all tutors who tutor course-done
		'for each tutor
		'check if at <> @ max hours or (if one of the courses they are tutoring is Open2)
		'display times for these guys
		'i got two queries one for normal stuff
		'second one grabs those double sessions but ill have to query again or NOT. i think only one is necessary
		'
		'if tutor is at max hours remove unless a double session si available indicated by open2 status
		'so we have two lists of tutors
		'for each in first list
		'show all times
		'now do second list
		'for each here just show open2 times


        'If sent something then start doing stuff.
        
if pass  then
        
        'Select Course number 2 from Tutee and put that value in something for Course to = to
        sqlString = "Select Course"&CourseNumber&" from Tutee where UserName = '" & UserName & " '"
        rstutorcourses.open sqlString
        
        TuteeCourse =  rstutorcourses("Course"&CourseNumber)
        rstutorcourses.close
        
        'Shows list of tutors who tutor the specific course
        sqlString = "exec dbo.TutorListForTuteeCourse @Course ='"&TuteeCourse&"'" 
        rstutorcourses.open sqlString
         	counterForAcc = 0
         	counterForCollapse = 0

    if rstutorcourses.eof = false then

        do until rstutorcourses.EOF
            
           'For each Tutor Name
           'Select all times from Available_Times where UserName = TutorName 
           TutorName = rstutorcourses("UserName")
            'select all times that have status listed as open for that username
            sqlString = "Select * from Available_Times WHERE UserName = '"&TutorName&"' and (Status='Open' or Status = 'Open2') and (Course='EMPTY' or Course ='"&TuteeCourse&"')"
            rstutorcourses2.open sqlString
            
            CurrentDay =""
            'Response.write("<b>"&TutorName&"</b> <br />")
            TutorName =""

         	'goes through all the times that are avail for the tutee
            do until rstutorcourses2.eof

                UserName= rstutorcourses2("UserName")
                Days = rstutorcourses2("Day")
                StartTime=rstutorcourses2("Start Time")
                StopTime=rstutorcourses2("Stop Time")
                Status = rstutorcourses2("Status")
                Tutee1= rstutorcourses2("Tutee 1")
                Tutee2= rstutorcourses2("Tutee 2")
                Selected = rstutorcourses2("Tutor Selected")
                ID = rstutorcourses2("ID")
                pass = false
                DisplayThisTime = StartTime & "-" & StopTime
                
		        '************************************
		        'DEVELOP STATUS CODES
		        'Open = No tutees currently using and avail
		        'Open2 = Tutee1 Currently using
		        'Open3 if necessary = Tutee2 Using but no Tutee1 probably should put tutee2 there if tutee 1 drops
		        'Closed =  not selected
		        'Full = one tutee is using and said no to allow two
		        'Full = two tutees are using
                'ClosedC = Time locked because adjacent time selected but tutor did not select this
                'OpenC = Time locked because adjacent time selected and tutor selected this
		        '******************************
		        
                'Bad method of writing stuff
                'Should change to Two loops and two result sets
		        if Status = "Open" or Status = "Open2" then
		            pass = true
		            if  TutorName <> UserName then
		                TutorName = UserName
		                Response.write("<h4>" & getRealName (TutorName) & "</h4><div class='well'>" & vbCrLf)		                
		            end if
		        end if
		        
		        if pass then
		            if CurrentDay <> Days then
		                CurrentDay = Days
		                Response.Write("<h5>" & CurrentDay & "</h5>")
		            end if
		        end if
		        
		        if pass then
		                Response.Write("<label class='radio'><input type='radio' name='date' onchange='showinfo(this.value)' value="&ID&","&TuteeCourse&">"&DisplayThisTime&"</label>" & vbCrLf)
		        end if

		            rstutorcourses2.movenext
            loop
            Response.write("</div>")
            rstutorcourses2.close
            rstutorcourses.movenext
        loop
    else
        Response.write("<div class='alert alert-error'>Please alert the ASC director that no tutors are available for your course. </div>")
    end if 'If no tutors are tutoring a course.

end if 'if data sent check 
        %>


	    </form>
        
        <div id='results'>Information on time slot will be shown here </div>

        <script>
            function showinfo(str) {
                var xmlhttp;
                if (str == "") {
                    document.getElementById("results").innerHTML = "";
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
                        document.getElementById("results").innerHTML = xmlhttp.responseText;
                    }
                }
                xmlhttp.open("GET", "ajaxcoursefortwo.asp?q=" + str, true);
                xmlhttp.send();
            }
	</script>

		<hr>    
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
	
	</div> <!-- /container -->
</body>
</html>
