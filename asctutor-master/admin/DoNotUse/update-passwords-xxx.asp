<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header_For_Homepage.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
    <body>
	   <!--#include file="../includes/navbar-home.asp"-->
<!--#include file="../includes/sha256.asp"-->
<%

        EstablishDBCON rs2,con2	
        EstablishDBCON rs3,con3

        queryString = "select * from Users"
        rs3.Open queryString

        do until rs3.eof
    
            user_name = rs3("UserName")
            UpdatedPassWord = sha256( rs3("Password") & "xxMc4ppl3saUceBurgerKingxx")


            queryString = "Update Users Set Password = '"&UpdatedPassWord&"' where UserName = '"&user_name&"'"
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

