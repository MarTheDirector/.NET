

<% 
        '******************************************************
		'   get User register date
		'******************************************************
        
        Function getDateRegistered (Username)
		
        if Username <> "" then

		EstablishDBCON rsDateRegistered, conDateRegistered
		
		sqlString = "Select DateRegistered from AdditionalInformation where Username ='"&Username&"'"

        rsDateRegistered.open sqlString
        
            if rsDateRegistered.eof then
                    if DateRegistered = "" then
                        getDateRegistered = "Missing Date"
                    else
                        getDateRegistered = "Missing Date" 
                    end if 
            else
                getDateRegistered = rsDateRegistered("DateRegistered")
            end if

        rsDateRegistered.close
        else

        getDateRegistered= "Missing Date"
        
        end if

		end function	
		
		
		
		'******************************************************
		'   True at max hours
		' 	false not at max hours 
		'******************************************************
        
        Function maxedOut (Username)
		
        if Username <> "" then

		EstablishDBCON rsmaxedOut, conmaxedOut
		
		sqlString = "Select U_Hours, M_Hours from Tutor where Username ='"&Username&"'"

        rsmaxedOut.open sqlString
        
            if rsmaxedOut.eof then
                        maxedOut = 3
            else
            	maxHours= rsmaxedOut("M_Hours")
            	usedHours= rsmaxedOut("U_Hours")
            	if maxHours <= usedHours then
            		maxedOut = 1
            	elseif maxHours > usedHours then
            		maxedOut =0
            	else
            		maxedOut = 3
                end if 
            end if

        rsmaxedOut.close
        else
		
        maxedOut = 3

        end if

		end function

%>