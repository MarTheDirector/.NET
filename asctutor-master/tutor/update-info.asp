<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
    <div class="container">
    <div class="well">
<body>
	<!--#include file="../includes/navbar-tutor.asp"-->
          <%
			Dim username,F_Name,L_Name,Phone,myQuery	
			username = Request.Cookies("user")("username")
			
			'******************************************************
			'Estabilsh connection and retrieve record from database
			'******************************************************
			
			EstablishDBCON rs3,con2	
			EstablishDBCON rs4,con3
			GetRecord rs3, "Tutor", username

            'Update for winthrop ID
            EstablishDBCON rs5,con5
            queryString = "select WID from AdditionalInformation where Username = '"&username&"'"
            rs5.open queryString
            EstablishDBCON rs6,con6
            '**********************
			
			'*******************************************************
			'Check for changes, if found update database
			'*******************************************************
			
			If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then

			
				myQuery = "UPDATE Tutor Set "
				myQuery = myQuery & "F_Name= '" & Request.Form("F_Name") & "',"
				myQuery = myQuery & "L_Name= '" & Request.Form("L_Name") & "',"
				myQuery = myQuery & "PhoneNo= '" & Request.Form("PhoneNo") & "', "
                myQuery = myQuery & "M_Hours= '" & Request.form("maxHours") & "', "
                myQuery = myQuery & "Email= '" & Request.form("Email") & "' "
			
				myQuery = myQuery & " WHERE UserName = '" & Request.Cookies("user")("username") & "' "
				
				rs4.Open(myQuery)		
				
				'Response.Redirect "tutee-portal.asp"
                rs3.close()
                GetRecord rs3, "Tutor", username

                winthropID = Request.form("winID")
                queryString = "Update AdditionalInformation set WID = '"& winthropID &"' where Username = '"&UserName&"'"
                rs6.open queryString

                Response.Write("<div class='alert alert-success'>User " & username & " Successfully Updated! Click <a href='default.asp'> here </a> or back to return to your home page. </div>")
			End If
	      %>

    <div class="container">
        <h2>Enter Your Information</h2>
        <form name="UpdateForm" class="form-horizontal" action="update-info.asp" onsubmit="return validateForm()" method="post">
	    
        <div class="control-group">
        	<label class="control-label" for="F_Name">First Name</label>
        	<div class="controls">
	        <% 
	        	Response.Write("<input name='F_Name' id='F_Name' type='text' required autofocus value='" & rs3("F_Name") & "'>")
	       	%>
       		</div>
       	</div>
       	
       	<div class="control-group">
	       	<label class="control-label" for="L_Name">Last Name</label>
	       	<div class="controls">
		       	<%
		        	Response.Write("<input name='L_Name' id='L_Name' type='text' required value='"&rs3("L_Name")&"'>")
		        %>
        	</div>
        </div>
        
       	<div class="control-group">
	       	<label class="control-label" for="PhoneNo">Phone</label>
	       	<div class="controls">        
		        <%	
		        	Response.Write("<input name='PhoneNo' id='PhoneNo' type='text' required class='input-small' maxlength='16' value='"&rs3("PhoneNo")&"'>")
		        %>
			</div>
		</div>

        <div class="control-group">
       	    <label class="control-label" for="winID">Winthrop ID ex: 12345678</label>
       	        <div class="controls">        
                    <%	
        	            Response.Write("<input name='winID' id='winID' type='text' required class='input-small' maxlength='10' value='"&rs5("WID")&"'>")
                    %>
                </div>
        </div>

        <div class="control-group">
	       	<label class="control-label" for="Email">Email</label>
	       	<div class="controls">        
		        <%	
		        	Response.Write("<input name='Email' id='Email' type='email' required value='"&rs3("Email")&"'>")
		        %>
			</div>
		</div>
		

       	<div class="control-group">
	       	<label class="control-label" for="maxHours">Maximum Desired Hours</label>
	       	<div class="controls">  
	            <!--Course 2 drop down box-->
	            <select id="maxHours" name="maxHours">
		            <%
		                if rs3("M_Hours") = "EMPTY" Then
		                    Response.Write("<option Selected style='background-color:#ffc120;>0</option>")
		                else
		                    Response.Write("<option Selected style='background-color:#ffc120;'>" & rs3("M_Hours") & "</option>")
		                End If
		            
                    HoursArray = Array(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
                    For Each thing in HoursArray
                        If thing <> rs3("M_Hours") Then
                            Response.Write("<option>" & thing & "</option>")
                        End If
                    Next    
                    %>
	            </select>
	         </div>
	     </div>
        	
			<div class="form-actions">
				<button class="btn btn-primary" type="submit">Update Information</button>
				<a href="default.asp" class="btn btn-inverse">Back</a>
			</div>
         </form>
      	
      	<hr>
      <footer>
        <!--#include file="../includes/footer.asp"-->
      </footer>

    </div> <!-- /container -->
<script type="text/javascript">
    //function that checks if phone number entered is valid
    function phoneValid(p) {
	  var phoneRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
	  var digits = p.replace(/\D/g, "");
	  return (digits.match(phoneRe) !== null);
	}

	//function that checks if winthrop id number entered is valid
	function widValid(w) {
	    var winIdRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
	    var digits = w.replace(/\D/g, "");
	    return (digits.match(winIdRe) !== null);
	}

    //function that checks if they entered stuff into the form
    function validateForm() {
        var F_Name = document.forms["UpdateForm"]["F_Name"].value;
        var L_Name = document.forms["UpdateForm"]["L_Name"].value;
        var winID = document.forms["UpdateForm"]["winID"].value;
        var PhoneNo = document.forms["UpdateForm"]["PhoneNo"].value;

		//Then make the phone number be just digits So it can be safely entered into database.
		var phoneRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
	  	digits = PhoneNo.replace(/\D/g, "");
	  	document.forms["UpdateForm"]["PhoneNo"].value = digits;
	  	PhoneNo = digits;
	  	if(digits.length != 10)
        {
        	alert("Please enter a ten digit phone number")
        	return false;
        }

        //Make the Winthrop ID be just digits so it can be safely entered into database.
        var winIdRe = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
        var digits = winID.replace(/\D/g, "");
        document.forms["UpdateForm"]["winID"].value = digits;
        winID = digits;
        if (digits.length != 8) {
            alert("Please enter an eight digit winthrop ID number")
            return false;
        }


	  	var Email = document.forms["UpdateForm"]["Email"].value;
	  	var atpos = Email.indexOf("@");
	  	var dotpos = Email.lastIndexOf(".");        
        
        //checks if they entered illegal characters
	  	var substrings = ["--", "<", ">", "(", ")", ";", "%", "/*", "'", "*/", "@@"];
	  	length = substrings.length;
	  	while (length--) {
	  	    if (F_Name.indexOf(substrings[length]) !== -1 || L_Name.indexOf(substrings[length]) !== -1 || Email.indexOf(substrings[length]) !== -1) {
	  	        alert("You entered an illegal character, please remove all double dashes, slashes, apostrophes, single quotes, double quotes, semicolons, percent signs, asterisks, parentheses, or double @ signs.");
	  	        return false;
	  	    }
	  	}

	  	if (F_Name == null || F_Name == "" || L_Name == null || L_Name == "") {
            alert("Please enter both a First and Last Name");
            return false;
        }
        
        if (PhoneNo == null || PhoneNo == "") {
        	alert("Please enter a phone number.");
        	return false;
        }

        if (winID == null || winID == "") {
            alert("Please enter a Winthrop ID number.");
            valid = false;
        }


        if (Email == null || Email == "") {
            alert("Please enter an email.");
            return false;
        }
        
        if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
            alert("Not a valid e-mail address");
            return false;
        }
       
        if(!phoneValid(PhoneNo)){
        	alert("Please enter a valid US Phone Number");
        	return false;
        }    
    }    
</script>

</body>
        </div>
        </div>
</html>