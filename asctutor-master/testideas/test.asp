<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title>Untitled 1</title>
<!--#include file="test ideas/emailer.asp"-->
<!--#include file="includes/header.asp"-->
</head>

<body>

<%
    Course_Section = "Course_Section"
    Tutor_Section = "Tutor_Section"
    Time_Section = "Time_Section"
    Tutee = "Tutee"
    Tutor = "Tutor"
    ResetCourse = ""
    Username = "Username"
    resetCourse = "resetCourse"

        ' *********************************************
		'    Function designed to return user's first and last name as one string
		' *********************************************
        ' Function UserNameToRealName(UserName,UserType)
        'takes in username and usertype
        'EstablishDBCON rs13,con13
        'queryString = "Select F_Name, L_Name from " & UserType & " where UserName = '" & UserName &  "'"
                    'L_Name, F_Name
                    'Response.write(queryString)
          '          rs13.open queryString 
         '           UserFName = rs13("F_Name")
           '         UserLName = rs13("L_Name")
            '        UserNameToRealName = UserFName & " " & UserLName
        'End function




        '***************************************'
        'Simple Demonstration of execution of Stored Procedure and
        'output is sent to the result set.
        '**************************************'
        EstablishDBCON rs13,con13
        sqlString ="exec dbo.displayalltutees"
        rs13.open sqlString

        


        do until rs13.eof 
        Response.write(rs13("UserName") & "<br />")
        rs13.movenext
        loop

        '***************************************'
        'Simple Demonstration of execution of Stored Procedure and
        'output is sent to the result set.
        'Pass parameters as shown below
        '**************************************'

        rs13.close
        sqlString ="exec dbo.displayspectutorinfo @UserName = 'tutor1' "
        
        rs13.open sqlString

        do until rs13.eof 
        Response.write(rs13("UserName") & "<br />")
        rs13.movenext
        loop

%>

</body>

</html>
