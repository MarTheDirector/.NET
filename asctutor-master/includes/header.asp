<!--
    Name:       Tutor Schedule Portal Header
    Written By: Unknown
    Updated By: ??
    System:     Part of the ASC Tutor Schedule Portal website
    Created:    Unknown
    Update:     Spring 2015
    Purpose:    Updated the database connection to connect to a test database.
-->

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Winthrop University ASC Tutoring">
<meta name="author" content="Winthrop University">

<!-- Styles -->
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/bootstrap-responsive.min.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-left: 10px;
        padding-right: 10px;
        padding-bottom: 60px;
      }
    </style>
<!--<link rel="stylesheet" href="../css/font-awesome.min.css">-->
<!--FontAwesome IE7 Support -->
<!--[if IE 7]>
<link rel="stylesheet" href="../css/font-awesome-ie7.min.css">
<![endif]-->
<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<!-- Favicon -->
<link rel="shortcut icon" href="../favicon.ico">

<!--#include file="SQL-Escape.asp"-->
<%
		'******************************************************
		'   Establish Connection to SQL server and Variables
		'******************************************************
		
	    Function EstablishDBCON (rsss, connn)
			
		set connn = server.CreateObject("adodb.connection") 'opens connection
		connn.Mode = 3
		connn.Open "Provider=sqloledb;SERVER=localhost;DATABASE=asc_tutor;UID=ASC;PWD=B3sm3rASC"
		set rsss = server.CreateObject("adodb.Recordset")
		set rsss.ActiveConnection = connn
		
		end function
		
		'******************************************************
		'   Retrieve user's real full name
		'******************************************************

		Function getRealName (UserName)
		
        if UserName <> "EMPTY" then
			EstablishDBCON rstutor7courses, concourses
			
			sqlString = "Select * from Users where UserName ='"&UserName&"'"
			'Response.write sqlString
	        rstutor7courses.open sqlString
	        if rstutor7courses.EOF <> true then
		        UserType = rstutor7courses("Type")
		        rstutor7courses.close
		        
		        sqlString = "Select F_Name,L_Name from "&UserType&" where UserName ='"&UserName&"'"
		        'Response.write sqlString
		        rstutor7courses.open sqlString
		        UserFName = rstutor7courses("F_Name") 
		        UserLName = rstutor7courses("L_Name") 
		        getRealName = UserFName & " " & UserLName
				rstutor7courses.close
			else
				getRealName = "No longer exists"
		 	end if
		else
        getRealName = ""
        end if

		end function	


        '******************************************************
		'   Retrieve course's title
		'******************************************************
        
        Function getCourseTitle (Course)
		
        if Course <> "" then
                

		EstablishDBCON rscoursestitle, concoursestitle
		
		sqlString = "Select Title from Course where Course ='"&Course&"'"
        
		'Response.write sqlString
        rscoursestitle.open sqlString
        
            if rscoursestitle.eof then
                    if Course = "EMPTY" then
                        getCourseTitle = ""
                    else
                        getCourseTitle = "No course record exists for " & Course
                    end if 
            else
                getCourseTitle = rscoursestitle("Title")
            end if

        rscoursestitle.close
        
        end if

		end function	

      '******************************************************
		'   Retrieve tutor email
		'******************************************************
        
        Function getTutorEmail (UserName)
		
        if UserName <> "" then
		    EstablishDBCON rsEmail, conEmail
		
		    sqlString = "Select Email from Tutor where UserName ='"&UserName&"'"
            'Response.write(sqlString)
            rsEmail.open sqlString

                if rsEmail.eof then
                   getTutorEmail = "did not get email"
                   rsEmail.close
                else
                    getTutorEmail = rsEmail("Email")

                    rsEmail.close
                end if    

         end if

		end function	



        '******************************************************
		'   Retrieve pass
		'******************************************************
        
        Function getPass (UserName)
		
        if UserName <> "" then
		EstablishDBCON rsPass, conPass
		
		sqlString = "Select Password from Users where UserName ='"&UserName&"'"
        
		'Response.write sqlString
        rsPass.open sqlString

        getPass = rsPass("Password")

        rsPass.close
        
        end if

		end function	

        '******************************************************
		'   Check if page is open or unlocked.
        '   
		'******************************************************
        Function getStatusOfPage (PageName)

        If len(PageName)>1 then 
            EstablishDBCON rsPageStatus, conPageStatus
		    sqlString = "Select Status from PageStatus where PageName ='"&PageName&"'"
            rsPageStatus.open sqlString
            PageStatus = rsPageStatus("Status")
            getStatusOfPage = PageStatus
            rsPageStatus.close    
        end if

		end function	

        '******************************************************
		'   Lock Page
		'******************************************************
        Function LockPage (PageName)

        If len(PageName)>1 then 
            EstablishDBCON rsPageStatus, conPageStatus
		    sqlString = "Select Status from PageStatus where PageName ='"&PageName&"'"
            rsPageStatus.open sqlString
            PageStatus = rsPageStatus("Status")

            if trim(PageStatus) = "Locked" then
                Response.Redirect "../closed.asp"
            end if
            rsPageStatus.close    
        end if

		end function	
        
		'*****************************************************
		'   Connects to SQL server and pulls out user record
		'*****************************************************
		
		Function GetRecord (recordset, mytable,user_name)
		  
		  If ( CheckStringForSQL(mytable) ) Then
		    Response.Redirect(ErrorPage)
		  End If
		  If ( CheckStringForSQL(user_name) ) Then
		    Response.Redirect(ErrorPage)
		  End If
		  queryString = "SELECT * FROM "&mytable&" WHERE UserName= '" & user_name & "'; "
		  recordset.Open queryString

		end function
		
		
		
		' **************************************************
		' *****************      EMAILER      **************
		' **************************************************

		Function Email (argToAddress, argSubject,argBody)

		Set config = CreateObject ("CDO.Configuration")
		sch = "http://schemas.microsoft.com/cdo/configuration/"

		' **********************************************
		'        SET AND UPDATE FIELDS PROPERTIES 
		' **********************************************
		With config.Fields
		    .item(sch & "smtpserver") = "smtp.gmail.com"
		    .item(sch & "sendusername") = "success@mailbox.winthrop.edu"
		    .item(sch & "sendpassword") = "thewuasc1"
		    .item(sch & "smtpserverport") = 465
		    .item(sch & "sendusing") = 2
		    .item(sch & "smtpconnectiontimeout") = 30
		    .item(sch & "smtpusessl") = 1
		    .item(sch & "smtpauthenticate") = 1
		    .item(sch & "IsBodyHtml") = True
		    .Update 
		End With


		' *********************************************
		'              SET MESSAGE DETAILS 
		' *********************************************
		with CreateObject("CDO.Message")
		  .configuration = config
		  .to = argToAddress 
		  .from = "success@mailbox.winthrop.edu"
		  .CC = "success@mailbox.winthrop.edu"
		  .subject = argSubject
		  .HTMLBody = argBody & "<br /><br /><a href='http://birdnest.org/asc_tutor'>http://birdnest.org/asc_tutor</a>"
		  call .send()
		end with
		
		End Function 

