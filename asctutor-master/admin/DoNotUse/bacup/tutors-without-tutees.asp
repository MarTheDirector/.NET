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


    <table class="table table-bordered">
    <tr><td colspan="2" style="text-align:center; font-size:x-large; font-weight:bold;">Total Tutors Without Tutees</td></tr>
    <tr><td><b> User Name </b></td><td><b> Email </b></td></tr>
    <%
    'Check if empty or else error is shown, skip all of this if empty
    Query = "Select ID from Available_Times Where [Tutee 1] <> 'EMPTY' AND [Tutee 2] <> 'EMPTY'"
    Query1 = "Select [UserName] From Tutor"
    Dim TutorArray()

	EstablishDBCON rsReport, conReport 
    EstablishDBCON rsReport1, conReport1 
    EstablishDBCON rsReport2, conReport2
    EstablishDBCON rsGetRecord, conGetRecord

    rsReport.Open(Query) 'Get list of used IDs
    rsReport2.Open(Query1) 'Get list of Tutors

    count = 0
    Do Until rsReport2.EOF
        
        Redim Preserve TutorArray(count) 
        TutorArray(count) = rsReport2("UserName")
        rsReport2.movenext
        count = count + 1
    Loop
    rsReport2.close



    do until rsReport.EOF
        rsReport1.Open("Exec dbo.ReturnTutorFromID @ID = '"& rsReport("ID") & "'") 'Get username to remove from tutor array
            value = rsReport1("UserName")
            b = Filter(TutorArray,rsReport1("UserName"),False) 'Return list of tutors with selected name filtered out
            redim TutorArray(UBound(b)) 
            for counter = 0 to UBound(b)
                TutorArray(counter) = b(counter)
            next
        rsReport1.close
        rsReport.movenext
    Loop

    counter = 0


    if UBound(TutorArray) >= 0 then
        For each value in TutorArray

            GetRecord rsGetRecord, "Tutor",value
            Response.Write("<tr><td>" & value & "</td><td>" &rsGetRecord("Email") & "</td></tr>")
            rsGetRecord.Close
            counter = counter + 1          
        Next
    Else
        Response.Write("<tr colspan = 4><td>Everyone Is Scheduled</td></tr>")
    End IF
%>
<tr>
    <td colspan = 4><p><b>Total: <%Response.Write(counter)%></b></p></td>
</tr>	
</table>

<a href="report.asp" class="btn btn-inverse">Back</a>
  <hr>
  <footer>
        <!--#include file="../includes/footer.asp"-->
  </footer>
  
</div>
</body>
</html>
