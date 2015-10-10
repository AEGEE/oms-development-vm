<?php

include('./include/httpful.phar');

#set your VM IP address here:
$ipaddr = "localhost:8080";


$uri = $ipaddr."/users/".$_POST["uid"]."/memberships/".$_POST["bodyCode"]."/modify";
$info["memberType"] = $_POST["memberType"];

$response = \Httpful\Request::post($uri)->sendsJson()->body($info)->send();

$newURL = $ipaddr."/showrecord.php?uid=".$_POST["uid"];
header('Location: '.$newURL);


?>
