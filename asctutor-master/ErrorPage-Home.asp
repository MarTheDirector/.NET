<!DOCTYPE html>
<% response.buffer = true %><html>
<head>
<!--#include file="includes/header_For_Homepage.asp"-->
</head>
<body>
<div class="container-fluid">
	<div style="text-align:center;">
	<h2>Hey there, You tried to enter invalid data as a username or password, and that's not allowed!</h2>
	<p>For future reference, please don't enter any of these values:</p>
	<pre>-- < > ( ) ; /* ' "" */ @@</pre>
	<h2><a href="default.asp">Click here to go back to the homepage</a></h2>
	</div>
</div> <!-- /container -->
</body>
</html>