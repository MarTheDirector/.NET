<!--#include file="../includes/header.asp"-->

<%
response.expires=-1

TempVar = request.querystring("q")
CourseAndID = split(TempVar,",")
Course = CourseAndID(1)
ID = CourseAndID(0)
TuteeUserName= CourseAndID(2)
'Response.write(ID)
'Response.write("<br />")
'Response.write(Course)

'sql=sql & "'" & request.querystring("q") & "'"

'*********************
'This Ajax page is the one that actually posts to P3
'***************
Response.Write("<form class='form-horizontal' name='addCourse' action='find-tutor-for-tutee-p4.asp' onsubmit='return validateForm()' method='post'>")
Response.write("<input type='hidden' name ='tuteename' value='"&TuteeUserName&"'>") 
    
   ' Response.write("<input type='hidden' name ='tuteename' value='"&UserName&"'>") 

EstablishDBCON rsfortutee,confortutee
'rsfortutee.Open sqlString,confortutee

    sqlString ="Select * FROM Available_Times Where ID="&ID

    rsfortutee.open sqlString

    TutorName=rsfortutee("UserName")
    IDSTATUS=rsfortutee("Status")
    Days = rsfortutee("Day")
    StartTime=rsfortutee("Start Time")
    StopTime=rsfortutee("Stop Time")
    Selected = rsfortutee("Tutor Selected")
    ID = rsfortutee("ID")
    DisplayThisTime = StartTime & "-" & StopTime
    Disabled =""

    rsfortutee.close

    sqlString = "Select M_Hours, U_Hours from Tutor where UserName = '"&TutorName&"'"
    rsfortutee.open sqlString
    M_Hours = rsfortutee("M_Hours")
    U_Hours = rsfortutee("U_Hours")
    rsfortutee.close
    'i could just or status=open2 here
if M_Hours > U_Hours then

    sqlString="SELECT * FROM Available_Times Where ID="&ID
    rsfortutee.open sqlString
                if rsfortutee.eof = false then
                    UserName= rsfortutee("UserName")
                    Days = rsfortutee("Day")
                    StartTime=rsfortutee("Start Time")
                    StopTime=rsfortutee("Stop Time")
                    Status = rsfortutee("Status")
                    Tutee1= rsfortutee("Tutee 1")
                    Tutee2= rsfortutee("Tutee 2")
                    Selected = rsfortutee("Tutor Selected")
                    ID = rsfortutee("ID")
                    pass = false

                    DisplayThisTime = StartTime & "-" & StopTime

                    Disabled =""

                    if Status = "Open" or Status = "Open2" then
                        'more ifs
                        'pass = true
                    end if
                    
                    'Change this logic to check if status = Open2
                    if Status = "Open2" then
                        Response.write("<div class='alert alert-success'>")
                        Response.Write("This time slot is currently allowing two people. There is already one person in it.<br />")
                        Response.Write("Choosing this time slot means you understand this is a group tutoring session of two people.")
                        Response.Write("<input type='hidden' name='twopeople' value='Forced'><br />")
                        Response.Write("<input type='hidden' name='date' value='"&ID&"'><br />")
                        Response.Write("<input type='hidden' name='course' value='"&Course&"'><br />")
                    elseif Status = "Open" then 
                        Response.write("<div class='alert alert-success'>")
                        Response.write("Allow this time slot to have two people?<br /><br />")
                        Response.write("<label><input type='radio' name='twopeople' value='Yes'>Yes</label>")
                        Response.write("<label><input type='radio' name='twopeople' value='No'>No</label>")
                        Response.Write("<input type='hidden' name='date' value='"&ID&"'>")
                        Response.Write("<input type='hidden' name='course' value='"&Course&"'><br />")
                    else
                        Response.write("<div class='alert alert-error'>")
                        Response.write("This course has been selected since you loaded the page. Refresh the page and click continue <br />")
                        Response.write("to recieve an updated list of courses. <br />")
                   
                    end if

                    Response.write("The time you have chosen is: ")
                    Response.write(DisplayThisTime)
                    Response.write(" on " &Days &" with "& getRealName (UserName))
                    Response.write("</div>")
                    'Check tons of logic zzzzzzz
                    'If person could allow two then check
                    'If person picked a time that was allow two
                    'Are they tutee 1 or tutee 2

                    'if pass = true then
                    'sqlString = 'Update time set Tutee1="", status ="" where ID = &ID&
                    'rstutorcourses4.open sqlString

                else
                    Response.write("An error has occurred, please try finding a tutor again.")
                end if

                if (Status = "Open" or Status = "Open2") then
                
                else
                Disabled = "Disabled"
                end if

                Response.Write("<div class='form-actions'>")
				Response.Write("<button class='btn btn-primary' id ='final' onclick = document.getElementById('final').style.display='none' type='submit' "&Disabled&">Submit</button>")
				Response.Write("&nbsp;")
				Response.Write("<a href='default.asp' class='btn btn-inverse'>Back</a></div>")
                Response.Write("</form>")
else

                'check before we say max
                    If IDSTATUS = "Open2" then
                        Response.write("<div class='alert alert-success'>")
                        Response.Write("This time slot is currently allowing two people. There is already one person in it.<br />")
                        Response.Write("Choosing this time slot means you understand this is a group tutoring session of two people.")
                        Response.Write("<input type='hidden' name='twopeople' value='Forced'><br />")
                        Response.Write("<input type='hidden' name='date' value='"&ID&"'><br />")
                        Response.Write("<input type='hidden' name='course' value='"&Course&"'><br />")       

                        Response.write("The time you have chosen is: ")
                        Response.write(DisplayThisTime)
                        Response.write(" on " &Days &" with "& getRealName (TutorName))
                        Response.write("</div>")

                        Response.Write("<div class='form-actions'>")
				        Response.Write("<button class='btn btn-primary' id ='final' onclick = document.getElementById('final').style.display='none' type='submit' "&Disabled&">Submit</button>")
				        Response.Write("&nbsp;")
				        Response.Write("<a href='default.asp' class='btn btn-inverse'>Back</a></div>")
                        Response.Write("</form>")                    

                    else
                        Response.write("<div class='alert alert-error'>")
                        Response.write("This tutor's hours have surpassed the maximum. <br />")
                   end if
end if
%>

