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
         
           UserName = Request.form("tuteename")
            TuteeName= UserName

            'Email (argToAddress, argSubject,argBody)
            '
                EstablishDBCON rstutorcourses3, concourses3
                EstablishDBCON rstutorcourses4, concourses4
                EstablishDBCON rstimeupdate,conforupdate

                Course = Request.Form("Course")
                TimeChoice = Request.Form("date")
                'Response.write(TimeChoice)
                AllowTwoChoice = Request.Form("twopeople")
                
                'If no choice is selected
                'Defaults to No
                if AllowTwoChoice = "" then
                    AllowTwoChoice = "No"
                end if
                
			'Response.write TimeChoice
            'Use ID to check tutors username, maxhours > used hours, still avail
            sqlString =  "Select * from Available_Times where ID =" &TimeChoice
           ' response.write (sqlString)
                   

            rstutorcourses3.open sqlString
                
            if rstutorcourses3.eof = false then
                 IDStatus = rstutorcourses3("Status")
                UserName= rstutorcourses3("UserName")
                'Check to make sure hours are still ok
                sqlString = "Select M_Hours, U_Hours from Tutor where UserName ='"& UserName&"'"
                rstutorcourses4.open sqlString
                MaxHours = rstutorcourses4("M_Hours")
                UsedHours = rstutorcourses4("U_Hours")
                rstutorcourses4.close

                'if tutors hours are still good then
              if MaxHours > UsedHours  or IDStatus="Open2" then

                    UserName= rstutorcourses3("UserName")
                    Days = rstutorcourses3("Day")
                    StartTime=rstutorcourses3("Start Time")
                    StopTime=rstutorcourses3("Stop Time")
                    Status = rstutorcourses3("Status")
                    Tutee1= rstutorcourses3("Tutee 1")
                    Tutee2= rstutorcourses3("Tutee 2")
                    Selected = rstutorcourses3("Tutor Selected")
                    ID = rstutorcourses3("ID")
                    'pass = false

                    DisplayThisTime = StartTime & "-" & StopTime
						
					'Response.write (Status)
						
						
                    if Status = "Open" and AllowTwoChoice ="No" then
                        'Update Tutee to slot 1
                        'Update AllowTwoChoice
                        'Update Status
                        'Update Course
                        'Email
                         sqlString = "exec dbo.UpdateStatusOpenNo @ID = '"& ID & "', @Tutee = '"& TuteeName&"', @Tutor = '"& UserName& "', @Course = '"&  Course & "'"
                         rstutorcourses4.open sqlString
                        'SEND EMAIL TO TUTee NAME
                        'function
                        'Email 
						LockTime (ID)
						'create append string for tutee
						 sqlString = "exec dbo.getTutorNameEmail @UserName ='"&UserName&"'"
                         rstutorcourses4.open sqlString
                         TutorFName = rstutorcourses4("F_Name") 
                         TutorLName = rstutorcourses4("L_Name") 
                         TutorFullName = TutorFName & " " & TutorLName
                         TutorEmail = rstutorcourses4("Email") 
                         TutorPhone= rstutorcourses4("PhoneNo") 
                        
                         TuteeInfo = "Your tutor for " & getCourseTitle(Course) & " is " & TutorFullName & " at " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s.<br />"
                         TuteeInfo = TuteeInfo & "Email: " & TutorEmail & " <br />" & "Phone Number: " & TutorPhone
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to your new tutor with your information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                         Response.Write("<br />")
						 rstutorcourses4.Close
						 
						 
						 
						 'create append string for tutor
						 sqlString = "exec dbo.getTuteeEmail @UserName ='"&TuteeName&"'"
						 rstutorcourses4.open sqlString
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 
                         
                         TutorInfo = TuteeFullName & " has selected you to tutor " & getCourseTitle(Course) & " at " & DisplayThisTime
                         TutorInfo = TutorInfo & " on " & Days & "s.<br />"
                         TutorInfo = TutorInfo & "Email: " & TuteeEmail & " <br />" & "Phone Number: " & TuteePhone
                         TutorInfo = TutorInfo & "<br /> An email has been sent to your new tutee with your information." 
                         rstutorcourses4.close
						
                        'Update timechange
                         updateString = "Update AdditionalInformation set TimeChanges = TimeChanges + 1 where Username = '"& TuteeName &"'"
                         rstimeupdate.open updateString                    

                        'Send info to Tutor email
						 Email TutorEmail,"New Schedule Alert", TutorInfo
                         
						'Send info to TuteeName email
						 Email TuteeEmail,"New Schedule Alert", TuteeInfo
						
                        
                        'Response.Write("Status was open and allowtwochoice was No")

                        Response.Write("<br />")

                    elseif Status = "Open" and AllowTwoChoice ="Yes" then
                        'Update Tutee to slot 1
                        'Update AllowTwoChoice
                        'Update Status
                        'Update Course
                        'Email
                         sqlString = "exec dbo.UpdateStatusOpenYes @ID = '"& ID & "', @Tutee = '"& TuteeName&"', @Tutor = '"& UserName& "', @Course = '"&  Course & "'"
                         rstutorcourses4.open sqlString
                        'SEND EMAIL TO TUTee NAME
                         LockTime (ID)
						 sqlString = "exec dbo.getTutorNameEmail @UserName ='"&UserName&"'"
                         rstutorcourses4.open sqlString
                         TutorFName = rstutorcourses4("F_Name") 
                         TutorLName = rstutorcourses4("L_Name") 
                         TutorFullName = TutorFName & " " & TutorLName
                         TutorEmail = rstutorcourses4("Email") 
                         TutorPhone= rstutorcourses4("PhoneNo") 
                         'create append string for tutee
                         TuteeInfo = "Your tutor for " & Course & " is " & TutorFullName & " at " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s.<br />"
                         TuteeInfo = TuteeInfo & "Email: " & TutorEmail & " <br />" & "Phone Number: " & TutorPhone
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to your new tutor with your information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                         Response.Write("<br />")
                         rstutorcourses4.close 
						
						
						 'create append string for tutor
						 sqlString = "exec dbo.getTuteeEmail @UserName ='"&TuteeName&"'"
						 rstutorcourses4.open sqlString
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 
                         
                         TutorInfo = TuteeFullName & " has selected you to tutor " & Course & " at " & DisplayThisTime
                         TutorInfo = TutorInfo & " on " & Days & "s.<br />"
                         TutorInfo = TutorInfo & "Email: " & TuteeEmail & " <br />" & "Phone Number: " & TuteePhone
                         TutorInfo = TutorInfo & "<br /> An email has been sent to your new tutee with your information." 
                         rstutorcourses4.close

                        'Update timechange
                         updateString = "Update AdditionalInformation set TimeChanges = TimeChanges + 1 where Username = '"& TuteeName &"'"
                         rstimeupdate.open updateString   

						'Send info to Tutor email
						 Email TutorEmail,"New Schedule Alert", TutorInfo
                         
						'Send info to TuteeName email
						 Email TuteeEmail,"New Schedule Alert", TuteeInfo
                        
						
						
                        'Response.Write("Status was open and allowtwochoice was Yes")
                         Response.Write("<br />")
                         

                    elseif Status = "Open2" then
                         'Update Tutee to slot 2
                         'Update Status to Full2
                         'Email Tutee, Tutor, Tutee1
				
                          sqlString = "exec dbo.UpdateStatusOpen2 @ID = '"& ID & "', @Tutee = '"& TuteeName&"'"
                          rstutorcourses4.open sqlString
                          LockTime (ID)
                         'SEND EMAIL TO TUTee2 NAME
                         'function
                         'Response.Write("Status was open2 and allowtwochoice was Forced")
                         '
                         sqlString = "exec dbo.getTutorNameEmail @UserName ='"&UserName&"'"
                         rstutorcourses4.open sqlString
                         TutorFName = rstutorcourses4("F_Name") 
                         TutorLName = rstutorcourses4("L_Name") 
                         TutorFullName = TutorFName & " " & TutorLName
                         TutorEmail = rstutorcourses4("Email") 
                         TutorPhone= rstutorcourses4("PhoneNo") 
                         'create append string for tutee
                         TuteeInfo = "Your tutor for " & Course & " is " & TutorFullName & " at " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s.<br />"
                         TuteeInfo = TuteeInfo & "Email: " & TutorEmail & " <br />" & "Phone Number: " & TutorPhone
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to your new tutor with your information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                         Response.Write("<br />")
						 rstutorcourses4.Close

						 'create append string for tutor
						 sqlString = "exec dbo.getTuteeEmail @UserName ='"&TuteeName&"'"
						 rstutorcourses4.open sqlString
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 
                         
                         TutorInfo = TuteeFullName & " has selected you to tutor " & Course & " at " & DisplayThisTime
                         TutorInfo = TutorInfo & " on " & Days & "s.<br />"
                         TutorInfo = TutorInfo & "Email: " & TuteeEmail & " <br />" & "Phone Number: " & TuteePhone
                         TutorInfo = TutorInfo & "<br /> An email has been sent to your new tutee with your information." 
                         rstutorcourses4.close

                        'Update timechange
                         updateString = "Update AdditionalInformation set TimeChanges = TimeChanges + 1 where Username = '"& TuteeName &"'"
                         rstimeupdate.open updateString   
        
						'Send info to Tutor email
						 Email TutorEmail,"New Schedule Alert", TutorInfo
                         
						'Send info to TuteeName email
						 Email TuteeEmail,"New Schedule Alert", TuteeInfo
						 
                         
                    else
                         Response.write("<div class='alert alert-error'>Your choice was taken. Please start from the beginning and try again by clicking <a href='find-tutor.asp'> here. </a> </div>")
                         
                    end if'status checker

                    'Response.Write("I got in here")
                   

                else
                	Response.write(" ")
                    'Response.write("Something went wrong, start again :(")
                    Response.write("<div class='alert alert-error'>The tutor's hours has surpassed his/her maximum.</div>")
                end if

                   
                    rstutorcourses3.close
					
             end if' max hours, used hours pass
          
            'Response.write("[:")
          'end if 'this id even exists pass

%>
<a href="default.asp" class="btn btn-inverse">Back to home</a>
<hr>    
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
	
	</div> <!-- /container -->


 </body>
 </html>