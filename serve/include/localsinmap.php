<?php
/**
 * Copyright 2009, 2010 AEGEE-Europe
 *
 * This file is part of AEGEE-Europe Online Membership System.
 *
 * AEGEE-Europe Online Membership System is free software: you can
 * redistribute it and/or modify it under the terms of the GNU General
 * Public License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 *
 * AEGEE-Europe Online Membership System is distributed in the hope
 * that it will be useful, but WITHOUT ANY WARRANTY; without even the
 * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with AEGEE-Europe Online Membership System.  If not, see
 * <http://www.gnu.org/licenses/>.
 */

/**
 * Usage:
 * - include this file as Javascript in HTML header
 * - in HTML <body onload="initialize();">
 * Example: ./../../test/map.html
 */

header("Content-Type: text/javascript\r\n");


include('./httpful.phar');

#set your VM IP address here:
$ipaddr = "localhost";

// And you're ready to go!
$uri = $ipaddr.":8800/antennae";
$response = \Httpful\Request::get($uri)->send();

#$bodies = [ [ "bodyCode"=>"GEN", "bodyName"=>"Genova", "bodyCategory"=>"A", "latitude"=>"44.41111", "longitude"=>"8.932778", "website"=>"staminch.ia" ], [ "bodyCode"=>"SPE", "bodyName"=>"Spezia", "bodyCategory"=>"C", "latitude"=>"40.41111", "longitude"=>"8.932778", "website"=>"speziaminch.ia" ]  ];

$bodies = json_decode($response, true);

function set_marker_icon($type) 
//translation:
//  $type is bodyStatus,
//  $group_id is bodyCode
//  $group_name is bodyCategory

{
	switch($type)
	{
		case 'A':
			echo 'http://devel.oms.aegee.org/oms/images/yellow_MarkerA_12x20.png';
			break;

		case 'CA':
			echo 'http://devel.oms.aegee.org/oms/images/paleblue_MarkerC_12x20.png';
			break;

		case 'C':
			echo 'http://devel.oms.aegee.org/oms/images/brown_MarkerC_12x20.png';
			break;
	}
}

function set_cloud_subtitle($type)
{
	switch($type)
	{
		case 'A':
			echo 'Antenna';
			break;

		case 'CA':
			echo 'Contact Antenna';
			break;

		case 'C':
			echo 'Contact';
			break;
	}
}

?>

  document.write('<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>');
  function initialize() {
	var latlng = new google.maps.LatLng(46.000000,15.928906);
	var myOptions = {
	  zoom: 4,
	  center: latlng,
	  mapTypeId: google.maps.MapTypeId.HYBRID
	};

	var map = new google.maps.Map(document.getElementById("map"),myOptions);

	<?php


	foreach($bodies as $key=>$body)
	{
		
		if( $body['latitude'] != 0 && $body['longitude'] != 0 )
		{			
			//multiple entries for website, phone, mail are possible, showing only the first of them!
			// (in line 112: we show $body['xyz'][0])
					
		?>

		var infowindow = new google.maps.InfoWindow();
		var marker<?php echo '_group_id_'.$body['bodyCode']; ?>= new google.maps.Marker({
			position: new google.maps.LatLng(<?php echo $body['latitude']; ?>,<?php echo $body['longitude']; ?>),
			map: map,
			icon: "<?php set_marker_icon($body['bodyStatus']); ?>"});

		google.maps.event.addListener(marker<?php echo '_group_id_'.$body['bodyCode']; ?>, 'click', function() {
		  infowindow.setContent('<div style="line-height: 2.0; font-family:Verdana, Geneva, sans-serif; font-size:12px; text-align:left;"><span style="line-height: 2.0; font-family:Verdana, Geneva, sans-serif; font-size:12px; text-align:left; border-bottom: 3px solid #0066CC; color: #0066CC;"><?php if($body['website']!=''){echo '<a target="_blank" style="text-decoration:none;" href="'.$body['website'].'"><b>';echo $body['bodyName'].'</b></a>';}else{ echo '<b>'.$body['bodyName'].'</b> ('.$body['bodyCode'].')';} ?></span><br />Status: <?php set_cloud_subtitle($body['bodyStatus']); ?><?php echo ( strlen( $body['website'] )>5 ? "<br />Website: <a target=\"_blank\" href=\"".$body['website']."\">Click here!</a>" : "" ); ?><?php echo ( strlen( $body['phone'] )>5 ? "<br />Phone: ".$body['phone'] : "" ); ?><br />E-mail: <a href="mailto:<?php echo $body['mail'];?>"><?php echo $body['mail'];?></a><br /><a target="_parent" href="<?php echo "../details.php?bodyCode=".$body['bodyCode'];?>"><?php echo "Become a member!";?></a></div>');
		  infowindow.open(map, marker<?php echo '_group_id_'.$body['bodyCode']; ?>);});

		<?php
		/*<a href="<?php set_cloud_link($body['bodyStatus'],$body['bodyCode']); ?>" target="blank" style="text-decoration:none"></a>*/
		}
		//if no coordinates, skip local!

 	}
	?>
  }

<?php

/* DEBUG */
/*
foreach($bodies as $key=>$body) {
  set_cloud_subtitle($body['bodyStatus'], $body['bodyCode']);
  echo "\n";
}
print_r($bodies);
*/

?>
