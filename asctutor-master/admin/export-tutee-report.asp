<%
		sub Write_CSV_From_Recordset(RS)
		
		    '
		    ' Export Recordset to CSV
		    ' http://salman-w.blogspot.com/2009/07/export-recordset-data-to-csv-using.html
		    '
		    ' This sub-routine Response.Writes the content of an ADODB.RECORDSET in CSV format
		    ' The function closely follows the recommendations described in RFC 4180:
		    ' Common Format and MIME Type for Comma-Separated Values (CSV) Files
		    ' http://tools.ietf.org/html/rfc4180
		    '
		    ' @RS: A reference to an open ADODB.RECORDSET object
		    '
		
		    if RS.EOF then
		    
		        '
		        ' There is no data to be written
		        '
		        exit sub
		    
		    end if
		
		    dim RX
		    set RX = new RegExp
		        RX.Pattern = "\r|\n|,|"""
		
		    dim i
		    dim Field
		    dim Separator
		
		    '
		    ' Writing the header row (header row contains field names)
		    '
		
		    Separator = ""
		    for i = 0 to RS.Fields.Count - 1
		        Field = RS.Fields(i).Name
		        if RX.Test(Field) then
		            '
		            ' According to recommendations:
		            ' - Fields that contain CR/LF, Comma or Double-quote should be enclosed in double-quotes
		            ' - Double-quote itself must be escaped by preceeding with another double-quote
		            '
		            Field = """" & Replace(Field, """", """""") & """"
		        end if
		        Response.Write Separator & Field
		        Separator = ","
		    next
		    Response.Write vbNewLine
		
		    '
		    ' Writing the data rows
		    '
		
		    do until RS.EOF
		        Separator = ""
		        for i = 0 to RS.Fields.Count - 1
		            '
		            ' Note the concatenation with empty string below
		            ' This assures that NULL values are converted to empty string
		            '
		            Field = RS.Fields(i).Value & ""
		            if RX.Test(Field) then
		                Field = """" & Replace(Field, """", """""") & """"
		            end if
		            Response.Write Separator & Field
		            Separator = ","
		        next
		        Response.Write vbNewLine
		        RS.MoveNext
		    loop
		
		end sub
%>
<%		
		'******************************************************
		'   Establish Connection to SQL server and Variables
		'******************************************************
		
	    Function EstablishDBCON (rsss, connn)
			
		set connn = server.CreateObject("adodb.connection") 'opens connection
		connn.Mode = 3
		connn.Open "Provider=sqloledb;SERVER=testsql.win.winthrop.edu;DATABASE=asc_tutor;UID=asc_tutor_access;PWD=TeachMeStuff"
		set rsss = server.CreateObject("adodb.Recordset")
		set rsss.ActiveConnection = connn
		
		end function
		
		EstablishDBCON rs0, con0
		dim RS1
		set RS1 = Server.CreateObject("ADODB.RECORDSET")
		    RS1.Open "exec dbo.tuteeFinalReport", con0, 0, 1
		
		Response.ContentType = "text/csv"

		Response.AddHeader "Content-Disposition", "attachment;filename=tutee_report.csv"
		
		Write_CSV_From_Recordset RS1
%>
