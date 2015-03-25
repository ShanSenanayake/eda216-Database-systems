<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$pallet = $_REQUEST['pallet'];
	$pallet = split(" ",$pallet);
	$db->openConnection();
	$db->blockPallet($pallet[0]);
	$db->closeConnection();
?>

<html>
<head><title>Blocking</title><head>
<body><h1>Blocking</h1>
	Successfully blocked pallet with id <?php print $pallet[0];?>
	</form>
<form method="post" action="index.php">
		<input type=submit value="Return to home page">
</form>	
</body>
</html>
