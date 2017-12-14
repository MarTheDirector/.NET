<%
Function Email (argToAddress, argSubject,argBody)

Set config = CreateObject ("CDO.Configuration")
sch = "http://schemas.microsoft.com/cdo/configuration/"

' **********************************************
' ****** SET AND UPDATE FIELDS PROPERTIES ******
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
' ************ SET MESSAGE DETAILS ************
' *********************************************
with CreateObject("CDO.Message")
  .configuration = config
  .to = argToAddress 
  .from = "myasctutortest@gmail.com" 
  .subject = argSubject
  .HTMLBody = argBody
  call .send()
end with

End Function
%>