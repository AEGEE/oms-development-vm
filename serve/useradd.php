<?php
// This file takes the parameters from the form and adds them to the database, NO check of authentication

$ldapconn = ldap_connect("localhost")
    or die("Could not connect to LDAP server.");

if ($ldapconn) {

	ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3);
    // binding to ldap server (anonymous)
    $ldapbind = ldap_bind($ldapconn, "cn=admin, dc=aegee, dc=org", "admin"); #TODO: add less privileged user able to add

    // verify binding
    if ($ldapbind) {
        echo "LDAP bind successful...";
    } else {
        echo "LDAP bind failed...";
    }

    echo "<br><br>";
 

    // prepare data
    $info["givenname"]    = $_POST["givenname"];
	$info["sn"]           = $_POST["sn"];
	$info["cn"]           = strtolower($info["givenname"]." ".$info["sn"]); #Omonimia can be allowed here
	$info["uid"]          = strtolower($info["givenname"].".".$info["sn"]); #TODO:check omonimia
	$info["birthDate"]    = $_POST["birthDate"];
    $info["userpassword"] = $_POST["userpassword"];
	$info["mail"]         = $_POST["mail"];
	$info["objectclass"]  = "aegeePersonFab";

	//print_r($info);

    // add data to directory
    $dn= "uid=".$info["uid"].", ou=people, dc=aegee, dc=org";
    echo $dn;
    $result = ldap_add($ldapconn, $dn, $info);
    
    echo "<br><br>";
    echo $result?"YEEAH":"nope, did not work";
    echo "<br><br>";

    $search= "ou=antennae,dc=aegee,dc=org";
    $filter="(bodyNameAscii=".$_POST["antenna"].")";
    $justthese = array("bodyCode","bodyNameAscii");
    
    $searchres= ldap_search($ldapconn, $search, $filter, $justthese );
    $bodycode = ldap_get_entries($ldapconn, $searchres);

    print_r($bodycode);
    $dn= "bodycode=".$bodycode[0][bodycode][0].", ".$dn;
    //echo $bodycode."<br>";
    //echo $dn;

    $info2["bodycode"]    = $bodycode[0][bodycode][0];
    $info2["bodynameascii"]  = $_POST["antenna"];
    $info2["netcom"]      = $info["uid"];
    $info2["mail"]         = "cacca@cacca.ca";
    $info2["o"]         = "rcodio";
    $info2["objectclass"]  = "aegeeBodyFab";

print_r($info2);

    $result = ldap_add($ldapconn, $dn, $info2);
    echo "<br><br>";
    echo $result?"YEEAH":"nope, did not work";
    echo "<br><br>";


    ldap_close($ldapconn);
    echo "added user ".$info["cn"];
} else {
    echo "Unable to connect to LDAP server";
}

?>