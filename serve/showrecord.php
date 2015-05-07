<!DOCTYPE HTML5>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="robots" content="noindex, nofollow, noarchive"/>

<?php

$profile_requested = "fabrizio.bellicano"; //TODO: should be taken from $_POST, and not hardcoded

$ldapconn = ldap_connect("localhost")
    or die("Could not connect to LDAP server.");

if ($ldapconn) {

	ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3);
    // binding to ldap server (work user)
    $ldapbind = ldap_bind($ldapconn, "cn=admin, dc=aegee, dc=org", "aegee"); #TODO: add less privileged user able to add

    // verify binding
    if ($ldapbind) {
        echo "LDAP bind successful...";
    } else {
        echo "LDAP bind failed...";
    }
    
//    echo "<br><br>";
//    echo $result?"YEEAH":"nope, did not work";
//    echo "<br><br>";

    $searchBase= "ou=people,dc=aegee,dc=org";
    $filter="(uid=".$profile_requested.")";
    $attributes = array("cn", "mail", "XjpegPhoto", "gender", "birthDate",
                         "tShirtSize", "fieldOfStudies" );

    $searchres= ldap_search($ldapconn, $searchBase, $filter, $attributes );
    $profile_result = ldap_get_entries($ldapconn, $searchres);

    $searchBaseMembership= $profile_result[0]["dn"]; //I save this to search the memberships (another query)

    $name = $profile_result[0]["cn"][0];
    $mail = $profile_result[0]["mail"][0];
    $photo = $profile_result[0]["jpegphoto"][0];
    $gender = $profile_result[0]["gender"][0];
    $birthdate = $profile_result[0]["birthdate"][0];
    $studies = $profile_result[0]["fieldofstudies"][0];
    $tshirt = $profile_result[0]["tshirtsize"][0];

    //new search: for the membership
    $filter="(bodyCode=*)";
    $attributes = array( "bodyCode", "memberSinceDate", "memberUntilDate", "changeLog", "memberType", "title" );

    $searchres= ldap_search($ldapconn, $searchBaseMembership, $filter, $attributes );
    $membership_result = ldap_get_entries($ldapconn, $searchres);

    for($i=0;$i<$membership_result["count"];$i++)
        for($k=0;$k<$membership_result[$i]["count"];$k++)
            for($j=0;$j<$membership_result[$i][$membership_result[$i][$k]]["count"];$j++)
            $membership[$i][$membership_result[$i][$k]][$j]= $membership_result[$i][$membership_result[$i][$k]][$j];

    ldap_close($ldapconn);

} else {
    echo "Unable to connect to LDAP server";
}

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

    echo "<pre>";
    //print_r($profile_result);
    //print_r($membership_result);
    //print_r($membership);
    echo "</pre>";

//there is NO GUARANTEE that the changelog is already ordered (although technically it is)
//so we check them anyway.
function parse_changelog($the_array)
{
    //1 break (no need)
    //2 order 
    echo "<pre>";
    //print_r($the_array);
    echo "</pre>";
    sort($the_array);
    echo "<pre>";
    //print_r($the_array);
    echo "</pre>";

$entries;
    for($i=0;$i<count($the_array);$i++)
    {
        //$change= explode(": ", $the_array[$i]);
        //$entries[$change[0]]= $change[1];

        $entries[$i]= explode(", ", $the_array[$i]);
    }

    echo "<pre>";
    //print_r($entries);
    echo "</pre>";

    
    //3 format
    foreach($entries as $entry)
        echo $entry[0].": membership changed to ".explode("=", $entry[1])[1]."<br/>";

    //4 return
    echo "<br/>";
}
?>

<h1>Aborigeno Alogeno</h1>
<div id="content" class="tabprofile">

<table class="profiletable">

<tr><td class="label">Real Name:</td><td> <?php echo $name; ?></td></tr>

<tr><td class="label">Sex:</td><td> <?php echo $gender; ?> </td></tr>

<tr><td class="label">Birthday:</td><td> <?php echo $birthdate; ?> </td></tr>

<tr><td class="label">Email:</td><td> <?php echo $mail; ?> </td></tr>

<tr><td class="label">Class:</td><td> <?php echo $studies; ?></td></tr>

<tr><td class="label">Tshirt size:</td><td> <?php echo $tshirt; ?></td></tr>

<tr><td class="label">Memberships:</td> <td><?php foreach($membership as $memb){ 
                                             echo $memb["membertype"][0], ((array_key_exists("title", $memb ))?" (".$memb["title"][0].") ":" "), "of ".$memb["bodycode"][0]." since ".$memb["membersincedate"][0]."<br/>";
                                             if(array_key_exists ( "changelog" , $memb )) { parse_changelog($memb["changelog"]); }
                                         } ?> </td></tr>

<tr><td class="label">Forza:</td><td>72</td></tr>

<tr><td class="label">Destrezza:</td><td>52</td></tr>

<tr><td class="label">Carisma:</td><td>89</td></tr>

<tr><td class="label">Intelligenza:</td><td>85</td></tr>

<tr><td class="label">Saggezza:</td><td>90</td></tr>

<tr><td class="label">Livello:</td><td>52</td></tr>

<tr><td class="label">Hometown:</td><td><span class="page">Genova, Italy</span></td></tr>

<tr><td class="label">Political Views:</td><td>LA.LI.LU.LE.LO.</td></tr>

<tr><td class="label">Religious Views:</td><td>Zena e San Zorzu</td></tr>

<tr><td class="label">Bio:</td><td>I ride my bike like lightning and I make pasta which makes the angels sing.<BR><BR>&quot;Please allow me to introduce myself,I'm a man of wealth,and taste...&quot;<BR><BR>From Italy,not Italian. Mind the difference.<BR>&quot;Don't tell me how much you are educated,tell me how much you travelled&quot;<BR><BR>&quot;I ride my bike like lightning and I make pasta which makes the angels sing&quot; [cit.]</td></tr>

<tr><td class="label">Favorite Quotations:</td><td>Rugby players are either piano shifters or piano movers. Fortunately, I am one of those who can play a tune.<BR><BR>Who Dares Wins. Memento Audere Semper. Audentes Fortuna Iuvat.</td></tr>

<tr><td class="label">Education:</td><td><span class="page">ITI A. Gastaldi/Giorgi</span> - <span class="page">2008</span>
<br/><br/>
<span class="page">Università Di Genova</span> - <span class="page">2011</span><br/><span class="page">Computer Science &amp; Engineering</span></td></tr>

</html>


