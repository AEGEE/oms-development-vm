<!DOCTYPE HTML5>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="robots" content="noindex, nofollow, noarchive"/>

<?php

include('./include/httpful.phar');
 
#set your VM IP address here:
$ipaddr = "localhost:8080";

$bodyCode = "ITC";
?> 

<title><?php echo $bodyCode; ?> -  List of applicants</title>
<link rel="stylesheet" href="style.css" type="text/css"/>

</head>
<body>

<?php

echo "<h1>List of applicants to the body: ".$bodyCode."</h1>"

?>


<div id="content" class="tabprofile">

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg .tg-yw4l{vertical-align:top}
</style>
<table class="tg">
  <tr>
    <th class="tg-yw4l">Name</th>
    <th class="tg-yw4l">uid</th>
    <th class="tg-yw4l">Application date</th>
    <!--<th class="tg-yw4l">Gender</th>-->
    <th class="tg-yw4l">Mail</th>
    <th class="tg-yw4l">Actions</th>
  </tr>

<?php

// And you're ready to go!
$uri = $ipaddr."/users/".$bodyCode."/applications";

$response = \Httpful\Request::get($uri)->send();
 

$applications = json_decode($response); 
//echo "<pre> ".print_r($applications)."</pre>";

  foreach ( $applications as $appl){
    $name = $appl->givenName;
    $mail = $appl->mail;
    //$gender = $user->gender;
    $uid = $appl->uid;
    $applicationDate = $appl->memberSinceDate;
    echo "
      <tr>
        <td class=\"tg-yw4l\">".$name."</td>
        <td class=\"tg-yw4l\">".$uid."</td>
        <td class=\"tg-yw4l\">".$applicationDate."</td>
        <td class=\"tg-yw4l\">".$mail."</td>

        <td class=\"tg-yw4l\">
                <form action=\"processMembership.php\"  method=\"post\">
                    <input type=\"hidden\" name=\"uid\" value=".$uid."></input>
                    <input type=\"hidden\" name=\"bodyCode\" value=".$bodyCode."></input>
                    <input type=\"radio\" name=\"memberType\" value=\"Member\"> Accept</input><br>
                    <input type=\"radio\" name=\"memberType\" value=\"Rejected\"> Reject</input><br>
                    <button type=\"submit\" onClick=\"window.location.reload()\" >submit</button>
                </form>
        </td>


      </tr> 
    ";
}
echo "</br>";

?>

</table>


</html>



