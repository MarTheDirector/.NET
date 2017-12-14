<!-- 
   Name:        Tutor System Portal Footer
   Written By:  Unknown
   Updated By:  ???
   System:      Part of the interface for the ASC Tutor Schedule Portal website
   Created:     Unknown
   Update:      Spring 2015
   Purpose:     Add essential website information to the bottom of every ASC Tutor Schedule Portal webpage.  
   How:         ASC script evaluates method of inquiry and displays appropriate form.  HTML contains the 
                footer and form structure.     
   
-->


<%
	If (Request.ServerVariables("REQUEST_METHOD")= "POST") AND (Request.Form("email") <> "")  Then
	Dim Subject, Body

    if Request.Form("otherTyped") <> "" Then
	    Subject = Request.Form("email") & " :  " &Request.Form("problemType") & " : " & Request.Form("otherTyped")
    else
        Subject = Request.Form("email") & " :  " &Request.Form("problemType")
    end if

	Body = Request.Form("comments")
	Email "success@mailbox.winthrop.edu", Subject,Body
	End If
%>

ASC Tutoring&nbsp;&#124;
<!-- Link to trigger Problem Contact Form -->
<a href="#myModal" data-toggle="modal">Having Trouble?</a>&nbsp;&#124;
<a href="#myModal" data-toggle="modal">Contact Us</a>&nbsp;&#124;
<a href="../logout.asp">Log out</a>


 
<!-- Modal -->
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <form name="problemForm" action="" onsubmit="return validateHavingTroubleForm()" method="post">
      <div class="modal-body">
        <fieldset>
        <legend>What's Your Problem?</legend>
        <label>Type of Problem:</label>
        <select style="width: 22em;" name="problemType" onchange="otherForm(this.options[this.selectedIndex].value)">
	        <option value="NoTutor">I Can't find a tutor or available time</option>
	        <option value="NoCourse">The course I want tutoring in isn't offered</option>
	        <option value="ReportBug">Report Problem with website</option>
	        <option value="Other">Other...please enter below</option>
        </select>
        <div id="otherdiv"></div>
        <label>Your Email:</label>
        <input required="required" type="email" name="email"><br />
        <label>Extra Comments:</label>
        <textarea name="comments" cols="5" rows="5"></textarea>        
        </fieldset>
      </div>
      <div class="modal-footer">
        <button class="btn btn-inverse" data-dismiss="modal" aria-hidden="true">Back</button>
        <button class="btn btn-success" type="submit">Submit</button>
      </div>
  </form>
</div>
<!--Script for Modal to make the "Other" input box show up when selected-->
<script>
    function otherForm(name) {
        if (name == 'Other') document.getElementById('otherdiv').innerHTML = '<label>Other</label><input type="text" required name="otherTyped" />';
        else document.getElementById('otherdiv').innerHTML = '';
    }
    function validateHavingTroubleForm() {
        //First check email
        var email = document.forms["problemForm"]["email"].value;
        if (email == null || email == "") {
            alert("Please enter an email");
            return false;
        }
        var atpos = email.indexOf("@");
        var dotpos = email.lastIndexOf(".");
        if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
            alert("Not a valid e-mail address");
            return false;
        }
        var otherTyped = document.forms["problemForm"]["otherTyped"].value;
            if (otherTyped == null || otherTyped == "") {
                alert("Please enter your problem in the 'Other' box");
                return false;
        }
    }
</script>

<!-- JQuery and Boostrap Scripts placed in footer to improve page load times -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='../js/jquery-1.8.3.min.js' type='text/javascript'%3E%3C/script%3E"));
}
</script>
<script src="../js/bootstrap.min.js"></script>