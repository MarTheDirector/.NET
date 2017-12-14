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
	<h3 style="text-align:center;">Below is a list of all your current times with your tutor(s).<br />
	</h3>
</div>
<div class="well">
<form name="" action="view-tutor.asp" method="post" >
<%

If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
	EstablishDBCON rsCurrStatus,conCurrStatus
	
	for each ID_Sel in Request.Form("TuteeTutorSections[]")
	
            'Response.write(ID_Sel)
            'split ID_Sel
            Choices = Split (ID_Sel, ",")
            ID= Choices(1)
            Selection = Choices(0)
       
            sqlString = "Select [Allow Two?],Status from Available_Times where ID ='"&ID&"'"
            rsCurrStatus.open sqlString
            
            spotStatus = rsCurrStatus("Status")
			CurrStatus = rsCurrStatus("Allow Two?")
            'Check Allows Two
			'Response.write("Current status is" &CurrStatus)
            rsCurrStatus.close
			if CurrStatus = Selection or Selection ="NA" then
				'Do no update
				'do yellow alert
				 Response.write("<div class='alert alert-caution'> Status unchanged for "&ID&" </div>")
               
			elseif CurrStatus <> Selection then
                
                 'if full2 then cant change
                  
                    
                 'if full then can change
                    if Selection = "No" then
                        newStatus = "Full" 
                    else
                        newStatus = "Open2"
                    end if
                 sqlString = "Update Available_Times set [Allow Two?]='"&Selection&"' ,Status='"&newStatus&"' where ID ='"&ID&"'"
                 ' Response.write(sqlString)
                     rsCurrStatus.open sqlString
                'else
                    'error
				'Do green update
				'green alert
				'Change allows2 and******** Status
				 Response.write("<div class='alert alert-success'> Status changed for "&ID&" from "&CurrStatus&" to "&Selection&"</div>")
			else
				Response.write("Error: 76")
            end if
    Next        

	
end if

EstablishDBCON rstutorinfo,conforinfo
EstablishDBCON rstutorcourses4,conforinfo4

TuteeName = Request.Cookies("user")("username")

sqlString = "exec dbo.ActiveTuteeTutors @UserName ='"&TuteeName&"'"
'Response.write sqlString
rstutorinfo.open sqlString

if rstutorinfo.eof = false then
		Response.write("<table class='table table-bordered'>")
		Response.write("<tr>")
		Response.write("<th colspan=9 style='text-align:center;'>Tutor Times</th>")
		Response.write("</tr>")
		Response.write("<tr>")
        
        Response.write("<td>ID</td>")
        Response.write("<td>Tutor Name</td>")
        Response.write("<td>Tutor Email</td>")
		Response.write("<td>Day</td>")
		Response.write("<td>Start Time</td>")
		Response.write("<td>Stop Time</td>")
		Response.write("<td>Course</td>")
		Response.write("<td>Allows Two?</td>")
        Response.write("<td>Change to allow two?</td>")
		Response.write("</tr>")
		
		'Count to keep track of which course to update
	
		Count = 0
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
                'Testing
               ' Response.write("The id is not printing: " &ID&" did something print between me?")
                'nvm i dont know how to spell id
                DisplayThisTime = StartTime & "-" & StopTime
                
                
                Response.write("<tr>")

                Response.write("<td>"&ID&"</td>")
                Response.write("</td>")

                Response.write("<td>")
                Response.write ("<a href='view-basic-info.asp?q="&UserName&"'>")
                Response.write(getRealName (UserName))
                Response.write ("</a>")
                Response.write("</td>")
                
                Response.write("<td>")
                Response.write(getTutorEmail (UserName))
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
                Response.write(getCourseTitle(Course))
                Response.write("</td>")

                Response.write("<td>")
                Response.write(Allows2)
                Response.write("</td>")

                 Response.write("<td>")
                 
                    
                
                
                     
                 Response.write("<select name='TuteeTutorSections[]'> ")
          		 if Status = "Full2" then
                 Response.write("<option value='NA,"&ID&"' >Unable to change: Contains 2</option>")
                 else
                'Have to lock if already full2
                 

                    if Allows2 = "Yes" then
                     Response.write("<option value='Yes,"&ID&"' selected='selected'  style='background-color:#ffc120' >Yes</option>")
                    Response.write("<option value='No,"&ID&"' >No</option>")

                    elseif Allows2 = "No" then
                     Response.write("<option value='No,"&ID&"'  style='background-color:#ffc120' selected='selected'>No</option>")
                    Response.write("<option value='Yes,"&ID&"' >Yes</option>")

                    end if
                
                 end if     
                Response.write("</select>")

                Response.write("</td>")

                Response.write("</tr>")
				
				count= count + 1
                rstutorinfo.movenext
         loop

		Response.write("</table>")
else
		NoTutor = true
    	Response.Write("You are not currently being tutored by any tutors.")

end if




%>

<a href="default.asp" class="btn btn-inverse">Back</a>
<%
if NoTutor <> true then
	Response.write("<a href='view-tutor.asp'><button type='submit' class='btn btn-primary'>Update Allows Two Status</button></a>")
end if
%>
</form>
</div>
  <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
</div>
</body>
</html>
