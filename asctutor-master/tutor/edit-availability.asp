<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
<!--#include file="../includes/navbar-tutor.asp"-->

<div class="container">
<div class="well">
	<h4>Please pick your available times for tutoring.</h4>
	<p>A grayed out or disabled checkbox means that somebody already signed up to be tutored for that open time slot.</p>
</div>
<div class="well">
<form id="TimeForm" action="edit-availability.asp" method="post" >
    <%
    EstablishDBCON rstutoravail,conforavail
    EstablishDBCON rstimeupdate,conforupdate
    'change to request cookie
    
    UserName = Request.Cookies("user")("username")
    
     If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
       removeID = ""
       if len("Date[]") > 1 then

        '***********************************
        'Grab array length, Ubound not working
        '*********************************
        upperbound=0
        setOpened =""

        for each ID_Sel in Request.Form("Date[]")

        upperbound = upperbound+1

        next


        for each ID_Sel in Request.Form("Date[]")
            'debug line 
            'response.write(ID_Sel&"<br/>")
            'for each time submitted, get all this info
            queryString = "Select * from Available_Times where ID ="&ID_Sel
            rstutoravail.open queryString

            'put all info on specific time selected into vars
            'updating each time that isn't already affected to open
            TutorName= rstutoravail("UserName")
            Days = rstutoravail("Day")
            StartTime=rstutoravail("Start Time")
            StopTime=rstutoravail("Stop Time")
            Status = rstutoravail("Status")
            Tutee1= rstutoravail("Tutee 1")
            Tutee2= rstutoravail("Tutee 2")
            Selected = rstutoravail("Tutor Selected")
            ID = rstutoravail("ID")
            rstutoravail.close

        if (Status = "Open2" or Status = "Full" or Status = "Full2" or Status = "OpenC" ) then
        'do nothing

        elseif (Status = "ClosedC") then
            query = "Update Available_Times set [Tutor Selected] = 'Yes', Status = 'OpenC' where (UserName ='"&UserName&"') and ID="&ID_Sel&""
            rstutoravail.open query
        else 
        'set status to open
        'rstutoravail.close
            query = "Update Available_Times set [Tutor Selected] = 'Yes', Status = 'Open' where (UserName ='"&UserName&"') and ID="&ID_Sel&""
            rstutoravail.open query
        end if

        '****************
        'Not sure what removeID is yet
        if upperbound - 1 <> count then
            removeID = removeID & "  ID<>"&ID_Sel&" and "
        else
            removeID = removeID & "  ID<>"&ID_Sel&"  "
        end if

        count = count +1
        
        next

        'response.write(removeID)
        removeID =  removeID & ")"
        query = "select Status,ID from Available_Times where (UserName = '"&TutorName&"' ) and ("&removeID
        'Response.write (query)
        rstutoravail.open query


        'Update unselected slots to closed or closedC
        '
        EstablishDBCON rstutorclose,conforclose

        do until rstutoravail.eof
            Status = rstutoravail("Status")
            ID = rstutoravail("ID")

            if Status = "Open" then
                
                'Response.write(query&"<br/>")
                query = "Update Available_Times set Status = 'Closed',[Tutor Selected] = 'No' where (UserName ='"&UserName&"') and ID="&ID
                rstutorclose.open query

            elseif Status = "ClosedC" or Status = "OpenC"  then
                
                query = "Update Available_Times set Status = 'ClosedC',[Tutor Selected] = 'No' where (UserName ='"&UserName&"') and ID="&ID
                rstutorclose.open query

            elseif Status = "Closed" then
              
                query = "Update Available_Times set Status = 'Closed',[Tutor Selected] = 'No' where (UserName ='"&UserName&"') and ID="&ID
                rstutorclose.open query

            else
                Response.write ("Something wrong. Error: 077")

            end if

            rstutoravail.movenext
        Loop
        rstutoravail.close

            'Whether or not to show the alert up top when they first log in
            queryString = "Update AdditionalInformation set TimeChanges = TimeChanges + 1 where Username = '"& userName &"'"
            rstimeupdate.open queryString
            response.write("<div class='alert alert-success'>Your times have been updated</div>")
        end if 'anything submmitited
    end if 'If post



    '************************************
    'Prints off all times and if they are taken or not, etc
    '*********************************
    query = "Select * from Available_Times where UserName ='" & UserName & "'"
    'query = "Update Available_Times set [Tutor Selected] =" 
    rstutoravail.open query

    CurrentDay=""
    Response.Write("<div class='accordion' id='accordion2'>")
    counter = 0
    
    do until rstutoravail.eof
        'UserName= rstutoravail("UserName")
        Days = rstutoravail("Day")
        StartTime=rstutoravail("Start Time")
        StopTime=rstutoravail("Stop Time")
        Status = rstutoravail("Status")
        Tutee1= rstutoravail("Tutee 1")
        Tutee2= rstutoravail("Tutee 2")
        Selected = rstutoravail("Tutor Selected")
        ID = rstutoravail("ID")

        DisplayThisTime = StartTime & "-" & StopTime

        Tutees = ""

        if Tutee1 <> "EMPTY" then
            Tutees = Tutees & getRealName (Tutee1) 
        end if
        if Tutee2 <> "EMPTY" then
            Tutees = Tutees & ", " & getRealName (Tutee2) 
        end if

        Checked = ""
        Disabled =""
        ReadOnly = ""

        'if Selected = "Yes" then
        if Status="Open" or Status="OpenC" or Status = "Open2" or Status = "Full" or Status = "Full2" then '(Tutee1 <> "EMPTY" or Tutee2 <> "EMPTY") then
            Checked = "Checked "
        end if

        if Status = "Open2" or Status = "Full" or Status = "Full2" then '(Tutee1 <> "EMPTY" or Tutee2 <> "EMPTY") then
            Disabled =" Disabled"
            'ReadOnly =" readonly ='readonly'"
        end if

        if CurrentDay <> Days then
            CurrentDay = Days
            if counter > 0 then
                Response.Write("</div></div></div>")
            end if
            Response.Write("<div class='accordion-group'>")
            Response.Write("<div class='accordion-heading'>")
            Response.Write("<a class='accordion-toggle' data-toggle='collapse' data-parent='#accordion2' href='#collapse" & counter & "'>" & currentDay & "</a>")
            Response.Write("</div>")
            Response.Write("<div id='collapse" & counter & "' class='accordion-body collapse'>")
            Response.Write("<div class='accordion-inner'>")

            'Response.Write("<b>" &CurrentDay&"</b><br />")
        end if

        'Response.write ("<input type='checkbox' name='Date[]' value ='"&Days&"+"&DisplayThisTime&"'"&Checked&Disabled&">"&DisplayThisTime&"<br />" )
        Response.Write("<label class='checkbox'><input type='checkbox' name='Date[]' value ='"&ID&"'"&Checked&Disabled&ReadOnly&">"&DisplayThisTime&" "&Tutees&"</label>" & VbCrLf)
         if Disabled = " Disabled" then
            Response.Write("<input type='hidden' name='Date[]' value ='"&ID&"'>" & VbCrLf)
         end if
        'Response.write ("<input type='checkbox' name='Date[]' value ='"&ID&"'"&Checked&Disabled&">"&DisplayThisTime&"<br />" )
        'remove br on above line and write out the tutees currrently using this slot next to it

        rstutoravail.movenext
        counter = counter + 1
    loop
    Response.Write("</div></div></div></div>")
    %>

    <button type="submit"  class="btn btn-primary">Submit</button>
    <a href="default.asp" class="btn btn-inverse">Back</a>
</form>
</div>
  <footer>
    <!--#include file="../includes/footer.asp"-->
  </footer>
</div>
</body>
</html>