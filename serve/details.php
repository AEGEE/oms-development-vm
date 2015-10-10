<!DOCTYPE HTML>
<html lang="en-GB">
<head>
	<meta charset="UTF-8">
	<title>Add user to AEGEE DB</title>
	<style type="text/css">
body {
	margin: 2em 5em;
	font-family:Georgia, "Times New Roman", Times, serif;
}
h1, legend {
	font-family:Arial, Helvetica, sans-serif;
}
label, input, select {
	display:block;
}
input, select {
	margin-bottom: 1em;
}
fieldset {
	margin-bottom: 2em;
	padding: 1em;
}
fieldset fieldset {
	margin-top: 1em;
	margin-bottom: 1em;
}
input[type="checkbox"] {
	display:inline;
}
.range {
	margin-bottom:1em;
}	
.card-type input, .card-type label {
	display:inline-block;
}
	</style>	
</head>
<body>
<form id="register" action="useradd.php" method="post">
<h1>Register new member</h1>
  <fieldset> 
    <legend>Personal details</legend> 
    <div> 
        <label>First Name
        <input id="given-name" name="givenname" type="text" placeholder="First name only" required autofocus> 
		</label>
    </div>
    <div> 
        <label>Last Name
        <input id="family-name" name="sn" type="text" placeholder="Last name only" required autofocus> 
		</label>
    </div>
    <div> 
        <label>Contact/Local 
        <select id="antenna" name="antenna" required>
	<?php

include('./include/httpful.phar');
#set your VM IP address here:
$ipaddr = "localhost:8080";
$uri = $ipaddr."/antennae";
$response = \Httpful\Request::get($uri)->send();
$antennae = json_decode($response);

	foreach($antennae as $ant){
		echo "<option value=\"".$ant->bodyCode."\"", $_GET["bodyCode"]==$ant->bodyCode?"selected":"" , ">".$ant->bodyNameAscii."</option>";
	}
        ?>
	</select>
        </label> 
    </div> 
    <div> 
    	<label>Date of Birth
        <input id="dob" name="birthDate" type="date" required>
		</label>
    </div> 
    <div> 
        <label>Email 
        <input id="email" name="mail" type="email" placeholder="example@domain.com" required>
		</label> 
    </div> 
    <div> 
        <label>Password 
        <input id="pass" name="userpassword" type="password" placeholder="pippins" required>
		</label> 
    </div> 
    <div> 
        <label>URL 
        <input id="url" name="url" type="url" placeholder="http://mysite.com">
		</label> 
    </div>    
    <div> 
        <label>Telephone 
        <input id="phone" name="phone" type="tel" placeholder="Eg. +447000 000000" required>
		</label> 
    </div> 
	<div>
		<label>TShirt size
                <select id="tshirtsize" name="tshirtsize" required>
                   <option value="S">Small</option> 
                   <option value="M" selected>Medium</option>
                   <option value="L">Large</option>
                </select>
		</label>
	</div> 
	
  </fieldset>
  
  <fieldset> 
  	<div> 
	    <button type=submit>Add new user to the DB</button> 
    </div> 
  </fieldset> 
</form> 
</body>
</html>
