done:update tutee select page
if allows 2 is no then dont show first button
done:update drop procedure to sort by date		
        <% 
        	do until rs5.EOF
	        	'For Each item In rs5.Fields
                    UserName= rs5("UserName")
                    Monday= rs5("Monday")
                    Tuesday= rs5("Tuesday")
                    Wednesday= rs5("Wednesday")
                    Thursday= rs5("Thursday")
                    Friday= rs5("Friday")
                    CurrentDay = ""

                    if UserName <> "EMPTY" then
					    Response.Write("<li>" & UserName & "</li>")
                        'if not empty list Monday times. 
                        'is null just seems like a shitty test. Let's just set
                        'every value to something like EMPTY
                        if IsNull(Monday) = false then
                        CurrentDay = "Monday"
                        Response.Write(""& "Monday" & "<br/>")
                            'Split this field into an array
                            ListOfTimes = Split(Monday,",")
                            for each item in ListOfTimes
                               ' Response.Write( item & "<br/>")
                                Response.Write("<input type='radio' name='date' value='" & item & "'>" & item & "<br />")
                            Next
                        end if
                        if IsNull(Tuesday) = false then
                        Response.Write(""& "Tuesday" & "<br/>")
                            'Split this field into an array
                            ListOfTimes = Split(Tuesday,",")
                            for each item in ListOfTimes
                                Response.Write("<input type='radio' name='date' value='" & item & "'>" & item & "<br />")
                            Next
                        end if
                        if IsNull(Wednesday) = false then
                        Response.Write(""& "Wednesday" & "<br/>")
                            'Split this field into an array
                            ListOfTimes = Split(Wednesday,",")
                            for each item in ListOfTimes
                                Response.Write("<input type='radio' name='date' value='" & item & "'>" & item & "<br />")
                            Next
                        end if
                       if IsNull(Thursday) = false then
                       Response.Write(""& "Thursday" & "<br/>")
                            'Split this field into an array
                            ListOfTimes = Split(Thursday,",")
                            for each item in ListOfTimes
                                Response.Write("<input type='radio' name='date' value='" & item & "'>" & item & "<br />")
                            Next
                        end if
                        if IsNull(Friday) = false then
                            Response.Write(""& "Friday" & "<br/>")
                            'Split this field into an array
                            ListOfTimes = Split(Friday,",")
                            for each item in ListOfTimes
                                Response.Write("<input type='radio' name='date' value='" & item & "'>" & item & "<br />")
                            Next
                        end if
                    end if
				'Next
				rs5.MoveNext
			loop
            rs5.Close

            %>