' *********************************************
'              getCourseName
' *********************************************
Function getCourseName(CRN)
    EstablishDBCON rsgetCourseName, congetCourseName
    sql = "Select Course from Course where Course = "&CRN
    rsgetCourseName.open sql
    getCourseName = rsgetCourseName("Course")
    rsgetCourseName.close
End Function
'************************************************


'******************************************************
'   Retrieve WinthropID
'******************************************************
        
        Function getWID (Username)
		
        if Username <> "" then
       
		EstablishDBCON rsWID, conWID
		
		sqlString = "exec dbo.getWinthropID @UserName = '"&Username&"'"
        
		'Response.write sqlString
        rsWID.open sqlString
        
            if rsWID.eof then
                getWID = "Winthrop ID not Found"
            else
                getWID = rsWID("WID")
            end if

        rsWID.close
        
        end if

		end function	


' *********************************************
'              Lock Time
' *********************************************
'Prevents other times from being selected so overlapping times
'cannot be selected. Adjacent times are set to original status +C
' This prevents them from being shown to tutees.
Function LockTime(ID)
EstablishDBCON rsLockTime, conLockTime

'Determine UserName from ID
sql = "Select UserName from Available_Times where ID = "&ID
rsLockTime.open sql
UserName = rsLockTime("UserName")
rsLockTime.close

sql = "exec dbo.getMinMax @UserName = '"&UserName&"'"
rsLockTime.open sql
minID = cLng(rsLockTime("minID"))
maxID = cLng(rsLockTime("maxID"))
rsLockTime.close
ID = cLng(ID)
timeConst = 21

'response.write("timeConst = " & timeConst & "<br />")

if( (ID =  minID) or (ID = minID + timeConst)  or (ID = timeConst*2 + minID) or (ID = timeConst*3 + minID) or (ID = timeConst*4 + minID) or (ID = timeConst*5 + minID)) then

