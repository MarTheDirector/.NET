<%

        ' *********************************************
		'    Function designed to safely drop a class
		' *********************************************
        Function safe_drop_time (Username, Table, Day, Scheduled_Time)

            Dim Tutor, Time_Section, Tutor_Section,Course_Section,resetCourse,resetSection,theTime, Query
			resetCourse = "EMPTY"
			resetSection = ""
			
			' Establish Database Connections and RecordSets
				EstablishDBCON rs11, con11 'Tutee Table Connection
				EstablishDBCON rs12, con12 'Tutor Table Connection
			
				If Table = "Tutee" Then
                
                ' Establish recordset for all tutees with a given time slot and tutor   
				    EstablishDBCON rs13, con13 'Tutor Table Connection

				' Pull tutee information from the database
					GetRecord rs11, Table, Username

				' Find the column the desired time is located in
					If Scheduled_Time = rs11("Course1Time") Then
						Tutor = rs11("Tutor1")
						theTime = Split(rs11("Course1Time"),",")
						Time_Section = "Course1Time"
						Tutor_Section = "Tutor1"
					Else
						Tutor = rs11("Tutor2")
						theTime = Split(rs11("Course2Time"),",")
						Time_Section = "Course2Time"
						Tutor_Section = "Tutor2"
					End If

                ' Drop Tutee Table time slot/tutor
					Drop_Time_Tutee Username, Time_Section,Tutor_Section

                ' Find all Tutee's with the desired Tutor
					Query = "Select * From Tutee WHERE (Tutor1= '"&Tutor&"' OR Tutor2='"&Tutor&"') AND (Course1Time= '"&Scheduled_Time&"' OR Course2Time='"&Scheduled_Time&"'); "
					rs13.Open(Query)
				
				' Test if Tutee has a tutor Scheduled
                    If rs13.EOF Then
				        If Tutor <> "" Then
				        ' Pull Tutor information from the database
					      GetRecord rs12, "Tutor",Tutor
					
				        ' Retrieve Used Times
					        Temp = Split(rs12("Used"&Day,",")
					
				        ' Update Tutor Table Info
					        Drop_Time_Tutor Temp,theTime,Tutor
				        End If
                    End If
					
					
				Else
				
				EstablishDBCON rs10, con10 'Tutee Table Update Connection
				
				' Pull Tutor information from the database
					GetRecord rs12, Table, Username
					
				' Find all Tutee's with the desired Tutor
					Query = "Select * From Tutee WHERE (Tutor1= '"&Username&"' OR Tutor2='"&Username&"') AND (Course1Time= '"&Scheduled_Time&"' OR Course2Time='"&Scheduled_Time&"'); "
					rs11.Open(Query)
				
				' Update All Tutee's with this Tutor and Time
					do until rs11.EOF
			        	If rs11.Fields("Course1Time") = Scheduled_Time Then
							Time_Section = "Course1Time"
							Tutor_Section = "Tutor1"
						else
							Time_Section = "Course2Time"
							Tutor_Section = "Tutor2"
						End If
					Query = "UPDATE Tutee Set "
                    Query = Query & " '"&Time_Section&"' = '" & resetSection & "', "
	                Query = Query & " '"&Tutor_Section&"' = '" & resetSection & "', "
	                Query = Query & " WHERE UserName = '" & rs11("UserName") & "'; "
					rs10.Open(Query)
						rs11.MoveNext
					loop
				
                    theTime(0) = Scheduled_Time
                    theTime(1) = Day
				' Remove Time from Tutor Availability
                    Temp = Split(rs12(Day),",")
					Drop_Time_Tutor (Temp, theTime,Username)

                ' Remove Time from Used Time list
					Temp = Split(rs12("Used"&Day),",")
					Drop_Time_Tutor (Temp, theTime,Username)
    End Function
    
	
	' ********************************************************
	'   Function to Remove Desired Time from Time Column
	' ********************************************************
	
	Function Drop_Time_Tutee (Tutee, Time_Section,Tutor_Section)
		Dim myQuery, blank
		blank = ""
		' Create Query Update
              myQuery = "UPDATE Tutee Set "
	           myQuery = myQuery & " "&Time_Section&" =  '" & blank & "', "
	           myQuery = myQuery & " "&Tutor_Section&" = '" & blank & "' "
	           myQuery = myQuery & " WHERE UserName = '" & Tutee & "'; "
		
		' Execute Query 
			EstablishDBCON rs1, con1
			rs1.Open(myQuery)
	
	End Function 
	
	' ********************************************************
	'   Function to Remove Desired time from UsedDay columns
	' ********************************************************
	' Parameters: Temp() = Array of time slots   theTime() = Format:(TimeSlot,DAY)   Tutor = Username
	Function Drop_Time_Tutor (Temp, theTime,Tutor)
		Dim updated_time_string, myQuery
		updated_time_string = ""
		
		' Remove the string from the UsedDay column
			for x=0 to UBound(Temp)
				If Temp(x) <> theTime(0) Then' basically check if Used time equals time in tutee table, (if it doesnt keep the time)
					If updated_time_string = "" Then
						updated_time_string	= Temp(x)
					Else
						updated_time_string = updated_time_string & "," & Temp(x)
					End If
				End If
			Next
			
		' Create Query to update UsedDay column
			    myQuery = "UPDATE Tutor Set "
	            myQuery = myQuery & "Used"&theTime(1)&" =  '" & updated_time_string & "' "
	            myQuery = myQuery & " WHERE UserName = '" & Tutor & "'; "
		
		' Execute Query 
			EstablishDBCON rs6, con6
			rs6.Open(myQuery)
	End Function
	
%>