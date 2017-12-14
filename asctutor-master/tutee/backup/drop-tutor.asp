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
<div class="well">
	<p style="text-align:center;">Below is a list of all tutees you tutor.	You can check a checkbox and then press submit to drop that tutee.<br />
	The tutee and administrator will be notified and your time slot that was taken by that tutee will be re-opened.<br />
	</p>
</div>
<form name="" action="drop-tutor.asp" method="post" >
<%
EstablishDBCON rstutorinfo,conforinfo
EstablishDBCON rstutorcourses4,conforinfo4
EstablishDBCON rs_mail,con_mail

'Response.write(getCourseTitle("11111"))

TuteeName = Request.Cookies("user")("username")

If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
    pass = false
    Dropping = Request.Form("Dropping")
    ID= Dropping
    'Response.write (Dropping)
    
	if len(Dropping)>1 then
	

	sqlString = "select * from Available_Times where ID = "&Dropping
	'Response.write sqlString
	rstutorinfo.open sqlString
	
    TutorName = rstutorinfo("UserName")
    Days = rstutorinfo("Day")
    StartTime=rstutorinfo("Start Time")
    StopTime=rstutorinfo("Stop Time")
    Status = rstutorinfo("Status")
    Tutee1= rstutorinfo("Tutee 1")
    Tutee2= rstutorinfo("Tutee 2")
    Selected = rstutorinfo("Tutor Selected")
    Allows2 = rstutorinfo("Allow Two?")
    Course = rstutorinfo("Course")
    
    DisplayThisTime = StartTime & "-" & StopTime
	

				if Status = "Open2" or Status = "Full" then
	    				 sqlString = "exec dbo.getTuteeEmail @UserName ='"&TuteeName&"'"
                         rstutorcourses4.open sqlString
                         
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 
                         
                         ReleaseTime(ID)

                         'create append string for tutee/tutor
                         TuteeInfo = TuteeFullName & " for " & Course & " has dropped the time " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s.<br />"
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to the tutor and tutees with this information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                         Response.Write("<br />")
						 rstutorcourses4.Close

                     
						'Send info to Tutor email
						 Email TutorEmail,"New Schedule Alert", TuteeInfo
                         
                         GetRecord rs_mail,"Tutee",Tutee1
						'Send info to TuteeName email
						Email rs_mail("Email"),"New Schedule Alert", TuteeInfo
						 
						 'Update time slot to empty and decrease tutor hours
						 sqlString = "exec dbo.TuteeTimeResetDecrement  @ID = "&Dropping&", @UserName = '"& TutorName & "'"
						 rstutorcourses4.open sqlString
						  
						  
						 
				elseif Status = "Full2"  then
						
						 sqlString = "exec dbo.getTuteeEmail @UserName ='"&TuteeName&"'"
                         rstutorcourses4.open sqlString
                         
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 
                         
                         'create append string for tutee/tutor
                         TuteeInfo = "One of the tutees" & " for " & Course & " has dropped the time " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s.<br />"
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to the tutor and tutees with this information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                         Response.Write("<br />")
						 rstutorcourses4.Close

                       
						'Send info to Tutor email
						 Email TutorEmail,"New Schedule Alert", TuteeInfo
                         
                         GetRecord rs_mail,"Tutee",Tutee1
                         
						'Send info to Tutee1Name email
						 Email rs_mail("Email"),"New Schedule Alert", TuteeInfo
						 rs_mail.close
						'Send info to Tutee2Name email
						GetRecord rs_mail,"Tutee",Tutee2
						Email rs_mail("Email"),"New Schedule Alert", TuteeInfo
						
						'Update time slot to empty 

                        if Tutee1 = TuteeName then
						 sqlString = "exec dbo.TuteeTimeDropFull2  @ID = "&Dropping&", @TuteeName = '"& Tutee2 & "'"
						 rstutorcourses4.open sqlString
                        elseif Tutee2 = TuteeName then
                         sqlString = "exec dbo.TuteeTimeDropFull2  @ID = "&Dropping&", @TuteeName = '"& Tutee1 & "'"
						 rstutorcourses4.open sqlString
                        else
                         Response.write ("Somehow got here. Alert admin.")
                        end if
						
				else
				        Response.write ("Tutor dropped this time or was removed after you loaded this page. ")
					end if
						

	
	else
		Response.Write ("No times dropped because no times selected.")
	end if
	rstutorinfo.close
	

end if

sqlString = "exec dbo.ActiveTuteeTutors @UserName ='"&TuteeName&"'"
'Response.write sqlString
rstutorinfo.open sqlString

if rstutorinfo.eof = false then
		Response.write("<table class='table table-bordered'>")
		Response.write("<tr>")
		Response.write("<th colspan=9 style='text-align:center;'>Tutees being tutored</th>")
		Response.write("</tr>")
		Response.write("<tr>")

        Response.write("<td>Tutor Name</td>")
		Response.write("<td>Day</td>")
		Response.write("<td>Start Time</td>")
		Response.write("<td>Stop Time</td>")
		Response.write("<td>Course</td>")
		Response.write("<td>Allows Two?</td>")
		Response.write("<td>Drop?</td>")
		Response.write("</tr>")

        do until rstutorinfo.eof 
                UserName= rstutorinfo("UserName")
                Days = rstutorinfo("Day")
                StartTime=rstutorinfo("Start Time")
                StopTime=rstutorinfo("Stop Time")
                Status = rstutorinfo("Status")
                Tutee1= rstutorinfo("Tutee 1")
                Tutee2= rstutorinfo("Tutee 2")
                Selected = rstutorinfo("Tutor Selected")
                Allows2 = rstutorinfo("Allow Two?")
                Course = rstutorinfo("Course")
                ID = rstutorinfo("ID")
                DisplayThisTime = StartTime & "-" & StopTime

                Response.write("<tr>")


                 Response.write("<td>")
                 Response.write ("<a href='view-basic-info.asp?q="&UserName&"'>")
                Response.write(getRealName (UserName))
                Response.write ("</a>")
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(Days)
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(StartTime)
                Response.write("</td>")

                 Response.write("<td>")
                Response.write(StopTime)
                Response.write("</td>")


                Response.write("<td>")
                Response.write(Course)
                Response.write("</td>")

                Response.write("<td>")
                Response.write(Allows2)
                Response.write("</td>")

                Response.write("<td>")
                'Response.write("<input type='checkbox' name='id[]' value="&ID&">")
                Response.write("<button type='submit' name='Dropping' value ="&ID&" class='btn btn-primary'>Drop</button>")
                Response.write("</td>")

                Response.write("</tr>")

                rstutorinfo.movenext
         loop

		Response.write("</table>")
		'Response.write("<button type='submit'value ="&ID&"class='btn btn-primary'>Submit</button>")
else
    	Response.Write("You are not currently being tutored by any tutors.")

end if
%>

<a href="default.asp" class="btn btn-inverse">Back</a>
</form>
  <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
</div>
</body>
</html>
