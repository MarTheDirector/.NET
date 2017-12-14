<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Upload File</title>
<%
    Dim fileName
    Set fileName = Request.Form("File")
    Response.write(fileName)

    Dim fs, f
   Set fs = Server.CreateObject("Scripting.FileSystemObject")
    Set f = fs.GetFile(fileName)
    Response.Write("File created: " & f.DateCreated)
    Set f = nothing
    Set fs = nothing
%>
</head>
<body>

</body>
</html>
