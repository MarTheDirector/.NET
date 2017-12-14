<%@ Language=VBScript %>
<%
  '//////////////////////////////////////////////////////////////////////////////////
  '//  ASPFileUpload.File API
  '//  
  '//  Properties
  '//     FileName
  '//       - Read/Write 
  '//       - The file will be saved with this file name. 
  '//       - This property can only be set before calling Upload.
  '//       - If no value is specified, the original file name
  '//       - in the HTTP post will be used.
  '//     
  '//     OverWrite
  '//       - Read/Write
  '//       - This property can only be set before calling Upload.
  '//       - If set to false and if the destination file exists, an error
  '//       - is raised. The default value is False.
  '//     
  '//     Target 
  '//       - Read/Write
  '//       - The file will be written to this folder.
  '//       - This property can only be set before calling Upload.
  '//       - There is no default value for this property and it is required.
  '//       
  '//      Form
  '//        - ReadOnly
  '//        - Scripting.Dictionary object
  '//        - Can access a specific item by using aspfileupload.Form("item").
  '//        - Acts like the asp form collection.
  '//        - Can enumerate all values in a collection with for each.
  '//        - Only filled after the Upload method is called.
  '//         
  '//  Methods
  '//     Upload
  '//       - This method parses the HTTP Post and writes the file.
  '//  
  '//  Other
  '//    - ASPFileUpload requires COM+
  '//    - Any call to the Request.Form() collection will cause the Upload
  '//      method to fail as the method references the Binary contents of the
  '//      Request object through the Request.BinaryRead method. 
  '//    - Also, if you access a variable in the Request collection without 
  '//      specifying the subcollection that it belongs to, the Request.Form collection 
  '//      may be searched. This causes an error in the Upload method.
  '//      
  '//////////////////////////////////////////////////////////////////////////////////
  
  Dim strMsg 'As String
  
 ' On Error Resume Next
  dim fuFile
  set fuFile = server.CreateObject("aspFileupload.file")  
  'Set the destination folder.
  fuFile.Target = "C:\TEMP\AspFileUpload\"
  fuFile.Upload
  
  If Err.number = 0 Then
    strMsg = fuFile.FileName  & " was uploaded successfully."
  Else
    strMsg = "An error occurred when uploading your file: " & Err.Description 
  End If
  for each o in fuFile.Form
	Response.Write o  & "<BR>"
	
	next
	
	Response.Write fuFile.Form.item("text1") & "  :  " & fuFile.Form.item("text2")
'  Response.Write Request.Form("test")
 set fufile = nothing
%>
<html>
<head></head>
<body>
<%=strMsg%>
</body>
</html>