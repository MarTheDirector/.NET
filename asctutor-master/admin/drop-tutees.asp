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
	<p style="text-align:center;" class="lead">Below is a list of all tutees.	You can click on "Drop" beside a tutee to drop them from a tutor.<br />
	The tutee, tutor, and administrator will be notified and the time slot that was taken by that tutee will be closed.<br />
	</p>
</div>

    <div class="well">
<form name=""  method="post" >

<select name="tutees" onchange="showUser(this.value)">
			<option value="">Select a tutee:</option>
<% 
EstablishDBCON rsforadmin,conforadmin
sql="SELECT UserName FROM Users where type = 'Tutee'"
			
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

<br />
<br />
 
 <div id="results"> Tutee's current times will be shown here </div>

          <script>
              function showUser(str) {
                  var xmlhttp;
                  if (str == "") {
                      document.getElementById("results").innerHTML = "Tutee's courses will be shown here";
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
                  xmlhttp.open("GET", "ajax-drop-tutees.asp?q=" + str, true);
                  xmlhttp.send();
              }
	</script>


</form>



<%
If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
     'Response.write("<div class='well'>")
EstablishDBCON rstutorinfo,conforinfo
EstablishDBCON rstutorcourses4,conforinfo4
EstablishDBCON rs_mail,con_mail

    
    DropSplit = split(Request.Form("Dropping"),",")
    Dropping = DropSplit(0)
    SlotDropped = DropSplit(1)   
	
		
        ID=Dropping
		'Response.write(ID & " is the id drop tutees is dropping status against </br>")
		
	    sqlString = "select * from Available_Times where ID = " & Dropping
	    'Response.write sqlString
	    rstutorinfo.open sqlString
	    
        Days = rstutorinfo("Day")
        StartTime=rstutorinfo("Start Time")
        StopTime=rstutorinfo("Stop Time")
        Status = rstutorinfo("Status")
        Tutee1= rstutorinfo("Tutee 1")
        Tutee2= rstutorinfo("Tutee 2")
        Selected = rstutorinfo("Tutor Selected")
        Allows2 = rstutorinfo("Allow Two?")
        Course = rstutorinfo("Course")
        TutorName = rstutorinfo("UserName")
        TutorEmail = getTutorEmail(TutorName)   

        DisplayThisTime = StartTime & "-" & StopTime
	    SlotInfo = Days & " " & DisplayThisTime & " with " & getRealName(TutorName) & " (" & TutorName & "), Time Slot ID: "& Dropping & ". "

        'Response.write(Status & " is the status drop tutees is dropping status against </br>")
        '**********************************
        'If only one student is in the tutor slot
        '*********************************
				if Status = "Open2" or Status = "Full" then
                        'Only have to deal with one tutee
                    
                        'Execute drop info on T1 
                         sqlString = "exec dbo.RegisterDrop @Tutee = '"&Tutee1&"' , @Tutor = '"&TutorName&"', @Course = '" &Course& "'"   
                         rstutorcourses4.open sqlString                        

	    				 sqlString = "exec dbo.getTuteeEmail @UserName ='"&Tutee1&"'"
                         rstutorcourses4.open sqlString
                         
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 
                         
                         'create append string for tutee/tutor
                         TuteeInfo = TuteeFullName & " for " & Course & " has been dropped from the time " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s by the administrator.<br />"
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to the tutor and tutees with this information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                         Response.Write("<br />")
						 rstutorcourses4.Close

						'Send info to Tutor email
						Email TutorEmail,"New Schedule Alert Drop", TuteeInfo
                         
						'Send info to TuteeName email
						Email TuteeEmail,"New Schedule Alert Drop", TuteeInfo
						 
                        '*********************************
						 'Update time slot to empty and decrease tutor hours
                         'Look at fixing TimeReset
						 sqlString = "exec dbo.TimeResetDecrement  @ID = "&Dropping&", @UserName = '"& TutorName & "'"

						 rstutorcourses4.open sqlString
                            
                        '&&&&&&&&&&&&&&&cgabged
	                     ReleaseTime(ID)	
    				  

		'**********************************
        'If two students are in the tutor slot
        '********************************* 
				elseif Status = "Full2"  then

                         if SlotDropped = 1 then

                                TuteeName = Tutee1
                                'Execute drop info on T1
                                sqlString = "exec dbo.RegisterDrop @Tutee = '"&Tutee1&"' , @Tutor = '"&TutorName&"', @Course = '"&Course&"'" 
                                rstutorcourses4.open sqlString

                         elseif SlotDropped = 2 then

                                TuteeName = Tutee2
                                'Execute drop info on T2
                                sqlString = "exec dbo.RegisterDrop @Tutee = '"&Tutee2&"' , @Tutor = '"&TutorName&"', @Course = '"&Course&"'"
                                rstutorcourses4.open sqlString
     
                         elseif SlotDropped = 3 then

                                'Email both
                                'Execute drop info on both
                                sqlString = "exec dbo.RegisterDrop @Tutee = '"&Tutee1&"' , @Tutor = '"&TutorName&"', @Course = '"&Course&"'" 
                                rstutorcourses4.open sqlString
                                
                                sqlString = "exec dbo.RegisterDrop @Tutee = '"&Tutee2&"' , @Tutor = '"&TutorName&"', @Course = '"&Course&"'" 
                                rstutorcourses4.open sqlString

                         end if
                            
                        

						 sqlString = "exec dbo.getTuteeEmail @UserName ='"&Tutee1&"'"
                         rstutorcourses4.open sqlString
                         
                            'having trouble here when droping slot 3
                         TuteeFName = rstutorcourses4("F_Name") 
                         TuteeLName = rstutorcourses4("L_Name") 
                         TuteeFullName = TuteeFName & " " & TuteeLName
                         TuteeEmail = rstutorcourses4("Email") 
                         TuteePhone= rstutorcourses4("PhoneNo") 

                         rstutorcourses4.close

                         sqlString = "exec dbo.getTuteeEmail @UserName ='"&Tutee2&"'"
                         rstutorcourses4.open sqlString

                          'We have to double this for tutee2
                         Tutee2FName = rstutorcourses4("F_Name") 
                         Tutee2LName = rstutorcourses4("L_Name") 
                         Tutee2FullName = Tutee2FName & " " & Tutee2LName
                         Tutee2Email = rstutorcourses4("Email") 
                         Tutee2Phone= rstutorcourses4("PhoneNo") 

                        
                        if SlotDropped = 1 then
                                
                         'create append string for tutee/tutor
                         TuteeInfo = TuteeFullName & " for " & Course & " has been dropped from the time " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s by the administrator.<br />"
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to the tutor and tutees with this information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")
                
                        elseif SlotDropped = 2 then

                         'create append string for tutee/tutor
                         TuteeInfo = Tutee2FullName & " for " & Course & " has been dropped from the time " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s by the administrator.<br />"
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to the tutor and tutees with this information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")


                        elseif SlotDropped = 3 then

                        ' create append string for tutee/tutor
                         TuteeInfo = TuteeFullName & "and "& Tutee2FullName &" for " & Course & " have been dropped from the time " & DisplayThisTime
                         TuteeInfo = TuteeInfo & " on " & Days & "s by the administrator.<br />"
                         TuteeInfo = TuteeInfo & "<br /> An email has been sent to the tutor and tutees with this information." 
                         Response.write("<div class='alert alert-success'>"&TuteeInfo&"</div>")

                        else
                        Response.write("Error: 77")
                        end if

                         
                         Response.Write("<br />")

						 rstutorcourses4.Close

                         Status2 = Status
							
							'Response.write (SlotDropped & " is the slot dropped before release " & Status & " is the status. </br>")
							
                         'ReleaseTime(ID)
							
							'release time is changing status somehowad
							'************
							'Response.write (SlotDropped & " is the slot dropped after release. " & Status & " is the status. </br>")	
							
                        Status = Status2

						'Send info to Tutor email
						 Email TutorEmail,"New Schedule Alert", TuteeInfo
                         
                            
                         
                            if SlotDropped = 1 then
                            GetRecord rs_mail,"Tutee",Tutee1
						    'Send info to Tutee1Name email
						     Email rs_mail("Email"),"New Schedule Alert", TuteeInfo
						     rs_mail.close

                            elseif SlotDropped = 2 then
						    'Send info to Tutee2Name email
						     GetRecord rs_mail,"Tutee",Tutee2
						     Email rs_mail("Email"),"New Schedule Alert Drop", TuteeInfo
                             rs_mail.close

                            elseif SlotDropped = 3 then

                             'Send info to Tutee1Name email
                             GetRecord rs_mail,"Tutee",Tutee1
						     Email rs_mail("Email"),"New Schedule Alert Drop", TuteeInfo
						     rs_mail.close
                             'Send info to Tutee2Name email
						     GetRecord rs_mail,"Tutee",Tutee2
						     Email rs_mail("Email"),"New Schedule Alert Drop", TuteeInfo
                              rs_mail.close
                            end if
						
                         '*********************************

						'Update time slot to empty 
                        '*******
                        '
                        'UPDATE COURSE, STATUS Correctly.
                        'full2 shows up on drop 1
                        'hours for tutor
                        'update tuteetimedropentireslot

						'Response.write (SlotDropped & " is the slot dropped. " & Status & " is the status. </br>")

                        if SlotDropped = 1 and Status = "Full2" then

						    sqlString = "exec dbo.TuteeTimeDropFull2  @ID = "&Dropping&", @TuteeName = '"& Tutee2 & "'"
						    rstutorcourses4.open sqlString
                            Response.write("<div class='alert alert-success'>"&getRealName(Tutee1)&" ("&Tutee1&") has been dropped from " &SlotInfo&" </div>")
							'decrease hours no

							
                        elseif SlotDropped = 2 then
							
							
                            sqlString = "exec dbo.TuteeTimeDropFull2  @ID = "&Dropping&", @TuteeName = '"& Tutee1 & "'"
						    rstutorcourses4.open sqlString
                            Response.write("<div class='alert alert-success'>"&getRealName(Tutee2)&" ("&Tutee2&") has been dropped from " &SlotInfo&" </div>")
                            'decrease hours no

                        elseif SlotDropped = 3 then

                            'Reset record to empty everything for now
                            'check 3 procedures
                            'Reset everything to empty and open time
                            'if we drop everyone then we have to check if other times surround...we have to unlcok the time i think
                            'unlock should be fine, if it's still working. 
                            sqlString = "exec dbo.TuteeTimeDropEntireSlot  @ID = '"&Dropping&"'"
                            
                            'decrement hours yes change course

                            
						    rstutorcourses4.open sqlString
                                
                             sqlString = "update Tutor set U_Hours = U_Hours - 1 where UserName = '"&TutorName &"'"

                             rstutorcourses4.open sqlString

                            if (Tutee1 <> "EMPTY" and Tutee2 <> "EMPTY" ) then

                                    Response.write("<div class='alert alert-success'>"&getRealName(Tutee1)&" ("&Tutee1&") and" &getRealName(Tutee2)&" ("&Tutee2&") have been dropped from " &SlotInfo&" </div>")
                            elseif Tutee1 = "EMPTY" then
                                     Response.write("<div class='alert alert-success'>"&getRealName(Tutee2)&" ("&Tutee2&")  has been dropped from " &SlotInfo&" </div>")
                            elseif Tutee2 = "EMPTY" then
                                     Response.write("<div class='alert alert-success'>"&getRealName(Tutee1)&" ("&Tutee1&")  has been dropped from " &SlotInfo&" </div>")
                            else
                                    Response.write ("Somehow got here. Alert admin.")
                            end if

				        else

                            Response.write ("Error: 053 ")
                            'hitting this error on droping student one with two

				        end if
						
	        else
		        Response.Write ("No times dropped because no times selected.")
	        end if

	rstutorinfo.close
	
end if
'end of post request

%>
        <hr />
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
        </div>
</div>
</body>
</html>
