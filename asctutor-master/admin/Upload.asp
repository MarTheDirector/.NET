<html>

    <!--#INCLUDE FILE="clsUpload.asp"-->
    <!-- #include file="csv.asp" -->
    <!--#include file="../includes/header.asp"-->
    <!--#include file="../includes/navbar-admin.asp"-->
<head>
    <title>File Upload</title>
    <!--
             Name:  Tutor Schedule Courses Table Update 
             Written By:  Ethan Hanner, Marcus Nesbitt, Courtney Stokes, Tara Slabich
             System:  Part of the Tutor Schedule Update component of the ASC Tutor Schedule Portal 
             Created: Spring 2015
             Purpose: Read file selected in Form.asp and upload into the Courses table of asc_tutor database.
             How:   ASP script truncates the Courses table in the asc_tutor database, loads the .csv file selected 
                    by Form.asp, and then uses a SQL statement to load the data from the .csv file into the Courses table.
     -->
</head>

<body>
<%
    Dim Upload
    Dim FileName
    Dim Folder
    Dim FullPath
    Dim Ext
    'Instantiate Upload Class
    Set Upload = New clsUpload 
    'Limit file extension types to .csv
    Ext = Upload("File1").FileExt
    Select Case Ext
        Case "CSV"
    ' upload the file to the server
            FileName = Upload("File1").FileName 
    'Response.Write(FileName)
            Folder = Server.MapPath("Code/Uploads") & "/"    
    'Response.Write(Folder) 
            Upload("File1").SaveAs Folder & Upload("File1").FileName
                
    FullPath = "Code/Uploads/" & Upload("File1").FileName 
     
            
    
    
    
    EstablishDBCON rs4,con4

    ' read the file, and insert each record into the Courses table of the database
    ' fields are separated by commas and values that contain commas are delimited with
    ' quotation marks
    ' Value1() is a multidimensional array that holds the data read in from the file
    ' the data is accessed by row, column
            DIM Value1(),NumberOfLines,RowCounter,ColCounter,NumberOfItems
            NumberOfLines = CsvRead(FullPath,Value1,NumberOfItems,",")
            Response.Write("<div class='lead container'>")
            Response.Write("<h2>Upload Results</h2>")
            Response.Write("<p id='numCourses'>Number of Courses in <B>" & Upload("File1").FileName & "</B>: <B>" & NumberOfLines+1 & "</B></p>")
            Response.Write("</div>")
            ' erase the previous data from the table
            queryString= "Delete from Course;"
            rs4.Open(queryString)

            ' insert the new data into the table
            Dim queryString
            Dim numCoursesInserted
            numCoursesInserted = 0
            if NumberOfLines > -1 then
                for RowCounter = 0 to NumberOfLines
                    queryString = "INSERT INTO Course (Course,Title,Instructor,Section,Location,Time,Days) VALUES ("
                    ' insert into Course (col name) values (Value1(Counter, 0), Value1(Counter,1)...);
                    for ColCounter = 0 to NumberOfItems
                        if ColCounter = 0 then
                        ' check to make sure there is a value for the CRN (Primary Key)
                            if Value1(RowCounter, ColCounter) = "" then
                                ' no value entered for CRN, notify user
                                Response.Write("<div class='lead container'>")
                                Response.Write("<p>This course was not uploaded into the database because a CRN was not provided:</p>")
                                Response.Write("<div id='crnBlank'>")
                                Response.Write("<p><b>Title:</b> " & Value1(RowCounter, 1) & "</p>")
                                Response.Write("<p><b>Instructor:</b> " & Value1(RowCounter, 2) & "</p>")
                                Response.Write("<p><b>Section:</b> " & Value1(RowCounter, 3) & "</p>")
                                Response.Write("</div>")
                                Response.Write("<hr class='shortRule'>")
                                Response.Write("</div>")
                                ' set the ColCounter to 1 more than NumberOfItems so this record will be skipped
                                ColCounter = NumberOfItems + 1
                            else
                                queryString = queryString & "'" & Value1(RowCounter, ColCounter) & "',"
                            end if
                        else
                            queryString = queryString & "'" & Value1(RowCounter, ColCounter) & "'"
                            if ColCounter <> NumberOfItems then
                            ' if it's not the last value for this row, add a comma
                                queryString = queryString & ","
                            end if
                        end if
                    next
                    ' if the record had a CRN, submit the query to the database
                    if Value1(RowCounter, 0) <> "" then
                        queryString = queryString & ");"
                        rs4.Open(queryString)
                        numCoursesInserted = numCoursesInserted + 1
                    end if
                next
                Response.Write("<p class='lead container'>Number of Courses inserted into the database: <b>" & numCoursesInserted & "</b></p>")  

                ' if the number of courses inserted matches the number of courses found in the file, print a success message
                if numCoursesInserted = NumberOfLines +1 then
                    Response.Write("<p class='lead container'>All course information has been successfully updated.</p>")
                end if
            end if
        Case Else
            Response.Write("<div class='lead container'>")
            Response.Write("<p>File type is not supported or no file was selected.  Please make sure the correct file was select.  Contact the system administrator for assistance.</p>")
            Response.Write("</div>")
    End Select

    Set Upload = Nothing


%>
    <br /><br />
    <div class="container">
        <a href="default.asp" class="btn btn-primary">Go back to home</a>
    </div>
</body>
</html>