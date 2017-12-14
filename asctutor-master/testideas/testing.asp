<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
 <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript">
  /*
$(document).ready(function() {
   $("a").click(function() {
     alert("Hello world!");
   });
});
*/

//works
/*
      var jqxhr = $.get("tester.asp", function () {
          alert("success");
      })
.done(function () { alert("second success"); })
.fail(function () { alert("error"); })
.always(function () { alert("finished"); });

      // perform other work here ...

      // Set another completion function for the request above
      jqxhr.always(function () { alert("second finished"); });
 */
 //works
 /*
      $.get("view-basic-info2.asp", { q: "tutor"})
.done(function (data) {
    alert("Data Loaded: " + data);
});
 */
 /*
      $.get('view-basic-info2.asp',{ q: "tutor"}) .done(function (data) {
          $('.result').html(data);
          alert('Load was performed.');
      });

      */

      /*
      $.ajax({
          url: "tester.asp",
          cache: false,
          success: function (html) {
              $("#results").append('#Div1');
          }
      });
 
 */
      //nmot working
      //nvm do load at end apparently
 /*
      $(document).ready(function () {
          $("button").click(function () {
              $('div').load('tester.asp #results2', function () {
                  alert('Load was performed.');
              });
          });
      });
      */

     

 </script>  
 

</head>
<body>
    

<div id='wtf'> </div>

<%

Response.write DateDiff("m","01/10/04",date) & " Months <br>" 
'date function returns todays date so its difference between 01/01/04 & today

dim fromDate, toDate

fromDate="15:00:00"
toDate="23:00:00"

Dim xtreme , xtreme2,sNewDate
xtreme = DateDiff("n","01/30/13",date) 
'date function returns todays date so its difference between 01/01/04 & today

xtreme2 = DateDiff("n",fromDate,toDate) 

sNewDate= DateAdd("h",1, fromDate)

Response.write (sNewDate) & "JUMAJJI"
Response.write ("<br/>")
Response.write (xtreme) & "Minutes since 1/30/13"
Response.write ("<br/>")
xtreme = xtreme * 60

Response.write (xtreme) & "Seconds since 1/30/13 <br>"
Response.write ("<br/>")
Response.write (xtreme2) & "Minutes since 23:00 <br>"
Response.write ("END OF OTHER USEFUL STUFF <br/>")
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'*******************************************************
'do multi line comments literally not exist in this FUCKING JOKE?
%> 


<form action=""> 
<select name="customers" onchange="showUser(this.value)">
<option value="">Select a user:</option>
<%
EstablishDBCON rsforadmin,conforadmin

sql="SELECT UserName FROM Users"

rsforadmin.Open sql,conforadmin

do until rsforadmin.EOF
		For Each item In rsforadmin.Fields
				Response.Write("<option value=" &item&">" & item & "</option>")
		Next
				rsforadmin.MoveNext
loop
 %>
</select>
</form>
<p>testest </p>
<script>
$('#p').popover('show')
</script>
<br>
<div id="txtHint">Student info will be listed here...</div>

<script>
    $('#wtf').load('view-basic-info2.asp?q='+encodeURIComponent('tutor')+' #results' function () {
        alert('Load was performed.');
    });

function showUser(str)
{
    var xmlhttp;
if (str=="")
    {
        document.getElementById("txtHint").innerHTML="";
        return;
    }
    if (window.XMLHttpRequest)
        {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
        }
    else
        {
        // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
xmlhttp.onreadystatechange=function()
    {
    if (xmlhttp.readyState==4 && xmlhttp.status==200)
        {
        document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
        }
    }
xmlhttp.open("GET","testing2.asp?q="+str,true);
xmlhttp.send();
}
</script>



</body>
</html>
