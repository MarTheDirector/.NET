<% 
'  SqlCheckInclude.asp
'  Author: Nazim Lala
'
'  This is the include file to use with your asp pages to 
'  validate input for SQL injection.


Dim BlackList, ErrorPage, partialString

'
'  Below is a black list that will block certain SQL commands and 
'  sequences used in SQL injection will help with input sanitization
'
'  However this is may not suffice, because:
'  1) These might not cover all the cases (like encoded characters)
'  2) This may disallow legitimate input
'
'  Creating a raw sql query strings by concatenating user input is 
'  unsafe programming practice. It is advised that you use parameterized
'  SQL instead. Check http://support.microsoft.com/kb/q164485/ for information
'  on how to do this using ADO from ASP.
'
'  Moreover, you need to also implement a white list for your parameters.
'  For example, if you are expecting input for a zipcode you should create
'  a validation rule that will only allow 5 characters in [0-9].
'

BlackList = Array("<", ">", "(", ")", ";", "/*", "'", "*/", "@@")

'  Populate the error page you want to redirect to in case the 
'  check fails.

ErrorPage = "ErrorPage-Home.asp"
               
'''''''''''''''''''''''''''''''''''''''''''''''''''               
'  This function does not check for encoded characters
'  since we do not know the form of encoding your application
'  uses. Add the appropriate logic to deal with encoded characters
'  in here 
'''''''''''''''''''''''''''''''''''''''''''''''''''
Function CheckStringForSQL(str) 
  On Error Resume Next 
  
  Dim lstr 
  
  ' If the string is empty, return true
  If ( IsEmpty(str) ) Then
    CheckStringForSQL = false
    Exit Function
  ElseIf ( StrComp(str, "") = 0 ) Then
    CheckStringForSQL = false
    Exit Function
  End If
  
  lstr = LCase(str)
  
  ' Check if the string contains any patterns in our
  ' black list
  For Each partialString in BlackList
  
    If ( InStr (lstr, partialString) <> 0 ) Then
      CheckStringForSQL = true
      Exit Function
    End If
  
  Next
  
  CheckStringForSQL = false
  
End Function 


'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check forms data
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each partialString in Request.Form
  If ( CheckStringForSQL(Request.Form(partialString)) ) Then
  
    ' Redirect to an error page
    Response.Redirect(ErrorPage)
  
  End If
Next

'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check query string
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each partialString in Request.QueryString
  If ( CheckStringForSQL(Request.QueryString(partialString)) ) Then
  
    ' Redirect to error page
    Response.Redirect(ErrorPage)

    End If
  
Next


'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check cookies
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each partialString in Request.Cookies
  If ( CheckStringForSQL(Request.Cookies(partialString)) ) Then
  
    ' Redirect to error page
    Response.Redirect(ErrorPage)

  End If
  
Next


'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Add additional checks for input that your application
'  uses. (for example various request headers your app 
'  might use)
'''''''''''''''''''''''''''''''''''''''''''''''''''

%>