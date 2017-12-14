<%
    Function safe_drop_person(Username)

        EstablishDBCON rs23, con23
        EstablishDBCON rs25, con25
        EstablishDBCON rs26, con26

        GetRecord rs23, "Users",Username

        If rs23("type") = "tutee" Then
            GetRecord rs26, "Tutee",Username
            Drop_Class Username, "Tutee", rs26("Course1")
            Drop_Class Username, "Tutee", rs26("Course2")

            'set email
            toemail = rs26("Email")

            'clear user from tutee table
			queryString= "DELETE FROM Tutee WHERE UserName= '" & Username & "'"
			rs25.Open queryString
        else
            GetRecord rs26, "Tutor",Username
            Drop_Class Username, "Tutor", rs26("Course1")
            Drop_Class Username, "Tutor", rs26("Course2")
            Drop_Class Username, "Tutor", rs26("Course3")
            Drop_Class Username, "Tutor", rs26("Course4")
            Drop_Class Username, "Tutor", rs26("Course5")

            'set email
            toemail = rs26("Email")

            'clear user from tutor table
			queryString="DELETE FROM Tutor WHERE UserName= '" & Username & "'"
			rs25.Open queryString
        end if

        ' clear user from users table
			queryString="DELETE FROM Users WHERE UserName= '" & Username & "'"
			rs25.Open queryString


            Subject = "You have been removed from the ASC Tutoring System"
            Body = "Username: "&Username
            Email toemail,Subject,Body




    End Function




 %>