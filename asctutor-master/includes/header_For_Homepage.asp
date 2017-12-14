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
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-left: 10px;
        padding-right: 10px;
        padding-bottom: 60px;
      }
    </style>
<link rel="stylesheet" href="css/font-awesome.min.css">
<!--FontAwesome IE7 Support -->
<!--[if IE 7]>
<link rel="stylesheet" href="css/font-awesome-ie7.min.css">
<![endif]-->
<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<!-- Favicon -->
<link rel="shortcut icon" href="favicon.ico">

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
        getRealName = ""
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
		    .item(sch & "sendusername") = "myasctutortest@gmail.com"
		    .item(sch & "sendpassword") = "h2b00j33"
		    .item(sch & "smtpserverport") = 465
		    .item(sch & "sendusing") = 2
		    .item(sch & "smtpconnectiontimeout") = 30
		    .item(sch & "smtpusessl") = 1
		    .item(sch & "smtpauthenticate") = 1
		    .Update 
		End With


		' *********************************************
		'              SET MESSAGE DETAILS 
		' *********************************************
		with CreateObject("CDO.Message")
		  .configuration = config
		  .to = argToAddress 
		  .from = "myasctutortest@gmail.com"
		  .CC = "myasctutortest@gmail.com"
		  .subject = argSubject
		  .HTMLBody = argBody
		  call .send()
		end with
		
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
					'Swap values from tutee 1 column to tutee 2 to keep database consistancy
					rs_removetutee.open "Update Available_Times Set [Tutee 1] = '"&rs_delete("Tutee 2")&"', [Tutee 2] = '"&rs_delete("Tutee 1")&"' Where ([Tutee 1] = '"&rs_delete("Tutee 1")&"'AND [Tutee 2] = '"&rs_delete("Tutee 2")&"')"
					'Remove User from table
					rs_removetutee.open "exec dbo.DeleteTuteeTwo @UserName = '"&Username&"',@Course = '"&rs_delete("Course")&"'"

				Else
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