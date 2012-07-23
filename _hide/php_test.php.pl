<html>
<head>
<title>Title of page...</title>
</head>

<body>
<h1>This is first heading...</h1>
This is some free text...

<?php
	
	echo "Hello World!<p>\nThe current time is...";

	//Prints something like: Monday 15th of January 2003 05:51:38 AM
	echo date("l dS of F Y h:i:s A<p>\n");

	//now we call the killer function
	phpinfo();

?>

</body>
</html>