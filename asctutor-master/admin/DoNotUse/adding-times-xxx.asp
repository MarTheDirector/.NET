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
<%

        EstablishDBCON rs2,con2	
        EstablishDBCON rs3,con3

        queryString = "exec dbo.displayalltutors"
        rs3.Open queryString

        do until rs3.eof
    
            user_name = rs3("UserName")

            queryString = "exec dbo.AddNewTutorTimes @UserName = '"&user_name & "'"
            rs2.Open queryString

            rs3.movenext

        Loop

        rs3.Close 


 %>


      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>
    </body>
</html>