'Update After Only
 'Response.write ("Updated After Only")
 
    sql = "Select Status from Available_Times where ID = "&(ID+1)
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" or Status = "OpenC" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID+1)
        rsLockTime.open sql    
    elseif Status = "Closed" or Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID+1)
        rsLockTime.open sql   
    else
        Response.write ("001: Something went wrong. Report this to admin. ")

    end if

elseif  ( (ID = (timeConst-1) + minID ) or (ID = ((timeConst)*2-1) + minID) or (ID = ((timeConst*3)-1) + minID) or (ID = ((timeConst*4)-1) + minID) or (ID = ((timeConst*5)-1) + minID) or (ID = maxID) ) then
'Update Before Only
    'Response.write ("Updated Before Only")
    sql = "Select Status from Available_Times where ID = "&(ID-1)
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" or Status = "OpenC" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID-1)
        rsLockTime.open sql    
    elseif Status = "Closed" or Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID-1)
        rsLockTime.open sql   
    else 
        Response.write ("002: Something went wrong. Report this to admin. ")
    end if

'SUNDAY START
'nvm not sure we need sunday's own thing
    
    
'else should still be fine
else
'Update Before and After
    'Response.write ("Updated Before and After")
    'Update Before Time first
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID - 1) &")"
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" or Status ="OpenC" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID-1)
        rsLockTime.open sql    
    elseif Status = "Closed" or Status = "ClosedC" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID-1)
        rsLockTime.open sql   
    elseif Status = "Full" or Status = "Full2" then
        Response.write ("066: Something went wrong. Report this to admin. ")
    else
        Response.write ("036: Something went wrong. Report this to admin. ")
    end if

    'Update After time second
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID + 1) &")"
    rsLockTime.open sql
    Status = rsLockTime("Status")
    rsLockTime.close

    if Status = "Open" then
        sql = "Update Available_Times set Status = 'OpenC' where ID = "&(ID+1)
        rsLockTime.open sql    
    elseif Status = "Closed" then
        sql = "Update Available_Times set Status = 'ClosedC' where ID = "&(ID+1)
        rsLockTime.open sql   
    elseif Status = "ClosedC" or Status ="OpenC" then 
        'Response.write ("003: Something went wrong. Report this to admin. ")
    elseif Status = "Full" or Status = "Full2" then
        Response.write ("006: Something went wrong. Report this to admin. ")
    else
        Response.write ("007: Something went wrong. Report this to admin. ")
    end if

end if

'Response.write(ID & "<br />")
'Response.write("After only IDs <br />")
'Response.write ( minID & "<br />")
'Response.write ( minID + timeConst & "<br />")
'Response.write ( timeConst*2 + minID  & "<br />")
'Response.write (timeConst*3 + minID  & "<br />")
'Response.write ( timeConst*4 + minID & "<br />")

'Response.write("Before only IDs <br />")
'Response.write ( (timeConst-1) + minID & "<br />")
'Response.write ((timeConst)*2-1 + minID & "<br />") 
'Response.write  ((timeConst*3)-1 + minID& "<br />") 
'Response.write   ((timeConst*4)-1 + minID& "<br />") 
'Response.write    ((timeConst*5)-1 + minID& "<br />")

End Function


' *********************************************
'              Release Time
' *********************************************
'Releases other times that have been locked to prevent 
'overlapping times. Adjacent times are set to original status +C
' This prevents them from being shown to tutees.

Function ReleaseTime(ID)
EstablishDBCON rsReleaseTime, conReleaseTime

'Determine UserName from ID
sql = "Select UserName from Available_Times where ID = "&ID
rsReleaseTime.open sql
UserName = rsReleaseTime("UserName")
rsReleaseTime.close

sql = "exec dbo.getMinMax @UserName = '"&UserName&"'"
rsReleaseTime.open sql
minID = cLng(rsReleaseTime("minID"))
maxID = cLng(rsReleaseTime("maxID"))
'Response.write(minID & "is the min ID </br>")
'Response.write(ID & "is the ID </br>")
rsReleaseTime.close
ID = cLng(ID)
timeConst = 21

'response.write("timeConst = " & timeConst & "<br />")

if( (ID =  minID) or (ID = minID + timeConst)  or (ID = timeConst*2 + minID) or (ID = timeConst*3 + minID) or (ID = timeConst*4 + minID) or (ID = timeConst*5 + minID) ) then

