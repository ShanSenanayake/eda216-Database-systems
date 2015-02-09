<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$userId = $_SESSION['userId'];
	$movieName = $_REQUEST['movieName'];
	$_SESSION['movieName'] = $movieName;
	$db->openConnection();
	
	$dates = $db->getDates($movieName);
	$db->closeConnection();
?>

<html>
<head><title>Booking 2</title><head>
<body><h1>Booking 2</h1>
	Current user: <?php print $userId ?>
	<br>
	Selected movie: <?php print $movieName ?>
	<p>
	Performance dates:
	<p>
	<form method=post action="booking3.php">
		<select name="date" size=10>
		<?php
			$first = true;
			foreach ($dates as $row) {

				if ($first) {
					print "<option selected>";
					$first = false;
				} else {
					print "<option>";
				}
				print $row['performanceDate'];
				
			}
		?>
		</select>		
		<input type=submit value="Select date">
	</form>
</body>
</html>
