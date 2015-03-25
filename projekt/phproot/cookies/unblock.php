<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$pallet = $_SESSION['unblock'];
	$db->openConnection();
	$db->unblockPallet($pallet);
	$db->closeConnection();
?>

<html>
<head><title>Unblocking</title><head>
<body><h1>Unblocking</h1>
	Successfully unblocked pallet with id <?php print $pallet;?>
	</form>
<form method="post" action="index.php">
		<input type=submit value="Return to home page">
</form>	
</body>
</html>
