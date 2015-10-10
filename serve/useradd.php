<?php
// This file takes the parameters from the form and adds them to the database, NO check of authentication (jus proof of concept)

include('./include/httpful.phar');

#set your VM IP address here:
$ipaddr = "localhost:8080";

    echo "<br><br>";

$uid = strtolower($_POST["givenname"].".".$_POST["sn"]); #TODO:check omonimia 

    // prepare data
    $info["givenName"]    = $_POST["givenname"];
	$info["sn"]           = $_POST["sn"];
	$info["cn"]           = strtolower($info["givenname"]." ".$info["sn"]); #Omonimia can be allowed here
	$info["uid"]          = $uid; 
	$info["birthDate"]    = $_POST["birthDate"];
    $info["userPassword"] = $_POST["userpassword"];
	$info["mail"]         = $_POST["mail"];
	$info["tShirtSize"]    = $_POST["tshirtsize"];


$uri = $ipaddr."/users/create";
$response = \Httpful\Request::post($uri)->sendsJson()->body($info)->send();
    

//now adds membership information
$bodycode = $_POST["antenna"];

$uri = $ipaddr."/antennae/".$bodycode;
$response = \Httpful\Request::get($uri)->send();

$bodynameascii = json_decode($response)[0]->bodyNameAscii;


    $info2["bodyCode"]    = $bodycode; 
    $info2["bodyNameAscii"]  = $bodynameascii;
    $info2["bodyCategory"]  = "Local";
    $info2["netcom"]      = "FIXME";
    $info2["mail"]         = $info["mail"];
    $info2["o"]         = "something";
    $info2["memberSinceDate"] = "2015";
    $info2["memberUntilDate"] = "2015";


$uri = $ipaddr."/users/".$uid."/memberships/create";
$response = \Httpful\Request::post($uri)->sendsJson()->body($info2)->send();

 echo "added user ".$info["cn"];

?>
