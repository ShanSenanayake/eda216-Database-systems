<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$cookieName = $_REQUEST['cookieName'];
	$nbrPallets = $_REQUEST['nbrPallets'];
	$db->openConnection();
	
	$BatchID = $db->createBatch($cookieName,$nbrPallets);
	$db->closeConnection();
?>

<html>
<head><title>Produced Batch</title><head>
<body><h1>Produced Batch</h1>
	<?php
		if ($BatchID<0) {
			print "Could not create batch";
		}else{
			print "Created batch with id " . $BatchID;
		}
	?>
<form action="index.php">
    <input type="submit" value="Return to home page">
</form>
</body>
</html>
