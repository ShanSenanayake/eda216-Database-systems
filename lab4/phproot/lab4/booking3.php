<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$userId = $_SESSION['userId'];
	$movieName = $_SESSION['movieName'];
	$date = $_REQUEST['date'];
	$_SESSION['date'] = $date;
	$db->openConnection();
	
	$data = $db->getTheatreInfo($movieName, $date);
	$db->closeConnection();
?>

<html>
<head><title>Booking 3</title><head>
<body><h1>Booking 3</h1>
	Current user: <?php print $userId ?>
	<p>
	Data for selected performance:
	<p>
	<table>
  <tr>
    <td>Movie</td>
    <td><?php print $movieName?></td>
  </tr>
  <tr>
    <td>Date</td>
    <td><?php print $date?></td>
  </tr>
  <tr>
    <td>Theatre</td>
    <td><?php
			foreach ($data as $row) {
				

				
			
				print $row['theatreName'];
					
				
			}
		?></td>
  </tr>
  <tr>
    <td>Free seats</td>
    <td><?php

			foreach ($data as $row) {


				
				print $row['seats'];

			}
		?></td>
  </tr>
</table>
<form method="post" action="booking4.php">
		<input type=submit value="Book Ticket">
</form>		

</body>
</html>
