<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$userId = $_SESSION['userId'];
	$movieName = $_SESSION['movieName'];
	$date = $_SESSION['date'];
	$db->openConnection();
	
	$bookNumber = $db->bookTicket($movieName,$date,$userId);
	$db->closeConnection();
?>

<html>
<head><title>Booking 4</title><head>
<body><h1>Booking 4</h1>
	<?php print $bookNumber;?>
	</form>
<form method="post" action="booking1.php">
		<input type=submit value="New Booking">
</form>	
</body>
</html>