'Update After Only
 'Response.write ("Updated After Only")
 
    sql = "Select Status from Available_Times where ID = "&(ID+1)
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then
        sql = "Select Status from Available_Times where ID = "&(ID+2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2" or Status = "Open2" then
            '
        else
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID+1)
        rsReleaseTime.open sql
        end if
            
    elseif Status = "ClosedC" then
        sql = "Select Status from Available_Times where ID = "&(ID+2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2"  or Status = "Open2" then
        '
        else
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID+1)
        rsReleaseTime.open sql   
        end if
    else 
        Response.write ("001: Something went wrong. Report this to admin. ")
    end if

elseif  ( (ID = (timeConst-1) + minID ) or (ID = ((timeConst)*2-1) + minID) or (ID = ((timeConst*3)-1) + minID) or (ID = ((timeConst*4)-1) + minID) or (ID = ((timeConst*5)-1) + minID) or (ID = maxID) ) then
'Update Before Only
    'Response.write ("Updated Before Only")
    sql = "Select Status from Available_Times where ID = "&(ID-1)
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then

        sql = "Select Status from Available_Times where ID = "&(ID-2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2" or Status = "Open2" then
            '
        else
            sql = "Update Available_Times set Status = 'Open' where ID = "&(ID-1)
            rsReleaseTime.open sql    
        end if

    elseif Status = "ClosedC" then

        sql = "Select Status from Available_Times where ID = "&(ID-2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2" or Status = "Open2" then
            '
        else
            sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID-1)
            rsReleaseTime.open sql  
        end if 
    else 
        Response.write ("002: Something went wrong. Report this to admin. ")
    end if

else
'Update Before and After
    'Response.write ("Updated Before and After")
    
    
    '*****************************************
	'Why am I am updating before and after on one that should be only after?
	'*****************************************

	
    'Update Before Time first
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID - 1) &")"
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" then
        sql = "Select Status from Available_Times where ID = "&(ID-2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2" or Status = "Open2" then
            '
        else
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID-1)
        rsReleaseTime.open sql    
        end if
    elseif Status = "ClosedC" then
        sql = "Select Status from Available_Times where ID = "&(ID-2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2"  or Status = "Open2" then
            '
        else
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID-1)
        rsReleaseTime.open sql 
        end if  
    'else 
        'Response.write ("003: Something went wrong. Report this to admin. ")
    end if

    'Update After time second
    sql = "SELECT Status FROM Available_Times WHERE (ID = "&(ID + 1) &")"
    rsReleaseTime.open sql
    Status = rsReleaseTime("Status")
    rsReleaseTime.close

    if Status = "OpenC" or Status = "Open" then
        sql = "Select Status from Available_Times where ID = "&(ID+2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2" or Status = "Open2" then
            '
        else
        sql = "Update Available_Times set Status = 'Open' where ID = "&(ID+1)
        rsReleaseTime.open sql    
        end if
    elseif Status = "ClosedC" or Status = "Closed" then
        sql = "Select Status from Available_Times where ID = "&(ID+2)
        rsReleaseTime.open sql
        Status = rsReleaseTime("Status")
        rsReleaseTime.close
        if Status = "Full" or Status = "Full2" or Status = "Open2" then
            '
        else
        sql = "Update Available_Times set Status = 'Closed' where ID = "&(ID+1)
        rsReleaseTime.open sql   
        end if
    else 
        Response.write ("004: Something went wrong. Report this to admin. ")
    end if

end if

End Function


 



    ' ****************************************************
    '   Function to Safely drop a person from the system
    ' ****************************************************
        Function safe_drop_person(Username)
		'exec dbo.ShowTutorCourses @UserName = Username
		'Select * from Available_Times where Status = 'Open1' or Status = 'Full' or Status = 'Full2'
 
		EstablishDBCON rs_delete, con_delete
		EstablishDBCON rs_email, con_email
		EstablishDBCON rs_usercheck, con_usercheck
		
		GetRecord rs_usercheck, "Users",Username
		
		if rs_usercheck("Type") = "Tutor" Then
		rs_email.open "exec dbo.GetTutorNameEmail @UserName = '"&Username&"'"
		rs_delete.open "exec dbo.DeleteTutor @UserName = '"&Username&"'"

		
		do until rs_delete.EOF
			rs_email.open "exec dbo.GetTuteeEmail @UserName = '"&rs_delete("Tutee 1")&"'"
			
			if rs_delete("Status")  = "Open2" OR rs_delete("Status") = "Full" Then

				toaddress = rs_email("Email")
				subject = "**NOTICE: ASC Tutoring Update **"
				body = "Your tutoring timeslot for: "&rs_delete("Course")&","&rs_delete("Day")&","&rs_delete("Start Time")&" has been dropped. Please Login and sign up for a new time."
				rs_email.close
				Email toaddress, subject,body
				
			elseif rs_delete("Status")  = "Full2" Then
				
				'Send Email to first tutee
				toaddress = rs_email("Email")
				subject = "**NOTICE: ASC Tutoring Update **"
				body = "Your tutoring timeslot for: "&rs_delete("Course")&","&rs_delete("Day")&","&rs_delete("Start Time")&" has been dropped. Please Login and sign up for a new time."
				rs_email.close
				Email toaddress, subject,body

				'Send Email to second tutee
				rs_email.open "exec dbo.GetTuteeEmail @UserName = '"&rs_delete("Tutee 2")&"'"
				toaddress = rs_email("Email")
				subject = "**NOTICE: ASC Tutoring Update **"
				body = "Your tutoring timeslot for: "&rs_delete("Course")&","&rs_delete("Day")&","&rs_delete("Start Time")&" has been dropped. Please Login and sign up for a new time."
				rs_email.close
				Email toaddress, subject,body
			
			End If
				'Email Tutor
			rs_delete.movenext
		loop
        
				toaddress = rs_email("Email")
				subject = "**NOTICE: ASC Tutoring Update **"
				body = "You: "&Username&" Have been Removed from the ASC Tutoring system."
				Email toaddress, subject,body
		
		Else
		EstablishDBCON rs_removetutee, con_removetutee
        EstablishDBCON rs_hoursupdate, con_hoursupdate


			myQuery = "Select * From Available_Times Where ([Tutee 1] = '"&Username&"' OR [Tutee 2] = '"&Username&"')"
			rs_delete.open myQuery

            
			
			do until rs_delete.EOF
			
			
			If (rs_delete("Tutee 1") = Username AND rs_delete("Tutee 2") = "EMPTY") Then 
				'If case of first column and second column Empty
				rs_removetutee.open "exec dbo.DeleteTuteeOne @UserName = '"&Username&"', @Course = '"&rs_delete("Course")&"'"
                Response.write("Option 1")

                'Update Tutors hours
                'Grab Tutor Info
                myQuery = "exec dbo.Decrement @UserName = '"&rs_delete("UserName")&"'"
                rs_hoursupdate.open myQuery
                Response.write("Option 1 - a")
				
			Else 
				'Case of desired tutee in a column and another person in other column
				If (rs_delete("Tutee 1") = Username) Then
                Response.write("Option 2")
					'Swap values from tutee 2 column to tutee 1 to keep database consistancy
					rs_removetutee.open "Update Available_Times Set [Tutee 1] = '"&rs_delete("Tutee 2")&"', [Tutee 2] = '"&rs_delete("Tutee 1")&"' Where ([Tutee 1] = '"&rs_delete("Tutee 1")&"'AND [Tutee 2] = '"&rs_delete("Tutee 2")&"')"
					'Remove User from table
					rs_removetutee.open "exec dbo.DeleteTuteeTwo @UserName = '"&Username&"',@Course = '"&rs_delete("Course")&"'"

				Else
					ReleaseTime (rs_delete("ID"))
					rs_removetutee.open "exec dbo.DeleteTuteeTwo @UserName = '"&Username&"',@Course = '"&rs_delete("Course")&"'"
                    Response.write("Option 3")
				End If
			End If' End of test which column desired tutee is located in
			    

				'Email Tutor of changes
				rs_email.open "exec dbo.GetTutorNameEmail @UserName = '"&rs_delete("UserName")&"'"
				toaddress = rs_email("Email")
				subject = "**NOTICE: ASC Tutoring Update **"
				body = "You: "&Username&" Have been removed from the ASC Tutoring system."
				Email toaddress, subject,body
				rs_email.close
				Response.write("TUTOR EMAILED")
				
				'Email Tutee of changes
				rs_email.open "exec dbo.GetTuteeEmail @UserName = '"&Username&"'"
				toaddress = rs_email("Email")
				subject = "**NOTICE: ASC Tutoring Update **"
				body = "Your tutoring timeslot for: "&rs_delete("Course")&","&rs_delete("Day")&","&rs_delete("Start Time")&" has been dropped. Please Login and sign up for a new time."
				Email toaddress, subject,body
				rs_email.close
				Response.write("TUTEE EMAILED")

                rs_delete.movenext
			Loop
            rs_delete.close
			rs_delete.open "exec dbo.DeleteTutee @UserName = '"&Username&"'"
		End If ' big If statement checking if tutor or tutee
    End Function
		
		
		
%>
<!--#include file="getFunctions.asp"-->
