<!DOCTYPE HTML5>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="robots" content="noindex, nofollow, noarchive"/>

<?php

include('./include/httpful.phar');
 
#set your VM IP address here:
$ipaddr = "localhost:8080";
if ($_GET["uid"] == "" ) $userName = "new.member"; //$userName = "fabrizio.bellicano";
else $userName = $_GET["uid"]

// And you're ready to go!
$uri = $ipaddr."/users/".$userName;

$response = \Httpful\Request::get($uri)->send();
 

$user = json_decode($response)[0]; //The core always returns an array (even for single element)


$name = $user->cn;
$mail = $user->mail;
$photo = $user->jpegPhoto;
$gender = $user->gender;
$birthdate = $user->birthDate;
$studies = $user->fieldOfStudies;
$tshirt = $user->tShirtSize;


?> 

<title><?php echo $name; ?> -  Service records</title>
<link rel="stylesheet" href="style.css" type="text/css"/>

</head>
<body>
<div id="bdiv">
<table id="btab"><tr>
<td id="lhs">
<a href="album-Profile%20Pictures.html"><img width="200" height="250" src="data:image/jpeg;base64,<?php echo base64_encode($photo) ?>"/></a>
<div id="tabs"><b>Profile</b> <a href="wall.html">Wall</a> <a href="photos.html">Photos</a> <a href="videos.html">Videos</a> <a href="friends.html">Friends</a> <a href="notes.html">Notes</a> <a href="events.html">Events</a> <a href="messages.html">Messages</a> </div>
</td>
<td id="rhs">

<?php


$uri = $ipaddr."/users/".$userName."/memberships";
$response = \Httpful\Request::get($uri)->send();
 

$membership = json_decode($response);



//there is NO GUARANTEE that the changelog is already ordered (although technically it is)
//so we check them anyway.
function parse_changelog($the_array)
{
    
    sort($the_array);

$entries;
    for($i=0;$i<count($the_array);$i++)
    {
        $entries[$i]= explode(", ", $the_array[$i]);
    }
    
    // format the log
    foreach($entries as $entry)
        echo $entry[0].": membership changed to ".explode("=", $entry[1])[1]."<br/>";

    //done
    echo "<br/>";
}
?>

<h1>User Profile</h1>
<div id="content" class="tabprofile">

<table class="profiletable">

<tr><td class="label">Name:</td><td> <?php echo $name; ?></td></tr>

<tr><td class="label">Sex:</td><td> <?php echo $gender; ?> </td></tr>

<tr><td class="label">Birthday:</td><td> <?php echo $birthdate; ?> </td></tr>

<tr><td class="label">Email:</td><td> <?php echo $mail; ?> </td></tr>

<tr><td class="label">Field of studies:</td><td> <?php echo $studies; ?></td></tr>

<tr><td class="label">Tshirt size:</td><td> <?php echo $tshirt; ?></td></tr>

<tr><td class="label">Memberships:</td> <td><?php foreach($membership as $memb){ 
                                             echo /*$memb->bodyCode,*/ " (". ((array_key_exists("title", $memb ))? $memb->title:"member").") ", "of ".$memb->bodyCode." since ".$memb->memberSinceDate."<br/>";
                                             if(array_key_exists ( "changeLog" , $memb )) { parse_changelog((array)$memb->changeLog); }
                                         } ?> </td></tr>


</html>



